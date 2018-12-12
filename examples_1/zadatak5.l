%{
#include <stdio.h>
#include <stdlib.h>
int p = 0;     
int count = 0;
int amount=0;
%}
digit 		[0-9]+   
letter		[a-z]+   
equals   	   	[=]	
sign		[\-\+]	
%%
{letter}+			{printf("%s\n", yytext);}
{sign}?{digit}+		{sscanf(yytext, "%d",&amount);
                          		  p+= amount;
                              	  printf("%s  %d\n", yytext, amount);}
\n                            	  count++;
.		         ;
%%
int main()
   {
     yylex(); 
	 printf ("%d  %d", count, p); 
	 return 0;
   }

