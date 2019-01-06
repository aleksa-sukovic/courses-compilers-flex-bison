%{
    #include "t2.tab.h"
%}

DIGIT [1-9][0-9]*|0

%%
{DIGIT} {
    return T_INT;
}
. {
    yylval = yytext[0];
}
\n {
    return T_SEPARATOR;
}
%%