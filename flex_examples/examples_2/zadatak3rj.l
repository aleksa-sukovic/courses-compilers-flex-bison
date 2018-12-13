%{
	#include <stdio.h>
	char* temp;
	char* temp1;
	int i;
%}
%x SADRZAJ
tagname	[A-Za-z][^<>/ ]*
%%
"<"{tagname}" "	{
					char* temp = (char*) malloc((strlen(yytext) + 1));
					yytext++;
					i = 0;
					while (*yytext != ' ') {
						temp[i++] = toupper(*yytext);
						yytext++;
					}
					temp[i] = '\0';
					temp1 = temp;
					printf("Pocetak TAGa = %s", temp1);
					printf("\n");
					
				}
[A-Za-z]+"="\"[^\n"]*\"	{
					printf("\t Atribut: ");
					yytext[yyleng - 1] = '\0';
					while (*yytext != '=') {
						printf("%c", *yytext);
						yytext++;
					}
					yytext++;
					yytext++;
					
					printf("; vrijednost: %s\n", yytext);
					
					
				}
"/"">"			{
						
					printf("\nKraj TAGa %s\n", temp1);
					
					
				}
">"				{
					BEGIN(SADRZAJ);											
				}
<SADRZAJ>{

[^<]			{
					printf("%c", yytext[0]);
				}
				
"</"{tagname}">"	{
							printf("\nKraj1 TAGa %s\n", temp1);
							BEGIN 0;
				}

}


