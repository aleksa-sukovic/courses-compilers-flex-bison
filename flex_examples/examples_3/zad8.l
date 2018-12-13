%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	int end_attr=0;
%}
%x ATTR_V 
%x B_TAG 
%x E_TAG 
%%
"<" {printf("\n<"); BEGIN(B_TAG);}
"</"	{printf("</"); BEGIN(E_TAG);}
<B_TAG>{
[a-zA-Z0-9]* {int i;int n=strlen(yytext);
					for(i=0;i<n;i++){
						putchar(toupper(yytext[i]));
					}
				
			}
"="		{
			printf("=");
			BEGIN(ATTR_V);
		}
"/>"	{printf("/>\n");BEGIN(INITIAL);}
">"		{printf(">");BEGIN(INITIAL);}
}
<ATTR_V>{
\"	{printf("\""); 
		if(end_attr==1){
			BEGIN(B_TAG);
		}
		end_attr=1-end_attr;
	}
}
<E_TAG>{
[a-zA-Z0-9]* {int i;int n=strlen(yytext);
					for(i=0;i<n;i++){
						putchar(toupper(yytext[i]));
					}
			}
">"		{printf(">\n");BEGIN(INITIAL);}
}
%%