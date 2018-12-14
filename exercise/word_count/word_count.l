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
    yylex();

    printf("Characters: %d Words: %d Lines: %d\n", characters, words, lines);
}