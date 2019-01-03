%{
#include <stdio.h>
#include <stdlib.h>
%}
%token T_Int
%%
S : S exp '\n' {printf("=%d\n", $2);} | ;
exp:      T_Int           { $$ = $1;         }
        | exp exp '+'     { $$ = $1 + $2;    }
        | exp exp '-'     { $$ = $1 - $2;    }
        | exp exp '*'     { $$ = $1 * $2;    }
        | exp exp '/'     { $$ = $1 / $2;    }
;
%%
main ()   
{
  yyparse ();
}

yyerror ( char *s)  
{
  printf ("%s\n", s);
}
