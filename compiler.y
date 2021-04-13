%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "table.h"

  #define instruction_table_size 1024

  typedef struct {
      int nbOperandes;
      int codeOp;
      int op1;
      int op2;
      int op3;
  } Instruction;

  Instruction instruction_table[instruction_table_size];
  char *table_code[13] = {"NULL", "ADD", "MUL", "SOU", "DIV", "COP", "AFC", "JMP", "JMF", "INF", "SUP", "EQU", "PRI"}; 

  FILE *fp;
  int instructionPointer = 0;
  int depth = 0;

  void writeInstructions() 
  {
        for(int i = 0; i < instructionPointer; i++)
        {
              Instruction instruction = instruction_table[i];

              if(instruction.nbOperandes == 1)
              {
                    fprintf(fp, "%s %d \n", table_code[instruction.codeOp], instruction.op1);
              }
              else if(instruction.nbOperandes == 2)
              {
                  fprintf(fp, "%s %d %d \n", table_code[instruction.codeOp], instruction.op1, instruction.op2);
              }
              else
              {
                  fprintf(fp, "%s %d %d %d \n", table_code[instruction.codeOp], instruction.op1, instruction.op2, instruction.op3);
              }
        }
  }

  int yylex();
  void yyerror(char *);
%}

%union {
  char *var;
  int nombre;
}

%token      tMain
%token      tPrintf

%token      tIf
%token      tElse
%token      tWhile

%token      tParentheseOuvrante
%token      tParentheseFermante

%token      tCrochetOuvrant
%token      tCrochetFermant

%token      tConst
%token      tInt

%token      tAdd
%token      tSub
%token      tMul
%token      tDiv
%token      tEq

%token      tInf
%token      tSup
%token      tEqEq

%token      tComma
%token      tEndOfInstruction

%token      <var> tVar
%token      <nombre> tNombre
%token      <nombre> tExp        

%type       <var>    Variables
%type       <nombre> Value
%type       <nombre> Affectation
%type       <nombre> Operande
%type       <nombre> Entite
%type       <nombre> Cond

%type       <nombre> IfCrochetOuvrant
%type       <nombre> IfCrochetFermant
%type       <nombre> WhileCrochetOuvrant
%type       <nombre> WhileCrochetFermant

%right      tEq
%left       tAdd tSub
%left       tMul tDiv

%%

File:
      Main tParentheseOuvrante tParentheseFermante tCrochetOuvrant
      Body 
      tCrochetFermant
      {
            writeInstructions();
            fclose(fp);
      }
      ;

Main:
  tMain
  {
    fp = fopen("out.asm", "w");
  }
  ;

Body:
      /* */
      |
      InitBody VarDeclarations Instructions
      {
            depth--;
      }
      ;

InitBody:
      /* */
      {
            depth++;
      }


VarDeclarations:
      VarDeclaration VarDeclarations
      |
      /* */
      ;


Instructions:
      Instruction Instructions
      |
      /* */
      ;

Instruction:
      Printf
      |
      Operande
      |
      Affectation
      |
      If
      |
      While
      ;


Type:
      tInt
      |
      tConst
      ;

Value:
      tNombre
      {
            $$ = $1;
      }
      ;

Affectation:
      tVar tEq Value tEndOfInstruction
      {
            int adr = get_index($1, depth); 
            if(adr == -1)
            {
                  printf("NULL POINTER EXCEPTION, %s not found at depth %d \n", $1, depth);
                  exit(1);
            }
            Instruction instruction;
            instruction.nbOperandes = 2;
            instruction.codeOp = 6;
            instruction.op1 = adr;
            instruction.op2 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
      }
      |
      tVar tEq tVar tEndOfInstruction
      {
            int adrTarget = get_index($1, depth); 
            int adrSource = get_index($3, depth);
            if(adrTarget == -1)
            {
                  printf("NULL POINTER EXCEPTION, %s not found at depth %d \n", $1, depth);
                  exit(1);
            }
            if(adrSource == -1)
            {
                  printf("NULL POINTER EXCEPTION, %s not found at depth %d \n", $3, depth);
                  exit(1);
            }
            Instruction instruction;
            instruction.nbOperandes = 2;
            instruction.codeOp = 6;
            instruction.op1 = adrTarget;
            instruction.op2 = adrSource;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
      }
      |
      tVar tEq Operande tEndOfInstruction
      {
            int adr = get_index($1, depth); 
            if(adr == -1)
            {
                  printf("NULL POINTER EXCEPTION, %s not found at depth %d \n", $1, depth);
                  exit(1);
            }
            Instruction instruction;
            instruction.nbOperandes = 2;
            instruction.codeOp = 5;
            instruction.op1 = adr;
            instruction.op2 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
      }
      ;


