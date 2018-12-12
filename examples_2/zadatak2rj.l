%{

%}
CIFRA 		[0-9]
OKTCIFRA	[0-7]
HEXCIFRA	[0-9ABCDEFabcdef]
%%

[1-9]{CIFRA}{0,16}			{
								//dekadni broj
								printf("DEC");
							}				
0{OKTCIFRA}{0,12}			{
								printf("OCT");
							}
0(x|X){HEXCIFRA}{0,8}		{
								printf("HEX");
							}
"+"|"-"|"*"|"/"|"%"		{ putchar(yytext[0]);}
.						{ }

