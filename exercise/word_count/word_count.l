%option noyywrap
%{
int words = 0;
int characters = 0;
int lines = 0;
%}
%%
[a-zA-z]+ {
    words++;
    characters += strlen(yytext);
}
\n {
    lines++;
    characters++;
}
. {
    characters++;
}
%%
int main(int argc, char **argv)
{
    if (argc > 1) {
        if ( !(yyin = fopen(argv[1], "r")) ) {
            perror(argv[1]);
            return(1);
        }
    }

    yylex();

    printf("Characters: %d Words: %d Lines: %d\n", characters, words, lines);
}