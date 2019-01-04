%{
    #include <string.h>
    #include "kangaroo_calculator.tab.h"
%}
INTEGER_DIGIT (0|[1-9][0-9]*)
DOUBLE_DIGIT (0|[1-9][0-9]*)"."[0-9]+
KEYWORD_INT "int"
KEYWORD_DOUBLE "double"
VARIABLE_NAME [a-zA-Z][_a-zA-Z0-9]*
%%
{KEYWORD_DOUBLE} {
    return DOUBLE_DECL;
}
{KEYWORD_INT} {
    return INT_DECL;
}
{INTEGER_DIGIT} {
    yylval.var.value.int_value = atoi(yytext);

    return INT_VAL;
}
{DOUBLE_DIGIT} {
    yylval.var.value.double_value = atof(yytext);

    return DOUBLE_VAL;
}
{VARIABLE_NAME} {
    int size = sizeof(yytext);

    yylval.var.name = strdup(yytext);

    return VARIABLE;
}
";" {
    return DELIMITER;
}
"+" {
    return PLUS;
}
"-" {
    return MINUS;
}
"*" {
    return TIMES;
}
"/" {
    return DIVIDE;
}
"(" {
    return OB;
}
")" {
    return CB;
}
[ \t\n]+ {
    /* ignoring whitespaces */
}
. {
    printf("Unrecognized character: %c\n", yytext);
    return -1;
}
%%