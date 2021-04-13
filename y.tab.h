/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tMain = 258,
    tPrintf = 259,
    tIf = 260,
    tElse = 261,
    tWhile = 262,
    tParentheseOuvrante = 263,
    tParentheseFermante = 264,
    tCrochetOuvrant = 265,
    tCrochetFermant = 266,
    tConst = 267,
    tInt = 268,
    tAdd = 269,
    tSub = 270,
    tMul = 271,
    tDiv = 272,
    tEq = 273,
    tInf = 274,
    tSup = 275,
    tEqEq = 276,
    tComma = 277,
    tEndOfInstruction = 278,
    tVar = 279,
    tNombre = 280,
    tExp = 281
  };
#endif
/* Tokens.  */
#define tMain 258
#define tPrintf 259
#define tIf 260
#define tElse 261
#define tWhile 262
#define tParentheseOuvrante 263
#define tParentheseFermante 264
#define tCrochetOuvrant 265
#define tCrochetFermant 266
#define tConst 267
#define tInt 268
#define tAdd 269
#define tSub 270
#define tMul 271
#define tDiv 272
#define tEq 273
#define tInf 274
#define tSup 275
#define tEqEq 276
#define tComma 277
#define tEndOfInstruction 278
#define tVar 279
#define tNombre 280
#define tExp 281

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 48 "compiler.y" /* yacc.c:1909  */

  char *var;
  int nombre;

#line 111 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
