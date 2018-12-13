%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int chars = 0, words = 0, lines = 0;
%}

%%
[a-zA-Z]+	{		words++; 
				chars += strlen(yytext);
		}
\n		{
			chars++;
			lines++;
		}
.		{ chars++; }
%%

main()
{
  printf("Ulaz:\n");
  yylex();
  
  printf("%8d%8d%8d\n", lines, words, chars);
  return 0;
}
