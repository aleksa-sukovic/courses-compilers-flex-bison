%{
#include "3.zad1.tab.h"
%}

%%
[1-9][0-9]{0,8}|0 { yylval=atoi(yytext);
			return T_int;		
		}
[-+*/')'='(','\n']		{
				return yytext[0];
			}
"abs"		{ return T_abs;}
"pow"		{ return T_pow;}	
%%