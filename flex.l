%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 0
#endif
%}
/* define word */
Word	[a-zA-Z_][0-9a-fA-F_]+

/* define digit */
Digit	([1-9][0-9]*((\.)[0-9]+)?)|(([0-9]+)?(\.)[0-9]+)

/* define binary */
Bin		0[bB][01]+

/* define octal */
Oct		0[oO]?[0-7]+

/* define hexadecimal */
Hex		0[xX][0-9a-fA-F]+

/* define comments */
COMMENT1	(\"\"\")[^\"]+(\"\"\")
COMMENT2	(\'\'\')[^\']+(\'\'\')
LCOMMENT	#.*\n

/* define string */
%x STRING1
%x STRING2

/* define */
%x BACKSLASH1
%x BACKSLASH2

%%

	/* match words */
{Word}	ECHO;

	/* match digit */
{Digit}|0	ECHO;

	/* match string */
(')	{
	printf(yytext);
	BEGIN STRING1;}
<STRING1>(\\)	{
	printf(yytext);
	BEGIN BACKSLASH1;}
<STRING1>(')	{
	printf(yytext);
	BEGIN INITIAL;}
<BACKSLASH1>(.)	{
	printf(yytext);
	BEGIN STRING1;}
(\")	{
	printf(yytext);
	BEGIN STRING2;}
<STRING2>(\\)	{
	printf(yytext);
	BEGIN BACKSLASH2;}
<STRING2>(\")	{
	printf(yytext);
	BEGIN INITIAL;}
<BACKSLASH2>(.)	{
	printf(yytext);
	BEGIN STRING2;}

	/* convert uppercase inside comments into lowercase */
{COMMENT1}|{COMMENT2}|{LCOMMENT}	{
	for(int i = 0;i < strlen(yytext);i++){
		if(yytext[i] >= 'A' && yytext[i] <= 'Z')
			yytext[i] += 32;
	}
	printf(yytext);
}

	/* match binary */
{Bin}	{
	int sum = 0;
	for(int i = 1;i < strlen(yytext);i++){
		switch(yytext[i]){
			case '0':sum = sum*2;break;
			case '1':sum = sum*2+1;break;
			default:break;
			}
	}
	printf("%d",sum);
}
	
	/* match octal */
{Oct}	{
	int sum = 0;
	for(int i = 1;i < strlen(yytext);i++){
		switch(yytext[i]){
			case '0':sum = sum*8;break;
			case '1':sum = sum*8+1;break;
			case '2':sum = sum*8+2;break;
			case '3':sum = sum*8+3;break;
			case '4':sum = sum*8+4;break;
			case '5':sum = sum*8+5;break;
			case '6':sum = sum*8+6;break;
			case '7':sum = sum*8+7;break;
			default:break;
			}
	}
	printf("%d",sum);
}
	
	/* match hexadecimal */
{Hex}	{
	int sum = 0;
	for(int i = 1;i < strlen(yytext);i++){
		switch(yytext[i]){
			case '0':sum = sum*16;break;
			case '1':sum = sum*16+1;break;
			case '2':sum = sum*16+2;break;
			case '3':sum = sum*16+3;break;
			case '4':sum = sum*16+4;break;
			case '5':sum = sum*16+5;break;
			case '6':sum = sum*16+6;break;
			case '7':sum = sum*16+7;break;
			case '8':sum = sum*16+8;break;
			case '9':sum = sum*16+9;break;
			case 'a':case 'A':sum = sum*16+10;break;
			case 'b':case 'B':sum = sum*16+11;break;
			case 'c':case 'C':sum = sum*16+12;break;
			case 'd':case 'D':sum = sum*16+13;break;
			case 'e':case 'E':sum = sum*16+14;break;
			case 'f':case 'F':sum = sum*16+15;break;
			default:break;
			}
	}
	printf("%d",sum);
}
	
%%

void main(void)
{
    yylex();
}



