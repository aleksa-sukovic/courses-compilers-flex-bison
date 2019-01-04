%{
    #include "postfix.tab.h"
%}
DIGIT [1-9][0-9]*|0
%%
{DIGIT} {
    yylval = atoi(yytext);

    return T_DIGIT;
}
"(" {
    return T_LB;
}
")" {
    return T_RB;
}
"-" {
    return T_MINUS;
}
"+" {
    return T_PLUS;
}
"*" {
    return T_STAR;
}
"/" {
    return T_DIVIDE;
}
\n {
    return EOL;
}
. { /* Ignoring everything else */ }
%%