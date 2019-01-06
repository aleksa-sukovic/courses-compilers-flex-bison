%{
    #include <stdio.h>
	#define TYPE_INT 11
	#define TYPE_DOUBLE 12
%}

%token<int_value> INT_DECL DOUBLE_DECL
%token<var> INT_VAL
%token<var> DOUBLE_VAL
%token<var> VARIABLE
%token PLUS MINUS TIMES DIVIDE
%token OB CB ASSING DELIMITER

%type <var> Exp Statement Term Factor Value

%code requires {
	struct Variable {
		char *name;
		int type;
		union Value {
			int int_value;
			double double_value;
		} value;
	};
}

%union {
	struct Variable var;
}

%%
Calc: Calc Exp DELIMITER { 
	char text[] = "Calculated value: ";

	if ($2.type == TYPE_INT) {
		printf("%s%d\n", text, $2.value.int_value);
	} else if ($2.type == TYPE_DOUBLE ) {
		printf("%s%d\n", text, $2.value.double_value);
	}

	printf("> ");
}
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
	if ($1.type == TYPE_INT && $3.type == TYPE_INT) {
		$$.value.int_value = $1.value.int_value + $3.value.int_value;
	} else if ($1.type == TYPE_INT && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.int_value + $3.value.double_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_INT) {
		$$.value.double_value = $1.value.double_value + $3.value.int_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.double_value + $3.value.double_value;
	} else {
		printf("Unknown variable type type\n");
	}
}
| Statement MINUS Factor {
	if ($1.type == TYPE_INT && $3.type == TYPE_INT) {
		$$.value.int_value = $1.value.int_value - $3.value.int_value;
	} else if ($1.type == TYPE_INT && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.int_value - $3.value.double_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_INT) {
		$$.value.double_value = $1.value.double_value - $3.value.int_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.double_value - $3.value.double_value;
	} else {
		printf("Unknown variable type type\n");
	}
}
| Factor { $$ = $1; }
;
Factor: Factor TIMES Term {
	if ($1.type == TYPE_INT && $3.type == TYPE_INT) {
		$$.value.int_value = $1.value.int_value * $3.value.int_value;
	} else if ($1.type == TYPE_INT && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.int_value * $3.value.double_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_INT) {
		$$.value.double_value = $1.value.double_value * $3.value.int_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.double_value * $3.value.double_value;
	} else {
		printf("Unknown variable type type\n");
	}
}
| Factor DIVIDE Term { 
	if ($1.type == TYPE_INT && $3.type == TYPE_INT) {
		$$.value.int_value = $1.value.int_value / $3.value.int_value;
	} else if ($1.type == TYPE_INT && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.int_value / $3.value.double_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_INT) {
		$$.value.double_value = $1.value.double_value / $3.value.int_value;
	} else if ($1.type == TYPE_DOUBLE && $3.type == TYPE_DOUBLE) {
		$$.value.double_value = $1.value.double_value / $3.value.double_value;
	} else {
		printf("Unknown variable type type\n");
	}
 }
| Term { $$ = $1; }
;
Term: Value   { $$ = $1; }
| MINUS Value { 
	$$ = $2;

	if ($$.type == TYPE_INT) {
		$$.value.int_value = -$$.value.int_value;
	} else if ($$.type == TYPE_DOUBLE) {
		$$.value.double_value = -$$.value.double_value;
	}
  }
;
Value: INT_VAL    { $$.value.int_value = $1.value.int_value; $$.type = TYPE_INT; }
| DOUBLE_VAL      { $$.value.double_value = $1.value.double_value; $$.type = TYPE_DOUBLE; }
| VARIABLE     	  { /* ignore variables for now */ }
| OB Statement CB { $$ = $2; }
%%
int main() {
	printf("> ");
	yyparse();
}
int yyerror(char* msg) {
	printf("Greska: %s\n", msg);
}