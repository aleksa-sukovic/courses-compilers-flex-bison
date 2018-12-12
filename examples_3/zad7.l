%{
	#include <stdio.h>
	#include <stdlib.h>
	float sum=0;
	int	num=0;
%}

%%
[1-9][0-9]* {sum+=atof(yytext); num++;}
[1-9][0-9]*"."[0-9]* {sum+=atof(yytext);num++;}
"sum" {printf("sum=%f\n",sum); sum=0; num=0;}
"mean"	{printf("mean=%f\n",sum/num); sum=0;num=0;}
"quit"	{return 0;}
.
%% 