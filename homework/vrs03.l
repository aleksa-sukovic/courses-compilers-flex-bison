%option noyywrap

%{
    #include <stdio.h>
    int count = 0;
    
    FILE* file;
    YY_BUFFER_STATE buffer;

    int initializeFileInput(char* fileName);
    int closeFileInput();
%}
%%
aa { printf("aa recognized!\n"); count++; }
<<EOF>> {
    return closeFileInput(file, buffer);
}
%%
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

int closeFileInput()
{
    fclose(file);
    yy_delete_buffer(buffer);

    return 0;
}

int main(int argc , char** argv)
{
    if (argc < 2) {
        printf("You must provide a input file name as argument!\n");
        return 1;
    }

    if (!initializeFileInput(argv[1])) {
        printf("Could not open file: %s\n", argv[0]);
        return 1;
    }

    yylex();

    printf("Finished, count: %d\n", count);
    return 0;
}
