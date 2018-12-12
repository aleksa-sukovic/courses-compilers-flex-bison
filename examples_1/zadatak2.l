%%
a	{ printf("1"); }
a+	{ printf("2"); }
a*b	{ printf("3"); }
b*	{ printf("4"); }
.	{ printf("%s", yytext); }
