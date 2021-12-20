
%{
    #include <stdlib.h>
    #include "node.h" /* Must be here before y.yab */
    #include "y.tab.h"

	extern FILE* yyin;
    int yylineo;
	int line_no = 1;
    void yyerror(char* );    

%}

%%
\/\/(.*)		;
[1-9][0-9]*     { yylval.value = atoi(yytext); return NUMBER; }
[0]             { yylval.value = atoi(yytext); return NUMBER; }
[a-z]           { yylval.name = *yytext; return IDENTIFIER; }
[-/=+*)(;}{><]    { return *yytext; }   
"\n"		{line_no+=1;	}
[ \t]+ ;	
"+="    { return TKN_PLUS_EQ;   }
"-="    { return TKN_MINUS_EQ;   }
"*="    { return TKN_MULTIPLY_EQ;   }
"/="    { return TKN_DIVISION_EQ;   }
"if"    { return TKN_IF;    }
"while" { return TKN_WHILE; }
"do"    { return TKN_DO;    }
"int"   { return TKN_INT;   }
"else"  { return TKN_ELSE;  }
"switch" { return TKN_SWITCH;	}
"case"	{ return TKN_CASE;	}
"default" {return TKN_DEFAULT;	}
"break"	{ return TKN_BREAK;	}
"=="    { return TKN_EQ;    }
"!="    { return TKN_NOT_EQ;   }
"&&"    { return TKN_AND;   }
"||"    { return TKN_OR;    }
"for"   { return TKN_FOR;   }
"<="    { return TKN_LESS_EQ;   }
">="    { return TKN_GREATER_EQ;   }
%%

int yywrap()
{
    return 1;
}