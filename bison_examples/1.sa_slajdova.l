%{
#include "1.sa_slajdova.tab.h"
%}

%%
[1-9][0-9]*|0	{yylval = atoi(yytext);
		return T_Int;
		}
[-+*/\n]		{
				return yytext[0];
			}
%%
