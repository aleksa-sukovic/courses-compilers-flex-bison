%{
    #include "kng_calc.tab.h"    
    #include <string.h>
%}

FUNCTION "function "
NAME [a-zA-Z_][a-zA-Z0-9_]*
INTEGER [1-9][0-9]*|0
REAL ([1-9][0-9]*|0)"."[0-9]+

%x LINE_COMMENT MULTI_COMMENT

%%
"abs" {
    yylval.string_value = strdup(yytext);

    return T_FUNCTION_ABS;
}
"pow" {
    yylval.string_value = strdup(yytext);

    return T_FUNCTION_POW;
}
{INTEGER} {
    yylval.int_value = atoi(yytext);

    return T_INT;
}
{REAL} {
    yylval.float_value = atoi(yytext);

    return T_FLOAT;
}
{NAME} {
    yylval.string_value = strdup(yytext);

    return T_VARIABLE;
}
"+" {
    return T_PLUS;
}
"-" {
    return T_MINUS;
}
"*" {
    return T_STAR;
}
"/" {
    return T_DIVIDE;
}
"(" {
    return T_OB;
}
")" {
    return T_CB;
}
"," {
    return T_COMMA;
}
"=" {
    return T_EQUALS;
}
";" {
    return T_EOL;
}
"//" {
    BEGIN(LINE_COMMENT);
}
<LINE_COMMENT>.
<LINE_COMMENT>\n { BEGIN(INITIAL); }
"/*" { BEGIN(MULTI_COMMENT); }
<MULTI_COMMENT>.|\n
<MULTI_COMMENT>"*/" { BEGIN(INITIAL); }
.|\n { /* ignoring everything else */ }
%%