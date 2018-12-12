%{
int count = 0;
%}
%x STATE2
%%
ab	{ printf("x"); }
a	{ BEGIN(STATE2); count=1; }
<STATE2>{
a	{ count++; printf("%d",count); }
b	{ count--; if(count==0) { BEGIN(INITIAL); }; }
}
ab*	{ printf("y"); }
%%
