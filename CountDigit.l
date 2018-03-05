%{
#include <stdio.h>
#include <stdlib.h>
int nDigitNumber = 0;
%}
digit [0-9]
number {digit}+
%%
{digit} {nDigitNumber++;}
%%
main()
{
	yylex();
	fprintf(stderr,"\n number of digits = %d",nDigitNumber);
	return 0;
}