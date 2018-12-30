%{
    #include "kangaroo_calculator.tab.h"
%}
INTEGER_DIGIT (0|[1-9][0-9]*)
DOUBLE_DIGIT (0|[1-9][0-9]*)"."[0-9]+
KEYWORD_INT "int"
KEYWORD_DOUBLE "double"
VARIABLE_NAME [a-zA-Z][_a-zA-Z0-9]*
%%
{KEYWORD_DOUBLE} {
    printf("Keyword double: %s\n", yytext);
}
{KEYWORD_INT} {
    printf("Keyword int: %s\n", yytext);
}
{INTEGER_DIGIT} {
    printf("Integer digit: %s\n", yytext);
}
{DOUBLE_DIGIT} {
    printf("Double digit: %s\n", yytext);
}
{VARIABLE_NAME} {
    printf("Variable name: %s\n", yytext);
}
";" {
    printf("Expression end");
}
"+" {
    printf(" Plus \n");
}
"-" {
    printf(" Minus \n");
}
"*" {
    printf(" Times \n");
}
"/" {
    printf(" Divided \n");
}
[ \t\n]+ {
    /* ignoring whitespaces */
}
. {
    printf("Unrecognized character: %c\n", yytext);
    return -1;
}
%%