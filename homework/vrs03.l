%option noyywrap

DIGIT ([1-9][0-9]*|0)
BINARY_DIGIT (1[01]*"[2]")
HEX_DIGIT ([1-9A-Fa-f][0-9A-Fa-f]*"[16]")
L1 ((ab+|aab+)+|b)
L2 (b*|ab*ab*ab*)

%{
    #include <stdio.h>

    struct Counter {
        int decimalNumbers;
        int binaryNumbers;
        int hexNumbers;
        int words;
    } *counter;

    FILE* file;
    YY_BUFFER_STATE buffer;

    int initialize(char* fileName);
    int initializeFileInput(char* fileName);
    int initializeCounter(void);
    int closeFileInput(void);
    void printOutput(void);
%}
%%
{DIGIT} { counter->decimalNumbers++; }
{BINARY_DIGIT} { counter->binaryNumbers++; }
{HEX_DIGIT} { counter->hexNumbers++; }
.|\n
<<EOF>> {
    return closeFileInput();
}
%%
int main(int argc , char** argv)
{
    if (argc < 2) {
        printf("You must provide a input file name as argument!\n");
        return 1;
    }

    if (!initialize(argv[1])) {
        printf("Initialization of passed file failed!\n");
        return 1;
    }

    yylex();
    printOutput();

    return 0;
}

int initialize(char* fileName)
{
    if (!initializeFileInput(fileName)) {
        printf("Could not open file: %s\n", fileName);
        return -1;
    }

    if (!initializeCounter()) {
        printf("Could not initialize counter!\n");
        return -1;
    }

    return 1;
}

int initializeFileInput(char* fileName)
{
    file = fopen(fileName, "r");

    if (!file) {
        return 0;
    }

    buffer = yy_create_buffer(file, YY_BUF_SIZE);
    yy_switch_to_buffer(buffer);

    return 1;
}

int initializeCounter()
{
    counter = malloc(sizeof(struct Counter));

    if (!counter) {
        printf("Error allocating counter memory!\n");
        return -1;
    }

    counter->binaryNumbers = 0;
    counter->decimalNumbers = 0;
    counter->hexNumbers = 0;
    counter->words = 0;

    return 1;
}


int closeFileInput()
{
    fclose(file);
    yy_delete_buffer(buffer);

    return 0;
}

void printOutput()
{
    printf("Finished scanning!\n");
    printf("\tDecimal number count: %d\n", counter->decimalNumbers);
    printf("\tBinary number count: %d\n", counter->binaryNumbers);
    printf("\tHex number count: %d\n", counter->hexNumbers);
    printf("\tWords count: %d\n", counter->words);
}