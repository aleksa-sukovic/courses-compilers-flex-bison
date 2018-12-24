%option noyywrap

DIGIT ([1-9][0-9]*|0)
BINARY_DIGIT (1[01]*"[2]")
HEX_DIGIT ([1-9A-Fa-f][0-9A-Fa-f]*"[16]")
L1 ((ab+|aab+)+|b)
L2 ((b*ab*ab*ab*)*)

%{
    #include <stdio.h>
    #include <string.h>
    #define TRUE 1
    #define FALSE 0

    struct Counter {
        int decimalNumbers;
        int binaryNumbers;
        int hexNumbers;
        int l1Words;
        int l2Words;
    } *counter;

    struct OutputBuffer {
        char* content;
        int position;
    } *outputBuffer;

    struct File {
        char* name;
        FILE* handle;
        YY_BUFFER_STATE inputBuffer;
    };
    struct File* file;

    int initialize(char* fileName);

    struct File* createFile(char* fileName, char* mode);
    int closeFile(struct File* file);

    int initializeFileInput(char* fileName);
    int initializeCounter(void);
    int initializeOutputBuffer(void);

    int writeToOutputBuffer(char* data, int length);
    int writeToFile(struct File* file, char* data);

    void printOutput(void);
    void persistOutputBuffer(void);
    int cleanUp(void);
%}
%%
{DIGIT} {
    counter->decimalNumbers++;
    writeToOutputBuffer(yytext, yyleng);
}
{BINARY_DIGIT} { 
    counter->binaryNumbers++;
    writeToOutputBuffer(yytext, yyleng);
}
{HEX_DIGIT} { 
    counter->hexNumbers++;
    writeToOutputBuffer(yytext, yyleng);
}
{L1} {
    counter->l1Words++;
    writeToOutputBuffer(yytext, yyleng);
}
{L2} {
    counter->l2Words++;
    writeToOutputBuffer(yytext, yyleng);
}
.|\n { 
    writeToOutputBuffer(yytext, yyleng);
}
<<EOF>> {
    return 0;
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
    persistOutputBuffer();
    cleanUp();

    return 0;
}

int initialize(char* fileName)
{
    if (!initializeFileInput(fileName)) {
        printf("Could not open file: %s\n", fileName);
        return FALSE;
    }

    if (!initializeCounter()) {
        printf("Could not initialize counter!\n");
        return FALSE;
    }

    if (!initializeOutputBuffer()) {
        printf("Could not initialize output buffer!\n");
        return FALSE;
    }

    return TRUE;
}

int initializeFileInput(char* fileName)
{
    file = createFile(fileName, "r");

    if (!file) {
        printf("Error while creating new file!\n");
        return FALSE;
    }

    file->inputBuffer = yy_create_buffer(file->handle, YY_BUF_SIZE);
    yy_switch_to_buffer(file->inputBuffer);

    return TRUE;
}

struct File* createFile(char* fileName, char* mode)
{
    struct File* file = malloc(sizeof(struct File));

    if (!file) {
        printf("Could not allocate memory for file struct!\n");
        return NULL;
    }

    file->handle = fopen(fileName, mode);
    file->name = malloc(sizeof(char) * strlen(fileName));
    file->inputBuffer = yy_create_buffer(file->handle, YY_BUF_SIZE);

    if (!file->handle || !file->name) {
        printf("Could not open the file!");
        return NULL;
    }

    strcpy(file->name, fileName);
    return file;
}

int initializeCounter()
{
    counter = malloc(sizeof(struct Counter));

    if (!counter) {
        printf("Error allocating counter memory!\n");
        return FALSE;
    }

    counter->binaryNumbers = 0;
    counter->decimalNumbers = 0;
    counter->hexNumbers = 0;
    counter->l1Words = 0;
    counter->l2Words = 0;

    return TRUE;
}

int initializeOutputBuffer()
{
    outputBuffer = malloc(sizeof(struct OutputBuffer));

    if (!outputBuffer) {
        printf("Error allocating output buffer memory!\n");
        return FALSE;
    }

    outputBuffer->position = 0;
    outputBuffer->content = malloc(sizeof(char) * YY_BUF_SIZE);
}

int writeToOutputBuffer(char* data, int length)
{
    int i;
    for (i = 0; i < length; i++) {
        outputBuffer->content[outputBuffer->position++] = data[i];
    }

    outputBuffer->content[outputBuffer->position] = '\0';
}

int writeToFile(struct File* file, char* data)
{
    fprintf(file->handle, "%s", data);

    return TRUE;
}

int closeFile(struct File* file)
{
    fclose(file->handle);
    yy_delete_buffer(file->inputBuffer);
    free(file);

    return TRUE;
}

void printOutput()
{
    printf("Finished scanning!\n");
    printf("\tDecimal number count: %d\n", counter->decimalNumbers);
    printf("\tBinary number count: %d\n", counter->binaryNumbers);
    printf("\tHex number count: %d\n", counter->hexNumbers);
    printf("\tL1 Words count: %d\n", counter->l1Words);
    printf("\tL2 Words count: %d\n", counter->l2Words);
}

void persistOutputBuffer()
{
    struct File* output = createFile(file->name, "w");

    if (!output) {
        printf("Could not open file: %s for writing!\n", file->name);
        return;
    }

    writeToFile(output, outputBuffer->content);
    closeFile(output);
}

int cleanUp()
{
    closeFile(file);
    free(counter);
    free(outputBuffer->content);
    free(outputBuffer);

    return TRUE;
}