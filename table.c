#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "table.h"
#define table_length 1024

typedef struct
{
  char *name;
  int depth;
}Symbole;

Symbole table[table_length];

static int head = 0;
static int stack_pointer = table_length - 1;

// Si le symbole n'appartient pas à la table retourne -1, sinon retourne son index
int get_index(char* symbole, int depth)
{
  int tmp = depth;
  
  while(tmp > 0) {
    for(int i = 0; i < head; i++)
    {
      if((strcmp(table[i].name, symbole) == 0) && (tmp == table[i].depth))
      {
        return i;
      }
    }
    tmp--;
  }
  return -1;
}

int get_index_at_fixed_depth(char* symbole, int depth) {
  for(int i = 0; i < head; i++)
  {
    if((strcmp(table[i].name, symbole) == 0) && (depth == table[i].depth))
    {
      return i;
    }
  }
  return -1;
}


// Si le symbole appartient à la table retourne -1, sinon l'ajoute et retourne 0
int put_symbole(char* symbole, int depth)
{
  // On doit vérifier que le symbole n'est pas déjà dans la table des symboles à la profondeur depth
  if(get_index_at_fixed_depth(symbole, depth) == -1)
  {
    table[head].name = symbole;
    table[head].depth = depth;
    head += 1;
    return head - 1;
  }
  else 
  {
    return -1;
  }
}

int push()
{
  stack_pointer -= 1;
  return stack_pointer + 1;
}

void pop()
{
  stack_pointer += 1;
}

void printMemory() {
  for(int i = 0; i < head; i++)
  {
    printf("adr %d : [symbole : %s; depth: %d] \n", i, table[i].name, table[i].depth);
  }
}