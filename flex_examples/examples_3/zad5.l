%{
#include <stdio.h>
#include <stdlib.h>
%}
%x ML_COMMENT
%x L_COMMENT
%%
"//" {BEGIN(L_COMMENT);}
"/*" {BEGIN(ML_COMMENT);}
. {printf("%s",yytext);}
<L_COMMENT>{
\n {BEGIN(INITIAL);}
. 
}
<ML_COMMENT>{
"*/" {BEGIN(INITIAL);}
. 
}

%%