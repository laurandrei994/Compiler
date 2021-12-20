/* -*- C++ -*- vim:set syntax=cpp:
 *
 * (C) 2005-2009 Frank-Rene Schaefer                                        */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__EXTRA__ACCUMULATOR__ACCUMULATOR_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__EXTRA__ACCUMULATOR__ACCUMULATOR_I

#include "lexical_analysis/lib/definitions"
#include "lexical_analysis/lib/extra/accumulator/Accumulator"
#include "lexical_analysis/lib/quex/MemoryManager"



 void
Calc_lexer_Accumulator_destruct(Calc_lexer_Accumulator* me);
                      
 bool      
Calc_lexer_Accumulator__extend(Calc_lexer_Accumulator* me, size_t MinAddSize);
                      
 void      
Calc_lexer_Accumulator_print_this(Calc_lexer_Accumulator* me);
                      
 bool
Calc_lexer_Accumulator__flush(Calc_lexer_Accumulator*   me,
                              const Calc_lexer_token_id_t  TokenID);
                      
 bool
Calc_lexer_Accumulator__memory_resources_allocate(Calc_lexer_Accumulator*   me);

 bool      
Calc_lexer_Accumulator_construct(Calc_lexer_Accumulator*   me, 
                                 struct Calc_lexer_tag*       lexer)
{
    me->the_lexer = lexer;

    if( ! Calc_lexer_Accumulator__memory_resources_allocate(me) ) {
        Calc_lexer_Accumulator_resources_absent_mark(me);
        return false;
    }
        
       me->_begin_line   = 0;
     me->_begin_column = 0;


    me->destruct      = Calc_lexer_Accumulator_destruct;
    me->clear         = Calc_lexer_Accumulator__clear;
    me->add           = Calc_lexer_Accumulator__add;
    me->add_character = Calc_lexer_Accumulator__add_character;
    me->extend        = Calc_lexer_Accumulator__extend;
    me->flush         = Calc_lexer_Accumulator__flush;
    me->print_this    = Calc_lexer_Accumulator_print_this;


    return true;
}


 void
Calc_lexer_Accumulator_destruct(Calc_lexer_Accumulator* me)
{
    if( me->text.begin ) {
        quex_MemoryManager_free((void*)me->text.begin,
                                   E_MemoryObjectType_TEXT);
    }
    Calc_lexer_Accumulator_resources_absent_mark(me);
}

 void
Calc_lexer_Accumulator_resources_absent_mark(Calc_lexer_Accumulator* me)
{
    me->the_lexer       = 0x0;
    me->text.begin      = 0x0;
    me->text.end        = 0x0;
    me->text.memory_end = 0x0;
}

 bool
Calc_lexer_Accumulator_resources_absent(Calc_lexer_Accumulator* me)
{
    return    me->the_lexer == 0x0 && me->text.begin      == 0x0 
           && me->text.end  == 0x0 && me->text.memory_end == 0x0;
}


 bool
Calc_lexer_Accumulator__memory_resources_allocate(Calc_lexer_Accumulator*   me) 
{
    Calc_lexer_lexatom_t* chunk = (Calc_lexer_lexatom_t*)0;

    if( QUEX_Calc_lexer_SETTING_ACCUMULATOR_INITIAL_SIZE ) {
        chunk = (Calc_lexer_lexatom_t*)
                quex_MemoryManager_allocate(
                           QUEX_Calc_lexer_SETTING_ACCUMULATOR_INITIAL_SIZE * sizeof(Calc_lexer_lexatom_t),
                           E_MemoryObjectType_TEXT);
        if( ! chunk ) return false;
    }
    me->text.begin      = chunk;
    me->text.end        = me->text.begin;
    me->text.memory_end = &me->text.begin[QUEX_Calc_lexer_SETTING_ACCUMULATOR_INITIAL_SIZE];
    return true;
}

 bool
Calc_lexer_Accumulator__extend(Calc_lexer_Accumulator* me, size_t MinAddSize)
{
    const size_t  OldContentSize = (size_t)(me->text.end - me->text.begin);
    const size_t  Size    = (size_t)(me->text.memory_end - me->text.begin);
    const size_t  AddSize = (size_t)((float)Size * (float)QUEX_Calc_lexer_SETTING_ACCUMULATOR_GRANULARITY_FACTOR);
    const size_t  NewSize = Size + (AddSize < MinAddSize ? MinAddSize : AddSize);

    Calc_lexer_lexatom_t*  chunk = \
          (Calc_lexer_lexatom_t*)
          quex_MemoryManager_allocate(NewSize*sizeof(Calc_lexer_lexatom_t),
                                         E_MemoryObjectType_TEXT);

    if( chunk == 0x0 ) return false;

    __quex_assert(me->text.end >= me->text.begin);
    __quex_assert(me->text.memory_end >= me->text.begin);

    __QUEX_STD_memcpy(chunk, me->text.begin, sizeof(Calc_lexer_lexatom_t) * Size);

    quex_MemoryManager_free((void*)me->text.begin, E_MemoryObjectType_TEXT);

    me->text.begin      = chunk;
    me->text.end        = chunk + OldContentSize;
    me->text.memory_end = chunk + NewSize;
    return true;
}

 void
