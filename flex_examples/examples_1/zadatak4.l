%{
	#include <stdio.h>

%}

%%


\n               { printf("1"); }
\"               { printf("2"); }
\".*\"           { printf("3"); }
[A-Z][a-z]+      { printf("4"); }
[a-z]+           { printf("5"); }
[A-Z]+           { printf("6"); }
"abcde"          { printf("7"); }
[^ba]+b          { printf("8"); }

%%
int main() {
	yylex();
	return 0;
}

