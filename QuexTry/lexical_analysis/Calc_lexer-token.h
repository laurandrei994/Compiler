/* -*- C++ -*-   vim: set syntax=cpp: 
 * (C) 2004-2017 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY
 */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer_Token__TOKEN__TOKEN__GENERATED
#define QUEX_INCLUDE_GUARD_Calc_lexer_Token__TOKEN__TOKEN__GENERATED

/* For '--token-class-only' the following option may not come directly
 * from the configuration file.                                        */

#   line 2 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"

#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <lexical_analysis/lib/quex/compatibility/stdint.h>
#include <lexical_analysis/lib/quex/MemoryManager>
#include <lexical_analysis/lib/quex/asserts>
#include <lexical_analysis/lib/quex/standard_functions>

#include <lexical_analysis/lib/lexeme/basics>
#include <lexical_analysis/lib/lexeme/converter-from-lexeme>

struct Calc_lexer_Token_tag;



extern Calc_lexer_lexatom_t Calc_lexer_LexemeNull;
extern const char*       Calc_lexer_map_token_id_to_name(const Calc_lexer_token_id_t);



extern const char*       Calc_lexer_Token_get_string(struct Calc_lexer_Token_tag* me,  
                                                    char*                       buffer, 
                                                    size_t                      BufferSize); 

   
#   line 38 "lexical_analysis/Calc_lexer-token.h"


#include "lexical_analysis/Calc_lexer-configuration.h"

struct Calc_lexer_Token_tag;

 void     Calc_lexer_Token_construct(struct Calc_lexer_Token_tag*);
 void     Calc_lexer_Token_copy(struct Calc_lexer_Token_tag*, 
                                           const struct Calc_lexer_Token_tag*);
 void     Calc_lexer_Token_destruct(struct Calc_lexer_Token_tag*);

/* NOTE: Setters and getters as in the C++ version of the token class are not
 *       necessary, since the members are accessed directly.                   */

 void     Calc_lexer_Token_set(struct Calc_lexer_Token_tag* me, 
                                          const Calc_lexer_token_id_t    ID);


 bool     Calc_lexer_Token_take_text(struct Calc_lexer_Token_tag* me, 
                                                const Calc_lexer_lexatom_t*    Begin, 
                                                const Calc_lexer_lexatom_t*    End);




 
typedef struct QUEX_Calc_lexer_SETTING_USER_CLASS_DECLARATION_EPILOG_EXT Calc_lexer_Token_tag {
    Calc_lexer_token_id_t    id;

#   line 34 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"
    const Calc_lexer_lexatom_t* text;
#   line 70 "lexical_analysis/Calc_lexer-token.h"

#   line 35 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"
    size_t                   number;
#   line 74 "lexical_analysis/Calc_lexer-token.h"


           Calc_lexer_token_line_n_t    _line_n;
         Calc_lexer_token_column_n_t  _column_n;

#   line 119 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"

       /* Nothing here. */
   
#   line 84 "lexical_analysis/Calc_lexer-token.h"

} Calc_lexer_Token;


#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__TOKEN__GENERATED */