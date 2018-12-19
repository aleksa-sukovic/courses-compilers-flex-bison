%option noyywrap nodefault yylineno

%x COMMENT
%x IFILE

/* Universal Character Name */
UCN (\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
/* float exponent */
EXP ([Ee][-+]?[0-9]+)
/* integer length */
ILEN ([Uu](L|l|LL|ll)?|(L|l|LL|ll)[Uu]?)

%{
    /* Variable name */
    struct symbol {
        struct ref *refList;
        char *name;
    };

    /* Implementation of linked list containing all references of certain symbol troughout files */
    struct ref {
        struct ref *next;   // pointer to next reference
        char *fileName;     // name of the file in which symbol occured
        int flags;          // 01 means definition
        int lineNumber;     // line number in which symbol occured
    };

    /* Symbols are stored in hash table */
    #define SYMBOL_TABLE_SIZE 9997
    struct symbol symbolTable[SYMBOL_TABLE_SIZE];

    struct symbol* lookUp(char*);           // finds symbol in table (if symbold doesnt exists, it gets created)
    void addRef(int, char*, char*, int);    // adds reference to symbol in table

    char *currentFileName; // name of current input file

    /* include file stack */
    struct bufStack {
        struct bufStack *previous;      // previous entry
        YY_BUFFER_STATE bufferState;    // saved buffer
        int lineno;                     // saved line number in this file
        char *fileName;                 // name of this file
        FILE *f;                        // current file
    } *currrentBufferStack;

    int newFile(char *fileName);
    int popFile(void);

    int defining; // names are probably definitions (TODO explain better)
%}
%%
"/*" { BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>([^*]|\n)+|.
<COMMENT><<EOF>> {
    printf("%s: %d: Unterminated comment\n", currentFileName, yylineno);
    return 0;
 }
"//".*\n
_Bool |
_Complex |
_Imaginary |
auto |
char |
const |
double |
enum |
extern |
float |
inline |
int |
long |
register |
restrict |
short |
signed |
static |
struct |
typedef |
union |
unsigned |
void |
volatile { defining = 1; }
break
case
continue
default
do
else
for
goto
if
return
sizeof
switch
while
%%
/* Constructs a hash for given string */
static unsigned symbolHash(char *symbol)
{
    unsigned int hash = 0;
    unsigned c;

    while (c = *symbol++) {
        hash = hash * 9 ^ c;
    }

    return hash;
}

/* Fetches symbol with given name from hash table.
   If symbol does not exists, it gets created.
   It uses symbolHash(char*) function for calculating symbol index in table (symbolHash(symbolName) % SYMBOL_TABLE_SIZE)
   If confilict occures, conflict resolution method known as 'linear probing' is used
*/
struct symbol* lookUp(char* symbolName)
{
    int index = symbolHash(symbolName) % SYMBOL_TABLE_SIZE;
    struct symbol *resultSymbol = &symbolTable[index];
    int symbolCount = SYMBOL_TABLE_SIZE;

    while (--symbolCount >= 0) {
        // symbol found in table, returning it
        if (resultSymbol->name && !strcmp(resultSymbol->name, symbolName)) {
            return resultSymbol;
        }

        // symbol not found in table, creating new entry
        if (!resultSymbol->name) { 
            resultSymbol->name = strdup(symbolName);
            resultSymbol->refList = 0;
            return resultSymbol;
        }

        // conflict on given index, trying next entry
        if (++resultSymbol >= symbolTable + SYMBOL_TABLE_SIZE) {
            resultSymbol = symbolTable;
        }
    }

    fputs("Symbol table overflow\n", stderr);
    abort();
}

void addRef(int lineNumber, char *fileName, char *symbolName, int flags)
{
    struct ref *newReference;
    struct symbol *symbol = lookUp(symbolName);

    // we don't save duplicates of same line and file
    // since fileName is kept in globalVariable currentFileName, all file names in references point to same string, hence we can to == check
    if (symbol->refList 
        && symbol->refList->lineNumber == lineNumber
        && symbol->refList->fileName == fileName) {
            return;
        }

    newReference = malloc(sizeof(struct ref));
    if (!newReference) {
        fputs("Out of space when adding new reference!\n", stderr);
        abort();
    }

    newReference->next = symbol->refList;
    newReference->fileName = fileName;
    newReference->lineNumber = lineNumber;
    newReference->flags = flags;

    // setting newReference as head of symbol reference list
    symbol->refList = newReference;
}
