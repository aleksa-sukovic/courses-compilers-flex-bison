%{
    #include <stdio.h>
%}

%token INT_DECL DOUBLE_DECL
%token<value> INT_VAL
%token<value> DOUBLE_VAL
%token<variable> VARIABLE
%token PLUS MINUS TIMES DIVIDE
%token OB CB ASSING DELIMITER

%type <value> Value Statement Factor Term Exp

%code requires {
	struct Value {
		int type;
		int sign;
		int int_value;
		double double_value;
	};

	struct Variable {
		char name[100];
		struct Value value;
	};
}
%union {
	struct Value value;
	struct Variable variable;
}

%%
Calc: Calc Exp DELIMITER { printf("Calculated value: %d\n", $2.int_value); }
| /* epsilon */
;
Exp: Statement { $$ = $1; }
| Declaration  { /* ignore declarations for now */ }
;
Declaration: Type VARIABLE ASSING Statement
;
Type: INT_DECL
| DOUBLE_DECL
;
Statement: Statement PLUS Factor {
	if ($1.type == INT_DECL && $3.type == INT_DECL) {
		$$.int_value = $1.int_value + $3.int_value;
		$$.sign = $$.int_value >= 0 ? 1 : -1;
		$$.type = INT_DECL;
	}
}
| Statement MINUS Factor {
	if ($1.type == INT_DECL && $3.type == INT_DECL) {
		$$.int_value = $1.int_value - $3.int_value;
		$$.sign = $$.int_value >= 0 ? 1 : -1;
		$$.type = INT_DECL;
	}
}
| Factor { $$ = $1; }
;
Factor: Factor TIMES Term {
	if ($1.type == INT_DECL && $3.type == INT_DECL) {
		$$.int_value = $1.int_value * $3.int_value;
		$$.sign = $$.int_value >= 0 ? 1 : -1;
		$$.type = INT_DECL;
	}
}
| Factor DIVIDE Term { 
	if ($1.type == INT_DECL && $3.type == INT_DECL) {
		$$.type = INT_DECL;
		$$.int_value = $1.int_value / $3.int_value;
		$$.sign = $1.int_value * $3.int_value >= 0 ? 1 : -1;
	}
 }
| Term { $$ = $1; }
;
Term: Value   { $$ = $1; $$.sign = 1; }
| MINUS Value { $$ = $2; $$.int_value = -$$.int_value; }
;
Value: INT_VAL    { $$.int_value = $1.int_value; $$.type = INT_DECL; }
| DOUBLE_VAL      { $$.double_value = $1.double_value; $$.type = DOUBLE_DECL; }
| VARIABLE     	  { /* ignore variables for now */ }
| OB Statement CB { $$ = $2; }
%%
int main() {
	yyparse();
}
int yyerror(char* msg) {
	printf("Greska: %s\n", msg);
}