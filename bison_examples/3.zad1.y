%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}
%token T_int
%token T_abs
%token T_pow

%left '+' '-'
%left '*' '/'
%%
S : S E '\n' {printf("%d\n", $2);} | ;
E:      T_int           { $$ = $1; }
        | E O E     { switch($2){
							case 1:
								$$=$1+$3;
								break;
							case 2:
								$$=$1-$3;
								break;
							case 3:
								$$=$1*$3;
								break;
							case 4:
								$$=$1/$3;
							
						}
					}
		| '(' E ')' {$$=$2;}
		| F '(' E ')' {if($1==1)
							$$=fabs($3);
						else if($1==2)
							$$=pow($3,2);
						}
;
O: '+' {$$=1;}
	| '-' {$$=2;}
	| '*' {$$=3;}
	| '/' {$$=4;}
;
F: T_abs {$$=1;} | T_pow {$$=2;};
%%
main ()   
{
  yyparse ();
}

yyerror ( char *s)  
{
  printf ("%s\n", s);
}
