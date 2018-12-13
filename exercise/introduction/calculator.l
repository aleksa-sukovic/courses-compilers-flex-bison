%{
#include "calculator.tab.h"
%}
%%
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"|" { return ABS; }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
\n { return EOL; }
[\t ] { /* Ignore whitespaces */ }
. { printf("Mystery character %c\n", *yytext); }
%%