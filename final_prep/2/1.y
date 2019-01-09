%{
    #include <stdio.h>
    #include <string.h>

    int yylex(void);
    int yyparse(void);
    int yyerror(char*);

    char* concat(char*, char*, char*);

    extern FILE* yyin;
    char* buffer;
%}

%union {
    char* string;
}

%token <string> T_INT
%token T_PLUS T_MINUS T_STAR T_DIVIDE T_LB T_RB T_EOL

%left T_PLUS T_MINUS
%left T_STAR T_DIVIDE
%left UMINUS

%start Stmt
%type <string> Exp

%%
Stmt: Stmt Exp T_EOL {
    printf("Prefix: %s\n", $2);
    strcat(buffer, $2);
    strcat(buffer, "\n");
}
| /* epsilon */
;
Exp: Exp T_PLUS Exp { $$ = concat("+", $1, $3); }
| Exp T_MINUS Exp { $$ = concat("-", $1, $3); }
| Exp T_STAR Exp { $$ = concat("*", $1, $3); }
| Exp T_DIVIDE Exp { $$ = concat("/", $1, $3); }
| T_MINUS Exp %prec UMINUS { $$ = concat("-", $2, NULL); }
| T_LB Exp T_RB { $$ = $2; }
| T_INT { $$ = strdup($1); }
;
%%
int main(int argc, char** argv)
{
    buffer = malloc(sizeof(char) * 2000);
    yyin   = fopen(argv[1], "r");

    int result = yyparse();

    FILE* file = fopen("output", "w");
    fprintf(file, "%s", buffer);
    fclose(file);
    free(buffer);
}

int yyerror(char* message)
{
    printf("Error: %s\n", message);
}

char* concat(char* first, char* second, char* third)
{
    int length   = strlen(first) + strlen(second) + strlen(third) + 4;
    char* string = malloc(sizeof(char) * length);

    strcpy(string, first);
    strcat(string, " ");
    strcat(string, second);
    strcat(string, " ");
    strcat(string, third);
    strcat(string, " ");

    return string;
}