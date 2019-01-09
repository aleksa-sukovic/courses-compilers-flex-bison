%{
    #include "1.tab.h"    
    #include <string.h>
%}
%%
[1-9][0-9]* {
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
"(" {
    return T_LB;
}
")" {
    return T_RB;
}
";" {
    return T_EOL;
}
<<EOF>> {
    printf("END OF FILE\n");
    return 0;
}
.|\n { /* ignore everything else */ }
%%