%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "fb3-1.h"
%}
%union {
    struct AST* tree;
    double doubleValue;
}

/* Declaring tokens */
%token <doubleValue> NUMBER
%token EOL
%type <tree> exp factor term

%%
calclist: /* epsilon */
| calclist exp EOL {
    printf("=%4.4g\n", eval($2));
    freeTree($2);
}
| calclist EOL { printf(">"); }
;
exp: factor
| exp '+' factor { $$ = newAST('+', $1, $3); }
| exp '-' factor { $$ = newAST('-', $1, $3); }
;
factor: term
| factor '*' term { $$ = newAST('*', $1, $3); }
| factor '/' term { $$ = newAST('/', $1, $3); }
;
term: NUMBER { $$ = newNum($1); }
| '|' term { $$ = newAST('|', $2, NULL); }
| '('exp')' { $$ = $2; }
| '-'term { $$ = newAST('M', $2, NULL); }
%%