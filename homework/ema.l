%option noyywrap
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int brojDekadnih;
    int brojBinarnih;
    int brojHeksa;
    int brojRijeci;
    FILE* fajl;
    char* imeFajla;
    YY_BUFFER_STATE bafer;
    char* rezultujuciString;

    void nadoveziString(char* string);
    char* pretvoriUBinarni(int baza);
    char* pretvoriUString(long broj, char* rezultat, int* index);

    int validnaRijec(void);
    char* modifikujRijec(char* rijec);
%}
%%
([1-9][0-9]*|0) {
    brojDekadnih++;
    nadoveziString(pretvoriUBinarni(10));
}
(1[01]*"[2]") { 
    brojBinarnih++;
    nadoveziString(yytext);
}
([1-9A-Fa-f][0-9A-Fa-f]*"[16]") { 
    brojHeksa++;
    nadoveziString(pretvoriUBinarni(16));
}
((ab+|aab+)+|b) {
    if (validnaRijec()) {
        brojRijeci++;
        nadoveziString(modifikujRijec(yytext));
    } else {
        nadoveziString(yytext);
        char next = input();
        while(!next && next != ' ' && next != '\n') {
            nadoveziString(&next);
            next = input();
        }
        unput(next);
    }
}
((b*ab*ab*ab*)*) {
    if (validnaRijec()) {
        nadoveziString(modifikujRijec(yytext));
        brojRijeci++;
    } else {
        nadoveziString(yytext);
        char next = input();
        while(!next && next != ' ' && next != '\n') {
            nadoveziString(&next);
            next = input();
        }
        unput(next);
    }
}
.|\n { 
    nadoveziString(yytext);
}
<<EOF>> {
    return 0;
}
%%
int main(int argc , char** argv)
{
    if (argc < 2) {
        printf("Molimo vas unesite ime fajla!\n");
        return 1;
    }

    // otvaranje fajla
    fajl = fopen(argv[1], "r");

    imeFajla = malloc(sizeof(char) * YY_BUF_SIZE);
    strcpy(imeFajla, argv[1]);
    bafer = yy_create_buffer(fajl, YY_BUF_SIZE);
    yy_switch_to_buffer(bafer);

    // kreiranje brojaca
    brojBinarnih = 0;
    brojDekadnih = 0;
    brojHeksa = 0;
    brojRijeci = 0;

    rezultujuciString = malloc(sizeof(char) * YY_BUF_SIZE);

    yylex();
    
    printf("Broj dekadnih: %d\n", brojDekadnih);
    printf("Broj binarnih: %d\n", brojBinarnih);
    printf("Broj heksa: %d\n", brojHeksa);
    printf("Broj rijeci: %d\n", brojRijeci);

    // cuvanje novog fajla   
    FILE* rezultat = fopen(imeFajla, "w");
    fprintf(rezultat, "%s", rezultujuciString);

    // oslobadjanje memorije
    fclose(rezultat);
    fclose(fajl);

    return 0;
}

int validnaRijec()
{
    char* sacuvnao = strdup(yytext);
    char next   = input();
    int result  = 0;
    
    if (next == ' ' || next == '\n' || next == 0) {
        result = 1;
    }
    
    unput(next);
    yytext = sacuvnao;
    return result;
}

char* modifikujRijec(char* rijec)
{
    int i;
    int n = strlen(rijec);
    int velikoSlovo = 1;

    for (i = 0; i < n; i++) {
        if (velikoSlovo && rijec[i] >= 'a' && rijec[i] <= 'z') {
            rijec[i] = rijec[i] - 32;
        } else if (!velikoSlovo && rijec[i] >= 'A' && rijec[i] <= 'Z') {
            rijec[i] = rijec[i] + 32;
        }
        velikoSlovo = velikoSlovo ? 0 : 1;
    }

    return rijec;
}

char* pretvoriUBinarni(int baza)
{
    long broj;
    int duzinaBroja = yyleng;
    if (baza == 16) {
        duzinaBroja = duzinaBroja - 3;
    }
    char* stringBroja = malloc(sizeof(char) * duzinaBroja);

    strncpy(stringBroja, yytext, duzinaBroja);
    broj = strtol(stringBroja, NULL, baza);
    
    int index = 0;
    char* string = pretvoriUString(broj, stringBroja, &index);

    int duzina = strlen(string);
    string[duzina++] = '[';
    string[duzina++] = '2';
    string[duzina++] = ']';
    string[duzina++] = '\0';

    return string;
}

char* pretvoriUString(long broj, char* rezultat, int* index)
{
   if (broj == 0) {
       return rezultat;
   }

   pretvoriUString(broj / 2, rezultat, index);
   rezultat[*index] = (broj % 2) + '0';
   *index = *index + 1;
   return rezultat;
}

void nadoveziString(char* string)
{
    rezultujuciString = strncat(rezultujuciString, string, strlen(string));
}
