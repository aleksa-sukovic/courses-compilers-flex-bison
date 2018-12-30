%{
    #include <stdio.h>    
%}
%token INT_DECL DOUBLE_DECL
%token INT_VAL DOUBLE_VAL
%token VARIABLE
%token PLUS MINUS TIMES DIVIDE
%token OB CB ASSING
%%
Calc: /* epsilon */
| Exp ";" Calc
;
Exp: Statement
| Declaration
;
Declaration: Type VARIABLE ASSING Statement
;
Type: INT_DECL
| DOUBLE_DECL
;
Statement: Statement PLUS Factor
| Statement MINUS Factor
| Factor
;
Factor: Factor TIMES Term
| Factor DIVIDE Term
| Term
;
Term: Value
| '-'Value
;
Value: INT_VAL
| DOUBLE_VAL
| OB Statement CB
%%
int main() {
	if (yyparse() == 0) {
		printf("Input is valid.\n");
	} else {
		printf("Input is not valid.\n");
	}
}
int yyerror(char* msg) {
	printf("Greska\n");
}