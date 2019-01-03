%{
#include <stdlib.h>
#include <stdio.h>
%}

//f or f and f or t - ako damo veci prioritet OR-u, nije isto

%token T_and T_or T_not T_true T_false

%left T_or T_and
%right T_not
%%
S:S bexp '\n' { if($2==1){
		printf("TRUE\n");	
	 }else{
		printf("FALSE\n");		
	}
       }
|;
bexp: T_true {$$=1;}
	| T_false {$$=0;} 
	| bexp T_or bexp {$$=$1 || $3; } 
	| bexp T_and bexp {$$=$1 && $3;}
	| T_not bexp {$$=1-$2;}
	| '(' bexp ')' {$$=$2;}
;
%%
int yyerror(const char* message){
	fputs(message,stderr);
	fputc('\n',stderr);
	return 0;
}
int main(){
	yyparse();
	return 0;
}
