%{

%}
CIFRA 		[0-9]
OKTCIFRA	[0-7]
HEXCIFRA	[0-9ABCDEF]
%%
[0|1]+"_"2		{
					//binarni brojevi
					printf("BIN");
				}
{CIFRA}+(_10)?	{
					//dekadni broj
					printf("DEC");
				}				
{OKTCIFRA}+_8	{
					printf("OCT");
				}
{HEXCIFRA}+_16	{
					printf("HEX");
				}
"+"|"-"|"*"|"/"|"%"		{ putchar(yytext[0]);}
.						{ }

