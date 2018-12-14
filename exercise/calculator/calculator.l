%{
#include "calculator.tab.h"
%}
%%
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"|" { return ABS; }
"(" { return OP; }
")" { return CP; }
"//".*\n /* ignoring comments untill new line occures */
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
\n { return EOL; }
[\t ] { /* Ignore whitespaces */ }
. { printf("Mystery character %c\n", *yytext); }
%%