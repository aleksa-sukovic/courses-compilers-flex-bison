%{
    #include <string.h>
    #include <stdio.h>

    int yylex(void);
    int yyparse(void);
    int yyerror(char*);

    char* addOperator(char* opr, char* arg1, char* arg2);
%}

%union {
    char* string;
    int value;
}

%token <string> T_INT
%token <value>  T_PLUS T_MINUS T_STAR T_DIVIDE T_MOD T_SHR T_SHL T_LB T_RB T_EOL

%type <string> Expression
%start Statement

%left T_PLUS T_MINUS
%left T_STAR T_DIVIDE T_MOD
%left T_SHL T_SHR

%%
Statement: Statement Expression T_EOL {
    printf("%s\n", $2);
}
| /* epsilon */
;
Expression: Expression T_PLUS Expression {
    $$ = addOperator("+", $1, $3);
}
| Expression T_MINUS Expression {
    $$ = addOperator("-", $1, $3);
}
| Expression T_STAR Expression {
    $$ = addOperator("*", $1, $3);
}
| Expression T_DIVIDE Expression {
    $$ = addOperator("/", $1, $3);
}
| Expression T_MOD Expression {
    $$ = addOperator("%", $1, $3);
}
| Expression T_SHL Expression {
    $$ = addOperator("<<", $1, $3);
}
| Expression T_SHR Expression {
    $$ = addOperator(">>", $1, $3);
}
| T_LB Expression T_RB {
    $$ = strdup($2);
}
| T_INT {
    $$ = strdup($1);
}
;
%%
int main()
{
    int result = yyparse();

    if (result) {
        printf("Parsing successful!\n");
    } else {
        printf("Parsing unsuccessful!\n");
    }

}

char* addOperator(char* opr, char* arg1, char* arg2)
{
    char* str = malloc(sizeof(char) * 1000);
    
    strcpy(str, "[");
    strcat(str, opr);
    strcat(str, " ");
    strcat(str, arg1);
    strcat(str, " ");
    strcat(str, arg2);
    strcat(str, "]");

    return str;
}

int yyerror(char* message)
{
    printf("Error: %s\n", message);
}