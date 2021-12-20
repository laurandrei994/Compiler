/* -*- C++ -*-   vim: set syntax=cpp: 
 * (C) 2004-2009 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY
 */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer_Token__TOKEN__TOKEN__GENERATED__I
#define QUEX_INCLUDE_GUARD_Calc_lexer_Token__TOKEN__TOKEN__GENERATED__I

#include "lexical_analysis/Calc_lexer-token.h"

 void 
Calc_lexer_Token_set(Calc_lexer_Token*         __this, 
                     const Calc_lexer_token_id_t ID) 
{ __this->id = ID; }

 void 
Calc_lexer_Token_construct(Calc_lexer_Token* __this)
{
#   define self (*__this)
#   define LexemeNull  (&Calc_lexer_LexemeNull)
    (void)__this;

#   line 40 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"

       self.number = 0;
       self.text   = LexemeNull;
   
#   line 27 "lexical_analysis/Calc_lexer-token.c"

#   undef  LexemeNull
#   undef  self
}

 void 
Calc_lexer_Token_copy_construct(Calc_lexer_Token*       __this, 
                                const Calc_lexer_Token* __That)
{
    Calc_lexer_Token_construct(__this);
    Calc_lexer_Token_copy(__this, __That);
}

 void 
Calc_lexer_Token_destruct(Calc_lexer_Token* __this)
{
#   define self (*__this)
#   define LexemeNull  (&Calc_lexer_LexemeNull)
    if( ! __this ) return;


#   line 45 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"

       if( self.text != LexemeNull ) {
           quex_MemoryManager_free((void*)self.text,
                                      E_MemoryObjectType_TEXT);
           self.text = LexemeNull;
       }
   
#   line 57 "lexical_analysis/Calc_lexer-token.c"

#   undef  LexemeNull
#   undef  self
}

 void
Calc_lexer_Token_copy(Calc_lexer_Token*       __this, 
                      const Calc_lexer_Token* __That)
{
#   define self  (*__this)
#   define Other (*__That)
#   define LexemeNull  (&Calc_lexer_LexemeNull)
    if( __this == __That ) { return; }

#   line 53 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"

        self.id  = Other.id;

        if( self.text != LexemeNull ) {
            quex_MemoryManager_free((void*)self.text, E_MemoryObjectType_TEXT);
        }
        if( Other.text != LexemeNull ) {
            self.text = Calc_lexer_lexeme_clone(self.text, 
                                                 Calc_lexer_lexeme_length(Other.text));
            if( ! self.text ) self.text = LexemeNull;
        }
        self.number = Other.number;

           self._line_n   = Other._line_n;
         self._column_n = Other._column_n;
   
#   line 89 "lexical_analysis/Calc_lexer-token.c"

#   undef  LexemeNull
#   undef  Other
#   undef  self
    /* If the user even misses to copy the token id, then there's
     * something seriously wrong.                                 */
    __quex_assert(__this->id == __That->id);
       __quex_assert(__this->_line_n == __That->_line_n);
     __quex_assert(__this->_column_n == __That->_column_n);
}



 bool 
Calc_lexer_Token_take_text(Calc_lexer_Token*            __this, 
                           const Calc_lexer_lexatom_t* Begin, 
                           const Calc_lexer_lexatom_t* End)
/* RETURNS: true -- if the token claims ownership over the given memory.
 *          false -- if no ownership is claimed.                             */
{
#   define self       (*__this)
#   ifdef  LexemeNull
#   error  "Error LexemeNull shall not be defined here."
#   endif
#   define LexemeNull  (&Calc_lexer_LexemeNull)
    (void)__this;
    (void)Begin;
    (void)End;

#   line 70 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"


#       if 0
        /* Hint for debug: To check take_text change "#if 0" to "#if 1" */
        {
            const Calc_lexer_lexatom_t* it = (void*)0x0;
            printf("previous:  '");
            if( self.text != LexemeNull ) {
                for(it = self.text; *it ; ++it) printf("%04X.", (int)*it);
                printf("%04X.", (int)*it);
            }
            printf("'\n");
            printf("take_text: '");
            for(it = Begin; it != End; ++it) printf("%04X.", (int)*it);
            printf("%04X.", (int)*it);
            printf("'\n");
        }
#       endif

        if( self.text != LexemeNull ) {
            quex_MemoryManager_free((void*)self.text, E_MemoryObjectType_TEXT);
        }
        if( Begin != LexemeNull ) {
            __quex_assert(End >= Begin);
            self.text = Calc_lexer_lexeme_clone(Begin, (size_t)(End - Begin));
            if( ! self.text ) self.text = LexemeNull;
            *((Calc_lexer_lexatom_t*)(self.text + (End - Begin))) = (Calc_lexer_lexatom_t)0;
        } else {
            self.text = LexemeNull;
        }

#       if 0
        /* Hint for debug: To check take_text change "#if 0" to "#if 1"       */
        {
            const Calc_lexer_lexatom_t* it = 0x0;
            printf("after:     '");
            if( self.text != LexemeNull ) { 
                for(it = self.text; *it ; ++it) printf("%04X.", (int)*it);
                printf("%04X.", (int)*it);
            }
            printf("'\n");
        }
#       endif

        /* This token copied the text from the chunk into the string, 
         * so we do not claim ownership over it.                             */
        return false;
   
#   line 168 "lexical_analysis/Calc_lexer-token.c"

#   undef  LexemeNull
#   undef  self
    /* Default: no ownership.                                                */
    return false;
}





#   line 131 "/usr/local/Cellar/quex/0.70.0/libexec/quex/code_base/token/CDefault.qx"

        const char* 
        Calc_lexer_Token_get_string(Calc_lexer_Token* me, char*   buffer, size_t  BufferSize) 
        {
            const char*  token_id_str = Calc_lexer_map_token_id_to_name(me->id);
            const char*  BufferEnd    = buffer + BufferSize;
            char*        writerator   = 0;

            if( ! BufferSize ) return NULL;

            /* Token Type */
            writerator = buffer; 
            writerator += __QUEX_STD_strlcpy(writerator, token_id_str, 
                                             BufferEnd - writerator);

            /* Opening Quote */
            if( BufferEnd - writerator > 2 ) {
                *writerator++ = ' ';
                *writerator++ = '\'';
            }

            /* The String */
            writerator = Calc_lexer_lexeme_to_pretty_char(me->text, writerator, BufferEnd);

            /* Closing Quote */
            if( BufferEnd - writerator > 1 ) {
                *writerator++ = '\'';
            }
            *writerator = '\0';
            return buffer;
        }



#include <lexical_analysis/lib/lexeme/basics.i>
   
#   line 217 "lexical_analysis/Calc_lexer-token.c"


#endif /* QUEX_INCLUDE_GUARD_Calc_lexer_Token__TOKEN__TOKEN__GENERATED__I */






