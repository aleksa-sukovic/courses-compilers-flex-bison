%{
    #include "t2.tab.h"
    #include <string.h>
%}

DIGIT [1-9][0-9]*|0

%%
{DIGIT} {
    yylval.string = strdup(yytext);

    return T_INT;
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
"%" {
    return T_MOD;
}
">>" {
    return T_SHR;
}
"<<" {
    return T_SHL;
}
"(" {
    return T_LB;
}
")" {
    return T_RB;
}
\n {
    return T_EOL;
}
. { /* ignoring everything else */ }
%%