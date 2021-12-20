/* -*- C++ -*- vim:set syntax=cpp:
 *
 * (C) 2005-2009 Frank-Rene Schaefer                                        */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__EXTRA__ACCUMULATOR__ACCUMULATOR_I
#define QUEX_INCLUDE_GUARD_quexProcessed__EXTRA__ACCUMULATOR__ACCUMULATOR_I

#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/extra/accumulator/Accumulator"
#include "quexProcessed/lib/quex/MemoryManager"



inline void
quexProcessed_Accumulator_destruct(quexProcessed_Accumulator* me);
                      
inline bool      
quexProcessed_Accumulator__extend(quexProcessed_Accumulator* me, size_t MinAddSize);
                      
inline void      
quexProcessed_Accumulator_print_this(quexProcessed_Accumulator* me);
                      
inline bool
quexProcessed_Accumulator__flush(quexProcessed_Accumulator*   me,
                              const quexProcessed_token_id_t  TokenID);
                      
inline bool
quexProcessed_Accumulator__memory_resources_allocate(quexProcessed_Accumulator*   me);

inline bool      
quexProcessed_Accumulator_construct(quexProcessed_Accumulator*   me, 
                                 quexProcessed*       lexer)
{
    me->the_lexer = lexer;

    if( ! quexProcessed_Accumulator__memory_resources_allocate(me) ) {
        quexProcessed_Accumulator_resources_absent_mark(me);
        return false;
    }
        
       me->_begin_line   = 0;
     me->_begin_column = 0;



    return true;
}


inline void
quexProcessed_Accumulator_destruct(quexProcessed_Accumulator* me)
{
    if( me->text.begin ) {
        quex::MemoryManager_free((void*)me->text.begin,
                                   E_MemoryObjectType_TEXT);
    }
    quexProcessed_Accumulator_resources_absent_mark(me);
}

inline void
quexProcessed_Accumulator_resources_absent_mark(quexProcessed_Accumulator* me)
{
    me->the_lexer       = 0x0;
    me->text.begin      = 0x0;
    me->text.end        = 0x0;
    me->text.memory_end = 0x0;
}

inline bool
quexProcessed_Accumulator_resources_absent(quexProcessed_Accumulator* me)
{
    return    me->the_lexer == 0x0 && me->text.begin      == 0x0 
           && me->text.end  == 0x0 && me->text.memory_end == 0x0;
}


inline bool
quexProcessed_Accumulator__memory_resources_allocate(quexProcessed_Accumulator*   me) 
{
    quexProcessed_lexatom_t* chunk = (quexProcessed_lexatom_t*)0;

    if( QUEX_quexProcessed_SETTING_ACCUMULATOR_INITIAL_SIZE ) {
        chunk = (quexProcessed_lexatom_t*)
                quex::MemoryManager_allocate(
                           QUEX_quexProcessed_SETTING_ACCUMULATOR_INITIAL_SIZE * sizeof(quexProcessed_lexatom_t),
                           E_MemoryObjectType_TEXT);
        if( ! chunk ) return false;
    }
    me->text.begin      = chunk;
    me->text.end        = me->text.begin;
    me->text.memory_end = &me->text.begin[QUEX_quexProcessed_SETTING_ACCUMULATOR_INITIAL_SIZE];
    return true;
}

inline bool
quexProcessed_Accumulator__extend(quexProcessed_Accumulator* me, size_t MinAddSize)
{
    const size_t  OldContentSize = (size_t)(me->text.end - me->text.begin);
    const size_t  Size    = (size_t)(me->text.memory_end - me->text.begin);
    const size_t  AddSize = (size_t)((float)Size * (float)QUEX_quexProcessed_SETTING_ACCUMULATOR_GRANULARITY_FACTOR);
    const size_t  NewSize = Size + (AddSize < MinAddSize ? MinAddSize : AddSize);

    quexProcessed_lexatom_t*  chunk = \
          (quexProcessed_lexatom_t*)
          quex::MemoryManager_allocate(NewSize*sizeof(quexProcessed_lexatom_t),
                                         E_MemoryObjectType_TEXT);

    if( chunk == 0x0 ) return false;

    __quex_assert(me->text.end >= me->text.begin);
    __quex_assert(me->text.memory_end >= me->text.begin);

    __QUEX_STD_memcpy(chunk, me->text.begin, sizeof(quexProcessed_lexatom_t) * Size);

    quex::MemoryManager_free((void*)me->text.begin, E_MemoryObjectType_TEXT);

    me->text.begin      = chunk;
    me->text.end        = chunk + OldContentSize;
    me->text.memory_end = chunk + NewSize;
    return true;
}

inline void
quexProcessed_Accumulator__clear(quexProcessed_Accumulator* me)
{
    me->text.end = me->text.begin;
}

