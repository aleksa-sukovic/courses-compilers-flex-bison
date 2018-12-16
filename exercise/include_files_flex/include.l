%option noyywrap
%x IFILE

%{
    struct bufstack {
        struct bufstack *prev; // previous entry
        YY_BUFFER_STATE bs;    // saved buffer
        int lineno;            // saved line number
        char *fileName;        // name of this file
        FILE *f;               // current file
    }    *curbs = 0; 

    char *currFileName;         // name of current input file

    int newFile(char *fileName);
    int popFile(void);
%}
%%
^"#"[\t]*include[\t]*[\"<] { BEGIN IFILE; }
<IFILE>[^ \t\n\">]+ {
    int c;
    while((c = input()) && c != '\n') {
        // skipping closing " or > and everything until end of line
    }

    yylineno++;
    if (!newFile(yytext)) {
        yyterminate(); // recognized file does not exists
    }

    BEGIN INITIAL; // initial state every flex scanner has
}
<IFILE>.|\n {
    fprintf(stderr, "%4d bad include line\n", yylineno);
    yyterminate();
}
<<EOF>> {
    if (!popFile()) {
        yyterminate();
    }
}
%%
int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "Need a filename\n");
        return 1;
    }

    if (newFile(argv[1])) {
        yylex();
    }
}

int newFile(char *fileName)
{
    FILE *f = fopen(fileName, "r");
    struct bufstack *bs = malloc(sizeof(struct bufstack));

    // die if no file or no room
    if (!f) {
        perror(fileName);
        return 0;
    }
    if (!bs) {
        perror("malloc");
        exit(1);
    }

    if (curbs) {
        curbs->lineno = yylineno;
    }
    bs->prev = curbs;

    bs->bs = yy_create_buffer(f, YY_BUF_SIZE);
    bs->f = f;
    bs->fileName = fileName;
    yy_switch_to_buffer(bs->bs);

    curbs = bs;
    yylineno = 1;
    currFileName = fileName;

    return 1;
}

int popFile(void)
{
    struct bufstack *bs = curbs;
    struct bufstack *prevBs;

    if (!bs) {
        return 0;
    }

    // get rid of current entry
    fclose(bs->f);
    yy_delete_buffer(bs->bs);

    // switch bakc to previous entry
    prevBs = bs->prev;
    free(bs);

    if (!prevBs) {
        return 0;
    }

    yy_switch_to_buffer(prevBs->bs);
    curbs = prevBs;
    yylineno = curbs->lineno;
    currFileName = bs->fileName;

    return 1;
}
