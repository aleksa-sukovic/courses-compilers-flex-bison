%{
    #include "bio.tab.h"    
%}
%%
(true)|(TRUE)|T|t {
    return T_TRUE;
}
(false)|(FALSE)|F|f {
    return T_FALSE;
}
(and)|(AND)|"&&" {
    return T_AND;
}
(or)|(OR)|"||" {
    return T_OR;
}
(not)|(NOT)|"!" {
    return T_NOT;
}
";" {
    return T_EOL;
}
.|\n { /* ignoring everything else */ }
%%