inline void 
quexProcessed_Accumulator__add(quexProcessed_Accumulator* me,
                           const quexProcessed_lexatom_t* Begin, const quexProcessed_lexatom_t* End)
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
        if( quexProcessed_Accumulator__extend(me, L + 1) == false ) {
            if( me->the_lexer ) {
                quexProcessed_MF_error_code_set_if_first(me->the_lexer, 
                                                      E_Error_Accumulator_OutOfMemory);
                return;
            }
        }
    }

    __QUEX_STD_memcpy(me->text.end, Begin, L * sizeof(quexProcessed_lexatom_t));
    me->text.end += L;
}


inline void 
quexProcessed_Accumulator__add_character(quexProcessed_Accumulator*     me,
                                      const quexProcessed_lexatom_t  Character)
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
        if( quexProcessed_Accumulator__extend(me, 2) == false ) {
            if( me->the_lexer ) {
                quexProcessed_MF_error_code_set_if_first(me->the_lexer, 
                                                      E_Error_Accumulator_OutOfMemory);
                return;
            }
        }
    }

    *(me->text.end) = Character;
    ++(me->text.end);
}

inline bool
quexProcessed_Accumulator__flush(quexProcessed_Accumulator*   me,
                              const quexProcessed_token_id_t  TokenID)
{
    quexProcessed_lexatom_t* begin_p;
    quexProcessed_lexatom_t* end_p;

    if( quexProcessed_TokenQueue_is_full(&me->the_lexer->_token_queue) ) {
        quexProcessed_MF_error_code_set_if_first(me->the_lexer, 
                                              E_Error_Token_QueueOverflow);
        return false;
    }

    /* All functions must ensure: there is one cell to store terminating zero.*/  
    __quex_assert(me->text.end < me->text.memory_end);   

    if( me->text.begin == me->text.end ) {               
        begin_p = &quexProcessed_LexemeNull;
        end_p   = &quexProcessed_LexemeNull;             /* -> terminating zero. */
    }
    else {
        begin_p  = me->text.begin;
        end_p    = me->text.end;
        end_p[0] = (quexProcessed_lexatom_t)0;              /* -> terminating zero. */
    }                                                                              
    /* 'end_p' points *to* terminating zero, *not* behind it.                 */

    /* If no text is to be flushed, behave the same as self_send              */             
    /* That is: self_token_set_id(ID);                                        */             
    /*          QUEX_TOKEN_POLICY_PREPARE_NEXT();                             */             
    /*          BUT: We clear the text of the otherwise void token.           */             
    if( ! quexProcessed_TokenQueue_push_text(&me->the_lexer->_token_queue, TokenID,
                                          begin_p, end_p) ) {
        /* MEMORY OWNERSHIP *not* transferred to token. Reuse current memory. */
        quexProcessed_Accumulator__clear(me);                       
    }          
    else {                                                                   
        /* MEMORY OWNERSHIP transferred to token. => Access new memory.       */
        quexProcessed_Accumulator__memory_resources_allocate(me);                 
    }                                                                          

    return true;
}

inline void  
quexProcessed_Accumulator_print_this(quexProcessed_Accumulator* me)
{
    /* All functions must ensure that there is one cell left to store the terminating zero. */


    QUEX_DEBUG_PRINT("  accumulator: ");
    if( ! me->text.end || ! me->text.begin ) {
        QUEX_DEBUG_PRINT("<uninitialized>\n");
    }
    else {
        __quex_assert(me->text.end < me->text.memory_end);
        *(me->text.end) = (quexProcessed_lexatom_t)0; /* see above '__quex_assert()' */
        QUEX_DEBUG_PRINT1("'%s'\n", (const char*)me->text.begin);
    }
}


inline 
quexProcessed_Accumulator::quexProcessed_Accumulator()
{ /* C/C++ Compability: Constructors/Destructors do nothing. */ }
                      
inline 
quexProcessed_Accumulator::~quexProcessed_Accumulator()
{ /* C/C++ Compability: Constructors/Destructors do nothing. */ }
                      
inline void      
quexProcessed_Accumulator::clear()
{ quexProcessed_Accumulator__clear(this); }
                      
inline void      
quexProcessed_Accumulator::add(const quexProcessed_lexatom_t* Begin, 
                            const quexProcessed_lexatom_t* End)
{ quexProcessed_Accumulator__add(this, Begin, End); }
                      
inline void      
quexProcessed_Accumulator::add_character(const quexProcessed_lexatom_t  Lexatom)
{ quexProcessed_Accumulator__add_character(this, Lexatom); }
                      
inline bool      
quexProcessed_Accumulator::extend(size_t MinAddSize)
{ return quexProcessed_Accumulator__extend(this, MinAddSize); }

inline bool      
quexProcessed_Accumulator::flush(const quexProcessed_token_id_t TokenID)
{ return quexProcessed_Accumulator__flush(this, TokenID); }
                      
inline void      
quexProcessed_Accumulator::print_this()
{ quexProcessed_Accumulator_print_this(this); }




#endif /* QUEX_INCLUDE_GUARD_EXTRA__ACCUMULATOR__ACCUMULATOR_I */
