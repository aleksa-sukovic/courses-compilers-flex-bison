%%
0[0-7]{0,12} {printf("OCT");}
0[xX][0-9a-fA-F]{0,8} {printf("HEX");}
[1-9][0-9]{0,16} {printf("DEC");}
["+""-""*""/"] {printf("%s", yytext);}
%%