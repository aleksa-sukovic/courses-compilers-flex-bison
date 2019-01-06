%{
    #include <stdio.h>
%}

%token T_DIGIT
%token EOL
%token T_PLUS T_MINUS T_STAR T_DIVIDE
%token T_LB T_RB

%left T_PLUS T_MINUS
%left T_STAR T_DIVIDE
%left U_MINUS

%%
Exp: Exp Stmt EOL {
    printf("\n");
}
| /* epsilon */
;
Stmt: T_DIGIT { printf("%d ", $1); $$ = $1; }
| Stmt T_PLUS Stmt { printf("+ "); $$ = $1 + $3; }
| Stmt T_MINUS Stmt { printf("- "); $$ = $1 - $3;  }
| Stmt T_STAR Stmt { printf("* "); $$ = $1 * $3; }
| Stmt T_DIVIDE Stmt { printf("/ "); $$ = $1 / $3; }
| T_MINUS Stmt %prec U_MINUS { printf("- "); $$ = -$2; }
| T_LB Stmt T_RB { $$ = $2; }
%%
int main()
{
    printf("> ");

    if (yyparse() == 1) {
        printf("Conversion complete!\n");
    } else {
        printf("Conversion failed!\n");
    }
}
int yyerror(char* msg) {
	printf("Greska\n");
}
