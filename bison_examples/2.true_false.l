%{
#include "2.true_false.tab.h"
%}

%%
"AND"|"and" {return T_and;}
"OR"|"or" {return T_or;}
"NOT"|"not" {return T_not;}
"T"|"t"	{
	yylval=1;
	return T_true;	
	} 
"F"|"f"	{
	yylval=0;
	return T_false;	
	} 
[')''(''\n']	{return yytext[0];}
.	{}
%%
