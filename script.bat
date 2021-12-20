bison -y -d parser.y
flex lexer.l
gcc -g lex.yy.c main.c y.tab.c
PAUSE