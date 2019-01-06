%{
    #include "t1.tab.h"    
%}

L2 &1*(0|011)*010(1|00|011)*(0|01)&$
L3 &1(0|1)*0|0(0|1)*1$

%%
{L2} {
    return T_L2;
}
{L3} {
    return T_L3;
}
. {
    return yytext[0];
}
[ \n\t] {
    return T_NW;
}
%%