%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
char*s;
%}
%%
0[xX]([0-9a-fA-F]{1,8}) {printf("HEX broj %s=%ld",yytext,strtol(yytext,&s,16));}
. 
%%