%{
    #include <stdio.h>
%}
%%
(00|01|10|11)* {
    printf("Eaven number binary string: %s\n", yytext);
}
((0|1)((0|1)(0|1))*)+ {
    printf("Odd number binary string: %s\n", yytext);
}
.|\n { }
<<EOF>> {
    printf("End of file!\n");
    return 0;
}
%%
int main(int argc, char** argv)
{
    FILE* file             = fopen(argv[1], "r");
    YY_BUFFER_STATE buffer = yy_create_buffer(file, YY_BUF_SIZE);
    
    yy_switch_to_buffer(buffer);

    yylex();
}