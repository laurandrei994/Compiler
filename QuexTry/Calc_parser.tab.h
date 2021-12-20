/* A Bison parser, made by GNU Bison 3.7.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_CALC_YY_CALC_PARSER_TAB_H_INCLUDED
# define YY_CALC_YY_CALC_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef CALC_YYDEBUG
# if defined YYDEBUG
#if YYDEBUG
#   define CALC_YYDEBUG 1
#  else
#   define CALC_YYDEBUG 0
#  endif
# else /* ! defined YYDEBUG */
#  define CALC_YYDEBUG 1
# endif /* ! defined YYDEBUG */
#endif  /* ! defined CALC_YYDEBUG */
#if CALC_YYDEBUG
extern int Calc_yydebug;
#endif

/* Token kinds.  */
#ifndef CALC_YYTOKENTYPE
# define CALC_YYTOKENTYPE
  enum Calc_yytokentype
  {
    CALC_YYEMPTY = -2,
    CALC_YYEOF = 0,                /* "end of file"  */
    CALC_YYerror = 256,            /* error  */
    CALC_YYUNDEF = 257,            /* "invalid token"  */
    TKN_NUM = 258,                 /* TKN_NUM  */
    TKN_PRINT = 259,               /* TKN_PRINT  */
    TKN_EXIT_COMMAND = 260,        /* TKN_EXIT_COMMAND  */
    TKN_STRUCT = 261,              /* TKN_STRUCT  */
    TKN_TYPE_INT = 262,            /* TKN_TYPE_INT  */
    TKN_TYPE_DOUBLE = 263,         /* TKN_TYPE_DOUBLE  */
    TKN_SEND = 264,                /* TKN_SEND  */
    TKN_EXPECT = 265,              /* TKN_EXPECT  */
    TKN_SEMICOLON = 266,           /* TKN_SEMICOLON  */
    TKN_BRACKET_OPEN = 267,        /* TKN_BRACKET_OPEN  */
    TKN_BRACKET_CLOSE = 268,       /* TKN_BRACKET_CLOSE  */
    TKN_EXIT = 269,                /* TKN_EXIT  */
    TKN_NEWLINE = 270,             /* TKN_NEWLINE  */
    TKN_IDENTIFIER = 271,          /* TKN_IDENTIFIER  */
    TKN_NEG = 272                  /* TKN_NEG  */
  };
  typedef enum Calc_yytokentype Calc_yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined CALC_YYSTYPE && ! defined CALC_YYSTYPE_IS_DECLARED
union CALC_YYSTYPE
{
#line 21 "Calc_parser.y"

	int      dbl;
	char str;

#line 94 "Calc_parser.tab.h"

};
typedef union CALC_YYSTYPE CALC_YYSTYPE;
# define CALC_YYSTYPE_IS_TRIVIAL 1
# define CALC_YYSTYPE_IS_DECLARED 1
#endif



int Calc_yyparse (struct Calc_lexer_tag  *qlex);

#endif /* !YY_CALC_YY_CALC_PARSER_TAB_H_INCLUDED  */
