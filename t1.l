%{
#include <stdlib.h>
#include <stdio.h>
#include "t1.tab.h"
%}
Num [0-9]+
Blank [ \t\n]+
Special [><={},]

%%
"factorial" {return FACT;}
"isoddeven" {return ODDEVEN;}
"isprime" {return PRIME;}
"iarray" {return IARRAY;}
"loop" {return LOOP;}
"print" {return print;}
[a-zA-Z] {
    yylval.id = yytext[0];
    return identifier;
}

{Num}	{
	yylval.num = atoi(yytext);
		return(NUMBER);
}
{Special} {return(yytext[0]);}
"$"(.)+   {;}
"$$"(.)+(("\n")*[^$$]+("\n")*)*"$$"		{;}
"+" 	{return(PLUS);}
"-"		{return(MINUS);}
"*"     {return(MUL);}
"/"     {return(DIV);}
"**"    {return(POW);}
";"		{return(SEMI);}
"("		{return(PR);}
")"		{return(PL);}
"if"	{return(IF);}
"else"	{return(ELSE);}
"then"	{return(THEN);}
"=="	{return(EQUAL);}
"exit"  {return(EXIT);}
{Blank}	{;}
. {
    ECHO;
    printf("unknown character");
}


