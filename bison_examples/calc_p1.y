%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	
struct Deklaracija {
	float value;
	char* id;
	struct Deklaracija* next;
};

struct Deklaracija* glava_dekl = 0;

void addNewNode(char* id, float val) {
	struct Deklaracija* temp = (struct Deklaracija*) malloc(sizeof(struct Deklaracija));
	temp->id = (char*) strdup(id);
	temp->value = val;
	temp->next = glava_dekl;
	glava_dekl = temp;
}

struct Deklaracija* checkIfExists(char* id) {
	struct Deklaracija* ans = 0;
	struct Deklaracija* temp = glava_dekl;
	while (temp != 0) {
		if (strcmp(temp->id, id) == 0) {
			ans = temp;
			break;
		}
		temp = temp->next;
	}
	return ans;
}

void setValue(struct Deklaracija* ptr, float val) {
	ptr->value = val;
}

int getValue(struct Deklaracija* ptr) {
	return ptr->value;
}

%}
%union {
	int int_value;
	char* id;
}
%start S
%token <int_value>T_Int <id>T_Variable
%type <int_value>exp 
%type <int_value>stat

%left '+' '-'
%left '*' '/'
%%
S : S stat ';'					
	|
;

stat : exp 						{ 	printf("%d\n", $1);			 			}
	| T_Variable '=' exp 		{
									struct Deklaracija* in = checkIfExists($1);
									if (in == 0) {
										addNewNode($1, $3);
									}
									else {
										setValue(in, $3);
									}
								}
;

exp : T_Int				{ $$ = $1; }
	| T_Variable 		{
							struct Deklaracija* in = checkIfExists($1);
							if(in != 0) $$ = getValue(in);
							else $$ = 0;
						}
	| exp '+' exp		{ $$ = $1 + $3;   				}
	| exp '-' exp		{ $$ = $1 - $3;					}
	| exp '*' exp		{ $$ = $1 * $3;   				}
	| exp '/' exp		{ $$ = $1 / $3;					}
	| '(' exp ')'		{ $$ = $2;						}
	| '-' exp			{ $$ = -$2; 					}
;

%%
int main() {

	if (yyparse() == 0) {
		printf("Ulaz JE ispravan.\n");
	} else {
		printf("Ulaz NIJE ispravan.\n");
	}
}
int yyerror(char* msg) {
	printf("Greska\n");
}