Variables:
      tVar tEndOfInstruction
      {
            int adr = put_symbole($1, depth); 
            if(adr == -1)
            {
                  printf("variable %s is already declared \n", $1);
                  exit(1);
            }
      }
      |
      tVar tComma Variables
      {
            int adr = put_symbole($1, depth); 
            if(adr == -1)
            {
                  printf("variable %s is already declared \n", $1);
                  exit(1);
            }
      }
      ;

VarDeclaration:
      Type Variables
      ;


Printf:
      tPrintf tParentheseOuvrante tVar tParentheseFermante tEndOfInstruction
      {
            int adr = get_index($3, depth); 
            if(adr == -1)
            {
                  printf("NULL POINTER EXCEPTION, %s not found at depth %d \n", $3, depth);
                  exit(1);
            }
            Instruction instruction;
            instruction.nbOperandes = 1;
            instruction.codeOp = 12;
            instruction.op1 = adr;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
      }
      ;


Entite:
      Value
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 2;
            instruction.codeOp = 6;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
      }
      |
      tVar
      {
            int adr = get_index($1, depth);
            if(adr == -1)
            {
                  printf("NULL POINTER EXCEPTION, %s not found at depth %d \n", $1, depth);
                  exit(1);
            }
            $$ = adr;
      }
      ;


Operande:
      tParentheseOuvrante Operande tParentheseFermante
      {
            $$ = $2;
      }
      |
      Operande tAdd Operande
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 1;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      |
      Operande tSub Operande
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 3;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      |
      Operande tMul Operande
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 2;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      |
      Operande tDiv Operande
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 4;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      |
      Entite
      ;

If:
      tIf tParentheseOuvrante Cond tParentheseFermante IfCrochetOuvrant Body IfCrochetFermant
      {
            int adrCond = $3;
            int indexJump = $5;
            int adrJump = $7;

            Instruction instruction;
            instruction.nbOperandes = 2;
            instruction.codeOp = 8;
            instruction.op1 = adrCond;
            instruction.op2 = adrJump;
            instruction_table[indexJump] = instruction;
      }
      ;

IfCrochetOuvrant:
      tCrochetOuvrant
      {
            $$ = instructionPointer;
            instructionPointer++;
      }
      ;

IfCrochetFermant:
      tCrochetFermant
      {
            $$ = instructionPointer;
      }
      ;

Cond:
      Entite
      {
            $$ = $1;
      }
      |
      Entite tInf Entite
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 9;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      |
      Entite tSup Entite
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 10;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      |
      Entite tEqEq Entite
      {
            int adr = push();
            Instruction instruction;
            instruction.nbOperandes = 3;
            instruction.codeOp = 11;
            instruction.op1 = adr;
            instruction.op2 = $1;
            instruction.op3 = $3;
            instruction_table[instructionPointer] = instruction;
            instructionPointer++;
            $$ = adr;
            pop();
            pop();
            pop();
      }
      ;

While:
      tWhile tParentheseOuvrante Cond tParentheseFermante WhileCrochetOuvrant Body WhileCrochetFermant
      {
            int adrCond = $3;
            int indexJump = $5;
            int adrJump = $7;

            // Instruction saut conditionnel
            Instruction instructionCond;
            instructionCond.nbOperandes = 2;
            instructionCond.codeOp = 8;
            instructionCond.op1 = adrCond;
            instructionCond.op2 = adrJump;
            instruction_table[indexJump] = instructionCond;

            // Instruction saut inconditionnel
            Instruction instructionIncond;
            instructionIncond.nbOperandes = 1;
            instructionIncond.codeOp = 7;
            instructionIncond.op1 = indexJump;
            instruction_table[instructionPointer] = instructionIncond;
            instructionPointer++;
      }
      ;

WhileCrochetOuvrant:
      tCrochetOuvrant
      {
            $$ = instructionPointer;
            instructionPointer++;
      }
      ;

WhileCrochetFermant:
      tCrochetFermant
      {
            $$ = instructionPointer + 1;
      }
      ;

%%