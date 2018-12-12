%{
#include <stdio.h>
#include <stdlib.h>
%}

%%
[ \t\n]*"."[ \t\n]* {printf(". ");}
%%