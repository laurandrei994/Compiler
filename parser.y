%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <stdarg.h>
    #include "node.h"
    
    extern int yylineo;
	extern int line_no;
	extern FILE* yyin;
    void yyerror(char* );

    int yylex();
    void FreeNode(Node* node);
    Node* CreateOperator(int type, int noOfOpr, ...);
    Node* CreateId(char name);
    Node* CreateConstant(int value);    

    int Generate(Node* node);
    void Init();
    void FreeAccumulators();

%}

%union
{
    int value;
    char name;
    Node* node;
};

%token <value> NUMBER
%token <name> IDENTIFIER
%token TKN_INT TKN_IF TKN_ELSE TKN_NOT_EQ TKN_EQ TKN_AND TKN_OR TKN_WHILE TKN_PLUS_EQ TKN_MINUS_EQ TKN_MULTIPLY_EQ TKN_DIVISION_EQ TKN_DO TKN_FOR TKN_SWITCH TKN_CASE TKN_DEFAULT TKN_BREAK

%right '=' TKN_PLUS_EQ TKN_MINUS_EQ TKN_MULTIPLY_EQ TKN_DIVISION_EQ // -= += *= /=
%left TKN_OR
%left TKN_AND
%left TKN_EQ TKN_NOT_EQ
%left '>' '<' TKN_LESS_EQ TKN_GREATER_EQ // >= <=
%left '+' '-'
%left '*' '/'
%left '(' ')'

%type <node> expr statement variableDeclaration declaration block 

%%

program: declarationList ;

declarationList:
    declarationList declaration { Init(); Generate($2); FreeNode($2); }
    |
    ;

declaration:
    variableDeclaration { $$ = $1; }
    | statement         { $$ = $1; }
    ;

variableDeclaration:
    TKN_INT IDENTIFIER '=' expr ';' { $$ = CreateOperator(TKN_INT, 2, CreateId($2), $4); FreeAccumulators(); }
    | TKN_INT IDENTIFIER ';'        { $$ = CreateOperator(TKN_INT, 1, CreateId($2)); FreeAccumulators(); }
    ;

statement:
    expr ';'                                        { $$ = $1; FreeAccumulators(); }
    | TKN_IF '(' expr ')' statement		{ $$ = CreateOperator(TKN_IF, 2, $3, $5); FreeAccumulators(); }
    | TKN_IF '(' expr ')' statement TKN_ELSE statement   { $$ = CreateOperator(TKN_IF, 3, $3, $5, $7); FreeAccumulators(); }
    | TKN_WHILE '(' expr ')' statement                 { $$ = CreateOperator(TKN_WHILE, 2, $3, $5); FreeAccumulators(); }
    | TKN_DO statement TKN_WHILE '(' expr ')'               { $$ = CreateOperator(TKN_DO, 2, $2, $5); FreeAccumulators(); }
    | TKN_FOR '(' expr ';' expr ';' expr ')' statement  { $$ = CreateOperator(TKN_FOR, 4, $3, $5, $7, $9); FreeAccumulators(); }
    | '{' block '}'                                 { $$ = $2; }
    | ';'                                           { $$ = NULL;  FreeAccumulators(); }
    ;

block:
    declaration                 { $$ = $1; }
    | block declaration         { $$ = CreateOperator(';', 2, $1, $2); }
    ;

expr:
    NUMBER              { $$ = CreateConstant($1); } 
    | IDENTIFIER              { $$ = CreateId($1); } 
    | IDENTIFIER '=' expr     { $$ = CreateOperator('=', 2, CreateId($1), $3); }
    | IDENTIFIER TKN_PLUS_EQ expr     { $$ = CreateOperator(TKN_PLUS_EQ, 2, CreateId($1), $3); }
    | IDENTIFIER TKN_MINUS_EQ expr     { $$ = CreateOperator(TKN_MINUS_EQ, 2, CreateId($1), $3); }
    | IDENTIFIER TKN_MULTIPLY_EQ expr     { $$ = CreateOperator(TKN_MULTIPLY_EQ, 2, CreateId($1), $3); }
    | IDENTIFIER TKN_DIVISION_EQ expr     { $$ = CreateOperator(TKN_DIVISION_EQ, 2, CreateId($1), $3); }
    | expr '+' expr     { $$ = CreateOperator('+', 2, $1, $3); }
    | expr '-' expr     { $$ = CreateOperator('-', 2, $1, $3); }
    | expr '*' expr     { $$ = CreateOperator('*', 2, $1, $3); }
    | expr '/' expr     { $$ = CreateOperator('/', 2, $1, $3); }
    | expr TKN_LESS_EQ expr     { $$ = CreateOperator(TKN_LESS_EQ, 2, $1, $3); }
    | expr TKN_GREATER_EQ expr     { $$ = CreateOperator(TKN_GREATER_EQ, 2, $1, $3); }
    | expr '<' expr     { $$ = CreateOperator('<', 2, $1, $3); }
    | expr '>' expr     { $$ = CreateOperator('>', 2, $1, $3); }
    | expr TKN_EQ  expr     { $$ = CreateOperator( TKN_EQ, 2, $1, $3); }
    | expr TKN_NOT_EQ expr     { $$ = CreateOperator(TKN_NOT_EQ, 2, $1, $3); }
    | expr TKN_AND expr     { $$ = CreateOperator(TKN_AND, 2, $1, $3); }
    | expr TKN_OR  expr     { $$ = CreateOperator( TKN_OR, 2, $1, $3); }
    | '(' expr ')'      { $$ = $2; }
    ;
    
%%

Node* CreateConstant(int value)
{
    Node* newNode = (Node*) malloc(sizeof(Node));

    newNode->type = CONST;
    newNode->constant.value = value;

    return newNode;  
}

Node* CreateId(char name)
{
    Node* newNode = (Node*) malloc(sizeof(Node));

    newNode->type = ID;
    newNode->id.name = name;

    return newNode;  
}

Node* CreateOperator(int type, int noOfOpr, ...)
{
    Node* newNode = (Node*) malloc(sizeof(Node) + noOfOpr * sizeof(Node*));

    newNode->type = OPR;
    newNode->opr.noOfOpr = noOfOpr;
    newNode->opr.type = type;

    va_list operands;
    va_start(operands, noOfOpr);

    for (int i = 0; i < noOfOpr; ++i)
        newNode->opr.operands[i] = va_arg(operands, Node*);

    va_end(operands);

    return newNode;  
}

void FreeNode(Node* node)
{
    if ( OPR == node->type )
        for (int i = 0; i <  node->opr.noOfOpr; ++i)
            free(node->opr.operands[i]);

    free(node);
}

void yyerror(char* argv1)
{
    printf("ERROR at line number %d: %s\n", argv1, line_no);
}