Calc_lexer_Accumulator__clear(Calc_lexer_Accumulator* me)
{
    me->text.end = me->text.begin;
}

 void 
Calc_lexer_Accumulator__add(Calc_lexer_Accumulator* me,
                           const Calc_lexer_lexatom_t* Begin, const Calc_lexer_lexatom_t* End)
{ 
    const size_t L = (size_t)(End - Begin);
    __quex_assert(End > Begin);

    /* If it is the first string to be appended, the store the location */
    if( me->text.begin == me->text.end ) {
           me->_begin_line   = me->the_lexer->counter._line_number_at_begin;
         me->_begin_column = me->the_lexer->counter._column_number_at_begin;
    }

    /* Ensure, that there is one more cell between end and .memory_end to store
     * the terminating zero for flushing or printing.                           */
    if( me->text.memory_end <= me->text.end + L ) {
        /* L + 1 we need space for the string + the terminating zero */
        if( Calc_lexer_Accumulator__extend(me, L + 1) == false ) {
            if( me->the_lexer ) {
                Calc_lexer_MF_error_code_set_if_first(me->the_lexer, 
                                                      E_Error_Accumulator_OutOfMemory);
                return;
            }
        }
    }

    __QUEX_STD_memcpy(me->text.end, Begin, L * sizeof(Calc_lexer_lexatom_t));
    me->text.end += L;
}


 void 
Calc_lexer_Accumulator__add_character(Calc_lexer_Accumulator*     me,
                                      const Calc_lexer_lexatom_t  Character)
{ 
    /* If it is the first string to be appended, the store the location */
    if( me->text.begin == me->text.end ) {
           me->_begin_line   = me->the_lexer->counter._line_number_at_begin;
         me->_begin_column = me->the_lexer->counter._column_number_at_begin;
    }

    /* Ensure, that there is one more cell between end and .memory_end to store
     * the terminating zero for flushing or printing.                           */
    if( me->text.memory_end <= me->text.end + 1 ) {
        /* 1 + 1 we need space for the character + the terminating zero */
        if( Calc_lexer_Accumulator__extend(me, 2) == false ) {
            if( me->the_lexer ) {
                Calc_lexer_MF_error_code_set_if_first(me->the_lexer, 
                                                      E_Error_Accumulator_OutOfMemory);
                return;
            }
        }
    }

    *(me->text.end) = Character;
    ++(me->text.end);
}

 bool
Calc_lexer_Accumulator__flush(Calc_lexer_Accumulator*   me,
                              const Calc_lexer_token_id_t  TokenID)
{
    Calc_lexer_lexatom_t* begin_p;
    Calc_lexer_lexatom_t* end_p;

    if( Calc_lexer_TokenQueue_is_full(&me->the_lexer->_token_queue) ) {
        Calc_lexer_MF_error_code_set_if_first(me->the_lexer, 
                                              E_Error_Token_QueueOverflow);
        return false;
    }

    /* All functions must ensure: there is one cell to store terminating zero.*/  
    __quex_assert(me->text.end < me->text.memory_end);   

    if( me->text.begin == me->text.end ) {               
        begin_p = &Calc_lexer_LexemeNull;
        end_p   = &Calc_lexer_LexemeNull;             /* -> terminating zero. */
    }
    else {
        begin_p  = me->text.begin;
        end_p    = me->text.end;
        end_p[0] = (Calc_lexer_lexatom_t)0;              /* -> terminating zero. */
    }                                                                              
    /* 'end_p' points *to* terminating zero, *not* behind it.                 */

    /* If no text is to be flushed, behave the same as self_send              */             
    /* That is: self_token_set_id(ID);                                        */             
    /*          QUEX_TOKEN_POLICY_PREPARE_NEXT();                             */             
    /*          BUT: We clear the text of the otherwise void token.           */             
    if( ! Calc_lexer_TokenQueue_push_text(&me->the_lexer->_token_queue, TokenID,
                                          begin_p, end_p) ) {
        /* MEMORY OWNERSHIP *not* transferred to token. Reuse current memory. */
        Calc_lexer_Accumulator__clear(me);                       
    }          
    else {                                                                   
        /* MEMORY OWNERSHIP transferred to token. => Access new memory.       */
        Calc_lexer_Accumulator__memory_resources_allocate(me);                 
    }                                                                          

    return true;
}

 void  
Calc_lexer_Accumulator_print_this(Calc_lexer_Accumulator* me)
{
    /* All functions must ensure that there is one cell left to store the terminating zero. */


    QUEX_DEBUG_PRINT("  accumulator: ");
    if( ! me->text.end || ! me->text.begin ) {
        QUEX_DEBUG_PRINT("<uninitialized>\n");
    }
    else {
        __quex_assert(me->text.end < me->text.memory_end);
        *(me->text.end) = (Calc_lexer_lexatom_t)0; /* see above '__quex_assert()' */
        QUEX_DEBUG_PRINT1("'%s'\n", (const char*)me->text.begin);
    }
}





#endif /* QUEX_INCLUDE_GUARD_EXTRA__ACCUMULATOR__ACCUMULATOR_I */
