%{
    #include <stdio.h>

    struct Counter {
        int l1Words;
        int l2Words;
        int l3Words;
    } *counter;

    void initialize(void);
    struct Counter* newCounter();

%}

%token  T_L2 T_L3 T_NW

%%
Exp: Exp Language T_NW
| /* epsilon */
;
Language: Ones A B Ones {
    counter->l1Words++;
}
| T_L2 {
    counter->l2Words++;
}
| T_L3 {
    counter->l3Words++;
}
;
A: '1' A '0'
| /* epsilon */
;
B: '0' B '1'
| /* epsilon */
;
Ones: '1' Ones
| /* epsilon */
;
%%
int main()
{
    initialize();
    yyparse();
    printf("L1: %d\n", counter->l1Words);
    printf("L2: %d\n", counter->l2Words);
    printf("L3: %d\n", counter->l3Words);
}

void initialize()
{
    counter = newCounter();
}

struct Counter* newCounter()
{
    struct Counter *cnt = malloc(sizeof(struct Counter));
    
    cnt->l1Words = 0;
    cnt->l2Words = 0;
    cnt->l3Words = 0;

    return cnt;
}

int yyerror(char* message)
{
    printf("Error: %s\n", message);
}