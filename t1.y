%{
#include <stdio.h>
#include <stdbool.h>
#include<stdlib.h>
#include <ctype.h>
#include <math.h>
void yyerror(char *s);
int yylex();
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);   
int iarray[101][101];
%}

%union {
    int num;
    char id;
}
%start line //starting production
%token IF ELSE NUMBER PLUS MINUS DIV MUL POW SEMI PR PL THEN EQUAL EXIT print LOOP IARRAY ODDEVEN PRIME FACT
%left EQUAL //associativity
%left  PLUS MINUS MUL DIV
%left IF ELSE
%token <id> identifier // identifier will map to type id
%type <num> line Exp term Condition Statment NUMBER //  line exp term will map to type num
%type <id> assignment

%%
line	: assignment SEMI        {;}
		| ifELse line
		| print Exp SEMI         {printf(">>> %d\n",$2);}
        | line assignment SEMI   {;}
        | line print Exp SEMI    {printf(">>> %d\n",$3);}
		| FACT PR term PL SEMI 
			{
				int n, i, fact;
				n = $3; fact = 1;
				if (n < 0)
				printf(">>> Error! Factorial of a negative number doesn't exist.\n");
				else {
				for (i = 1; i <= n; ++i) {
					fact *= i;
				}
				printf(">>> %d\n",fact);
				}
			}
		| ODDEVEN PR term PL SEMI
			{
				if($3%2==0) {printf(">>> %d is even\n",$3);}
				else {printf(">>> %d is odd\n",$3);}
			} 
		| PRIME PR term PL SEMI
			{
				int n, i, flag = 0;
				n = $3;
				for (i = 2; i <= n / 2; i++) {
				// condition for non-prime
				if (n % i == 0) {
					flag = 1;
					break;
				}
				}
				if (n == 1) {
					printf(">>> 1 is neither prime nor composite.\n");
				}
				else {
					if (flag == 0)
						printf(">>> %d is a prime number.\n", n);
					else
						printf(">>> %d is not a prime number.\n", n);
				}
			} 
		| LOOP PR NUMBER ',' Exp  PL SEMI 
		{
			int i; 
			for(i = 0 ; i < $3 ; i++) {
				printf(">>> %d\n",$5);
			}
		}
		| IARRAY PR NUMBER ',' NUMBER PL SEMI 
			{
				int name, i, val; 
				name = $3 - 1;
				iarray[name][0] = 1000; //protect
				printf(">> insert elements: \n");
				for(i = 1 ; i <= $5 ; i++) {
					scanf("%d",&val);
					iarray[name][i] = val; 
				} 
				printf(">>> finished inserting.\n Array name: %d and size: %d",$3,$5); 
			}
		
		|EXIT SEMI{printf(">>> Exiting t1 lang, bye...");exit(0);}
		;

assignment  : identifier '=' Exp {updateSymbolVal($1,$3);}
            ;

ifELse:	IF PR Condition PL THEN Statment ELSE Statment SEMI{
														if($3){
															printf(">>> In the if true part\n");
															printf(">>> The statment was executed with the value of %d\n",$6);
															}
														else{
															printf(">>> In the else part\n");
															printf(">>> The statment was executed with the value of %d\n",$8);
															}
															printf("\n");
														}
		| IF PR Condition PL THEN Statment SEMI{
											if($3){
													printf(">>> Correct condition statment value is %d\n",$6);
													}
											else
												printf(">>> incorrect condition\n");	
											}
		;

Condition:	Exp '>' Exp {$$ =  $1 > $3? 1: 0 ;}
			| Exp '<' Exp {$$ =  $1 < $3? 1: 0; }
			| Exp EQUAL Exp {$$ = $1 == $3? 1: 0 ; }
			| NUMBER
			;

Statment:	Exp
			| line
			;

Exp:		term      {$$ = $1;}
			| Exp PLUS Exp {$$ = $1 + $3;}
			| Exp MINUS Exp {$$ = $1 - $3;}
			| Exp MUL Exp {$$ = $1 * $3;}
			| Exp DIV Exp {
						if($3 == 0){
							printf(">>> Can not divide by zero\n");
							}
						else
							$$ = $1 / $3;}
			| Exp POW Exp {$$ = pow($1,$3);}
			;

term    : NUMBER    {$$ = $1;}
        | identifier {$$ = symbolVal($1);}
        ;
%%

// C code for required methods

int computeSymbolIndex(char token)
{
    int index = -1;
    if (islower(token)) {
        index = token - 'a' + 26;
    }
    else if (isupper(token)) {
        index = token - 'A';
    }
    return index;
}

// returns value of a symbol
int symbolVal(char symbol)
{
    int index = computeSymbolIndex(symbol);
    return symbols[index];
}

// updates the value of a symbol
void updateSymbolVal(char symbol, int val)
{
    int index = computeSymbolIndex(symbol);
    symbols[index] = val;
}

//initialize symbol table
void init()
{
    int i, j;
    for (i = 0 ; i < 52 ; i++)
    {
        symbols[i] = 0;
    }
	for (i = 0 ; i < 101 ; i++)
	{
		for (j = 0 ; j < 101 ; j++) {
			iarray[i][j] = -999;
		}
	}
}

void yyerror(char *s){
	printf(">>> Error happend %s",s);
}

int yywrap(){
return 1;
}

int main(int argc, char *argv[]){
	freopen(argv[1],"r",stdin);
	freopen(argv[2],"a+",stdout);
	printf(">>> Running t1 lang...\n");
    init();
	return yyparse();
}