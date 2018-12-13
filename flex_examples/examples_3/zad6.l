%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%%
0[bB](0|1)+ {int i=0;
			long dec=0;
			int n= strlen(yytext);
					for(i=2; i<n;i++){
						dec=dec*2+yytext[i]-'0';	
					}
			printf("%ld\n",dec);
			}
%%