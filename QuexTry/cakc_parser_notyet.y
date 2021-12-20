%defines
%debug
%define api.pure
%define parse.error verbose
%lex-param {struct Calc_lexer_tag  *qlex}
%parse-param {struct Calc_lexer_tag  *qlex}
%define api.prefix {Calc_yy}

%{
#include "lexical_analysis/Calc_lexer.h"
#include <stdio.h>
#include <math.h>
#include <errno.h>
#include <ctype.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union
{
	int      num;
	char id;
};

%{
#include "lexical_analysis/Calc_lexer.h"
#include <stdio.h>
int  Calc_yylex(YYSTYPE *yylval, struct Calc_lexer_tag *qlex);
void Calc_yyerror(struct Calc_lexer_tag *qlex, const char* m);
%}

%type<num> exp num line
%start line;
%type<id> assignment
%token TKN_PRINT
%token TKN_EXIT_COMMAND
%token TKN_STRUCT
%token TKN_TYPE_INT
%token TKN_TYPE_DOUBLE
%token TKN_SEND
%token TKN_EXPECT
%token TKN_SEMICOLON
%token TKN_BRACKET_OPEN
%token TKN_BRACKET_CLOSE
%token TKN_PRINT
%token TKN_EXIT
%token<id>TKN_IDENTIFIER

%token<id> TKN_NUM


%%



line    : assignment ';'		{;}
		| TKN_EXIT ';'		{exit(EXIT_SUCCESS);}
		| TKN_PRINT exp ';'			{printf("Printing %d\n", $2);}
		| line assignment ';'	{;}
		| line TKN_PRINT exp ';'	{printf("Printing %d\n", $3);}
		| line TKN_EXIT ';'	{exit(EXIT_SUCCESS);}
        ;
assignment : TKN_IDENTIFIER '=' exp  { updateSymbolVal($1,$3); }

exp    	: num                  {$$ = $1;}
       	| exp '+' num          {$$ = $1 + $3;}
       	| exp '-' num          {$$ = $1 - $3;}
       	;
;

num   	: TKN_NUM                {$$ = $1;}
		| TKN_IDENTIFIER			{$$ = symbolVal($1);} 
        ;
        
%%
int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}
void Calc_yyerror(struct Calc_lexer_tag *qlex, const char*  m)
{
	printf("Parsing error at %i:%i: %s", 
           (int)qlex->counter._line_number_at_begin, (int)qlex->counter._column_number_at_begin, m);
           
}

int Calc_yylex(YYSTYPE *yylval, struct Calc_lexer_tag *qlex)
{
	Calc_lexer_Token* token;

	qlex->receive(qlex, &token);

    if( ! token || qlex->error_code != E_Error_None ) {
        return TKN_TERMINATION;
    }
	else if( token->id == TKN_NUM )
	{
        yylval->id = (const char*)(token->text);  // Take over token's text
        token->text = &Calc_lexer_LexemeNull;      // Destructor won't free 'LexemeNull'
	}
	return (int)token->id;
}
 