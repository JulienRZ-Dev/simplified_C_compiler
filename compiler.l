%{
  #include "y.tab.h"
%}


lettre    [A-Za-z]
lettreMin [a-z]
lettreMaj [A-Z]
chiffre   [0-9]
nombre    {chiffre}+
exp       {nombre}[eE]-?{nombre}
var       {lettre}+(_*{chiffre}*{lettre}*)*

%%

main      { return tMain; }
printf    { return tPrintf; }

if        { return tIf; }
else      { return tElse; }
while     { return tWhile; }

"("       { return tParentheseOuvrante; }
")"       { return tParentheseFermante; }

"{"       { return tCrochetOuvrant; }
"}"       { return tCrochetFermant; }

"const"   { return tConst; }
"int"     { return tInt; }

"+"       { return tAdd; }
"-"       { return tSub; }
"*"       { return tMul; }
"/"       { return tDiv; }
"="       { return tEq; }

"<"       { return tInf; }
">"       { return tSup; }
"=="      { return tEqEq; }

","       { return tComma; }
";"       { return tEndOfInstruction; }


"\t"      
" "       
"\n"      

{var}     { 
            yylval.var = strdup(yytext);
            return tVar; 
          }
{nombre}  { 
            yylval.nombre = atoi(yytext);
            return tNombre; 
          }
{exp}     { return tExp; }

.         printf("ERROR !!! \n");

%%  