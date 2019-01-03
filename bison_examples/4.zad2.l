%{
#include "4.zad2.tab.h"
%}

%%
[1-9][0-9]{0,8}|0 { yylval.intValue=atoi(yytext);
					return T_Int;		
					}
([1-9][0-9]{0,8}|0)"."[0-9]{1,6} {
					yylval.floatValue=atof(yytext);
					return T_Float;				
				}
"abs"		{ return T_abs;}
"pow"		{ return T_pow;}
[-+*^/')''(','\n']		{
				return yytext[0];
			}

%%