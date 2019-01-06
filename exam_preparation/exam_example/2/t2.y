%{
    #include <stdio.h>

    int yyparse(void);
    int yyerror(char*);
    int yylex(void);
%}

%token T_INT T_SEPARATOR T_PLUS T_MINUS T_START T_DIVIDE T_MOD T_LSH T_RSH

%left '+' '-'
%left '*' '/' '%'
%left "<<" ">>"

%%
E: T_INT
| '(' E ')'
| E Op E
;
Op: '+'
| '-'
| '*'
| '/'
| '%'
| "<<"
| ">>"
;
%%
int yyerror(char* message)
{
    printf("Error: %s\n", message);
}
