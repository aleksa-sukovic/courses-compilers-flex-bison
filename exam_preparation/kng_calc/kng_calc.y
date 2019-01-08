%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>

    int yylex(void);
    int yyparse(void);
    int yyerror(char*);

    struct Node {
        char* name;
        float value;
        struct Node* next;
    };
    struct Node* listHead = NULL;

    void addToList(char*, float);
    struct Node* newNode(char*, float);
    struct Node* findVariable(char*);

%}

%union {
    int int_value;
    float float_value;
    char* string_value;
    float args[2];
}

%token <int_value> T_INT
%token <float_value> T_FLOAT
%token <string_value> T_FUNCTION_NAME T_VARIABLE
%token <int_value> T_PLUS T_MINUS T_STAR T_DIVIDE T_OB T_CB T_COMMA T_EOL T_EQUALS T_FUNCTION_POW T_FUNCTION_ABS

%left T_PLUS T_MINUS
%left T_STAR T_DIVIDE
%left UMINUS

%start Entity
%type <float_value> Expression
%type <int_value> Function
%type <args> Arguments

%%
Entity: Entity Statement T_EOL
| /* epsilon */
;
Statement: Expression {
    printf("%f\n", $1);
}
| T_VARIABLE T_EQUALS Expression {
    struct Node* variable = findVariable($1);

    if (variable == NULL) {
        addToList($1, $3);
    } else {
        variable->value = $3;
    }
}
;
Expression: Expression T_PLUS Expression {
    $$ = $1 + $3;
}
| Expression T_MINUS Expression {
    $$ = $1 - $3;
}
| Expression T_STAR Expression {
    $$ = $1 * $3;
}
| Expression T_DIVIDE Expression {
    $$ = $1 / $3;
}
| T_MINUS Expression %prec UMINUS {
    $$ = -$2;
}
| T_OB Expression T_CB {
    $$ = $2;
}
| Function T_OB Arguments T_CB {
    if ($1 == 1) {
        $$ = fabs($3[0]);
    } else if ($1 == 2) {
        $$ = pow($3[0], $3[1]);
    }
}
| T_INT { $$ = $1; }
| T_FLOAT { $$ = $1; }
| T_VARIABLE {
    struct Node* variable = findVariable($1);

    if (variable == NULL) {
        printf("Unknown variable: %s!\n", $1);
        return -1;
    }

    $$ = variable->value;
}
;
Function: T_FUNCTION_ABS { $$ = 1; }
| T_FUNCTION_POW { $$ = 2; }
;
Arguments: Expression T_COMMA Expression { $$[0] = $1; $$[1] = $3; }
| Expression { $$[0] = $1; }
;
%%
int main()
{
    yyparse();
}

void addToList(char* name, float value)
{
    if (findVariable(name) != NULL) {
        printf("Variable \'%s\' is already declared!\n", name);
        return;
    }

    struct Node* node = newNode(name, value);
    node->next        = listHead;
    listHead          = node;
}

struct Node* findVariable(char* name)
{
    struct Node* found   = NULL;
    struct Node* current = listHead;

    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            found = current;
            break;
        }

        current = current->next;
    }

    return found;
}

struct Node* newNode(char* name, float value)
{
    struct Node* result = malloc(sizeof(struct Node));

    if (!result) {
        printf("Unable to allocate memory for new node!");
        return NULL;
    }

    result->name  = strdup(name);
    result->value = value;
    result->next  = NULL;

    return result;
}

int yyerror(char* message)
{
    printf("Error: %s\n", message);
}