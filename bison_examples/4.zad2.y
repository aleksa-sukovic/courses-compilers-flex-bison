%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
%}
%union{
	int intValue;
	float floatValue;
	float args[2];
}

%token <intValue>T_Int;
%token <floatValue>T_Float;
%token <intValue>T_abs
%token <intValue>T_pow

%type <floatValue> E
%type <args> L
%type <intValue>F

%left '+' '-'
%left '*' '/'
%right '^'
%left UMINUS
%%
P: P E '\n' {printf("%f\n",$2);}
|;
E :  T_Int { $$=$1;} 
	| T_Float { $$=$1;}
	| E '+' E {$$=$1+$3;} 
	| E '-' E  {$$=$1-$3;}
	| E '*' E  {$$=$1*$3;} 
	| E '/' E  {$$=$1/$3;}
	| E '^' E  {$$=pow($1, $3);}
	| '-' E	%prec UMINUS { $$ = -$2;  }
	| '(' E ')' { $$ = $2; }
	| F '(' L ')' {
					if($1==1){
					//ako je F abs
					 $$=fabs($3[0]);
					}else{
					    $$=pow($3[0],$3[1]);
					}
				}
	;
F: T_abs {$$=1;} | T_pow {$$=2;};
L: E {$$[0]=$1;} 
	| E ',' E {$$[0]=$1; $$[1]=$3;}; 

%%
int yyerror(const char * message){
 	fputs(message,stderr);
	fputc('\n',stderr);
	return 0;
}

int main(){
	yyparse();
	return 0;
}