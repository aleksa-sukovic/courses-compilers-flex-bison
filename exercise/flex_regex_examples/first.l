%x COMMENT

%{
    #include <string.h>    
%}
%%
"/*" { 
        BEGIN(COMMENT);
        printf("Recognized comment start");
    }
<COMMENT>"*/" { 
        BEGIN(INITIAL);
        printf("Recognized comment end");
    }
<COMMENT>([^*]|\n)+|.
%%