%{
	#include "calc_p1.tab.h"
	#include <string.h>
%}
%x L_COMMENT
%%
"//"					{BEGIN(L_COMMENT);}
[0-9]+					{ yylval.int_value = atoi(yytext);   return T_Int; }
[a-zA-Z][a-zA-Z0-9]*	{ 
							yylval.id = (char *) strdup(yytext);
							return T_Variable;
						}
[ \t\n]					/*brise bjeline*/			
.						{ return yytext[0]; }
<L_COMMENT>{
\n {BEGIN(INITIAL);}
. 
}


%%
