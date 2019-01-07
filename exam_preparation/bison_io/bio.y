%{
    #include <stdio.h>
    #include <string.h>

    extern FILE* yyin;

    int yylex(void);
    int yyparse(void);
    int yyerror(char*);
%}

%token T_TRUE T_FALSE T_AND T_OR T_NOT T_EOL T_LB T_RB

%union {
    struct Var {
        int value;
        char* content;
    } variable;
}

%left T_OR
%left T_AND
%right T_NOT

%start Stmt
%type <variable> Bexp

%%
Stmt: Stmt Bexp T_EOL {
    printf("%s ", $2.content);
    
    if ($2.value) {
        printf("= True\n");
    } else {
        printf("= False\n");
    }
}
| /* epsilon */
;
Bexp: Bexp T_OR Bexp {
    $$.value = $1.value || $3.value;

    char* string = malloc(sizeof(char) * (strlen($1.content) + strlen($3.content) + 5));
    strcpy(string, $1.content);
    strcat(string, " or ");
    strcat(string, $3.content);

    $$.content = string;
}
| Bexp T_AND Bexp { 
    $$.value = $1.value && $3.value;

    char* string = malloc(sizeof(char) * (strlen($1.content) + strlen($3.content) + 6));
    strcpy(string, $1.content);
    strcat(string, " and ");
    strcat(string, $3.content);

    $$.content = string;
}
| T_NOT Bexp { 
    $$.value = !$2.value; 
    
    char* string = malloc(sizeof(char) * (strlen($2.content) + 5));
    strcpy(string, "not ");
    strcat(string, $2.content);

    $$.content = string;
}
| T_LB Bexp T_RB { $$.value = $2.value; $$.content = $2.content; }
| T_TRUE { 
    $$.value   = 1;
    $$.content = malloc(sizeof(char) * 6);
    $$.content = strcpy($$.content, "true");
}
| T_FALSE { 
    $$.value   = 0;
    $$.content = malloc(sizeof(char) * 7);
    $$.content = strcpy($$.content, "false");
}
;
%%
int main(int argc, char** argv)
{
    int result;

    if (argc < 2) {
        result = yyparse();
    } else {
        yyin   = fopen(argv[1], "r");
        result = yyparse();
    }
}
int yyerror(char* message)
{
    printf("Error: %s\n", message);
}