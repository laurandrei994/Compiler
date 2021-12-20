/* -*- C++ -*- vim:set syntax=cpp:
 *
 * (C) 2005-2009 Frank-Rene Schaefer                                        */
#ifndef QUEX_INCLUDE_GUARD_compilator__EXTRA__ACCUMULATOR__ACCUMULATOR_I
#define QUEX_INCLUDE_GUARD_compilator__EXTRA__ACCUMULATOR__ACCUMULATOR_I

#include "compilator\lib\definitions"
#include "compilator\lib\extra/accumulator/Accumulator"
#include "compilator\lib\quex/MemoryManager"



inline void
compilator_Accumulator_destruct(compilator_Accumulator* me);
                      
inline bool      
compilator_Accumulator__extend(compilator_Accumulator* me, size_t MinAddSize);
                      
inline void      
compilator_Accumulator_print_this(compilator_Accumulator* me);
                      
inline bool
compilator_Accumulator__flush(compilator_Accumulator*   me,
                              const compilator_token_id_t  TokenID);
                      
inline bool
compilator_Accumulator__memory_resources_allocate(compilator_Accumulator*   me);

inline bool      
compilator_Accumulator_construct(compilator_Accumulator*   me, 
                                 compilator*       lexer)
{
    me->the_lexer = lexer;

    if( ! compilator_Accumulator__memory_resources_allocate(me) ) {
        compilator_Accumulator_resources_absent_mark(me);
        return false;
    }
        
       me->_begin_line   = 0;
     me->_begin_column = 0;



    return true;
}


inline void
compilator_Accumulator_destruct(compilator_Accumulator* me)
{
    if( me->text.begin ) {
        quex::MemoryManager_free((void*)me->text.begin,
                                   E_MemoryObjectType_TEXT);
    }
    compilator_Accumulator_resources_absent_mark(me);
}

inline void
compilator_Accumulator_resources_absent_mark(compilator_Accumulator* me)
{
    me->the_lexer       = 0x0;
    me->text.begin      = 0x0;
    me->text.end        = 0x0;
    me->text.memory_end = 0x0;
}

inline bool
compilator_Accumulator_resources_absent(compilator_Accumulator* me)
{
    return    me->the_lexer == 0x0 && me->text.begin      == 0x0 
           && me->text.end  == 0x0 && me->text.memory_end == 0x0;
}


inline bool
compilator_Accumulator__memory_resources_allocate(compilator_Accumulator*   me) 
{
    compilator_lexatom_t* chunk = (compilator_lexatom_t*)0;

    if( QUEX_compilator_SETTING_ACCUMULATOR_INITIAL_SIZE ) {
        chunk = (compilator_lexatom_t*)
                quex::MemoryManager_allocate(
                           QUEX_compilator_SETTING_ACCUMULATOR_INITIAL_SIZE * sizeof(compilator_lexatom_t),
                           E_MemoryObjectType_TEXT);
        if( ! chunk ) return false;
    }
    me->text.begin      = chunk;
    me->text.end        = me->text.begin;
    me->text.memory_end = &me->text.begin[QUEX_compilator_SETTING_ACCUMULATOR_INITIAL_SIZE];
    return true;
}

inline bool
compilator_Accumulator__extend(compilator_Accumulator* me, size_t MinAddSize)
{
    const size_t  OldContentSize = (size_t)(me->text.end - me->text.begin);
    const size_t  Size    = (size_t)(me->text.memory_end - me->text.begin);
    const size_t  AddSize = (size_t)((float)Size * (float)QUEX_compilator_SETTING_ACCUMULATOR_GRANULARITY_FACTOR);
    const size_t  NewSize = Size + (AddSize < MinAddSize ? MinAddSize : AddSize);

    compilator_lexatom_t*  chunk = \
          (compilator_lexatom_t*)
          quex::MemoryManager_allocate(NewSize*sizeof(compilator_lexatom_t),
                                         E_MemoryObjectType_TEXT);

    if( chunk == 0x0 ) return false;

    __quex_assert(me->text.end >= me->text.begin);
    __quex_assert(me->text.memory_end >= me->text.begin);

    __QUEX_STD_memcpy(chunk, me->text.begin, sizeof(compilator_lexatom_t) * Size);

    quex::MemoryManager_free((void*)me->text.begin, E_MemoryObjectType_TEXT);

    me->text.begin      = chunk;
    me->text.end        = chunk + OldContentSize;
    me->text.memory_end = chunk + NewSize;
    return true;
}

inline void
compilator_Accumulator__clear(compilator_Accumulator* me)
{
    me->text.end = me->text.begin;
}

inline void 
compilator_Accumulator__add(compilator_Accumulator* me,
                           const compilator_lexatom_t* Begin, const compilator_lexatom_t* End)
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
        if( compilator_Accumulator__extend(me, L + 1) == false ) {
            if( me->the_lexer ) {
                compilator_MF_error_code_set_if_first(me->the_lexer, 
                                                      E_Error_Accumulator_OutOfMemory);
                return;
            }
        }
    }

    __QUEX_STD_memcpy(me->text.end, Begin, L * sizeof(compilator_lexatom_t));
    me->text.end += L;
}


inline void 
compilator_Accumulator__add_character(compilator_Accumulator*     me,
                                      const compilator_lexatom_t  Character)
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
        if( compilator_Accumulator__extend(me, 2) == false ) {
            if( me->the_lexer ) {
                compilator_MF_error_code_set_if_first(me->the_lexer, 
                                                      E_Error_Accumulator_OutOfMemory);
                return;
            }
        }
    }

    *(me->text.end) = Character;
    ++(me->text.end);
}

inline bool
compilator_Accumulator__flush(compilator_Accumulator*   me,
                              const compilator_token_id_t  TokenID)
{
    compilator_lexatom_t* begin_p;
    compilator_lexatom_t* end_p;

    if( compilator_TokenQueue_is_full(&me->the_lexer->_token_queue) ) {
        compilator_MF_error_code_set_if_first(me->the_lexer, 
                                              E_Error_Token_QueueOverflow);
        return false;
    }

    /* All functions must ensure: there is one cell to store terminating zero.*/  
    __quex_assert(me->text.end < me->text.memory_end);   

    if( me->text.begin == me->text.end ) {               
        begin_p = &compilator_LexemeNull;
        end_p   = &compilator_LexemeNull;             /* -> terminating zero. */
    }
    else {
        begin_p  = me->text.begin;
        end_p    = me->text.end;
        end_p[0] = (compilator_lexatom_t)0;              /* -> terminating zero. */
    }                                                                              
    /* 'end_p' points *to* terminating zero, *not* behind it.                 */

    /* If no text is to be flushed, behave the same as self_send              */             
    /* That is: self_token_set_id(ID);                                        */             
    /*          QUEX_TOKEN_POLICY_PREPARE_NEXT();                             */             
    /*          BUT: We clear the text of the otherwise void token.           */             
    if( ! compilator_TokenQueue_push_text(&me->the_lexer->_token_queue, TokenID,
                                          begin_p, end_p) ) {
        /* MEMORY OWNERSHIP *not* transferred to token. Reuse current memory. */
        compilator_Accumulator__clear(me);                       
    }          
    else {                                                                   
        /* MEMORY OWNERSHIP transferred to token. => Access new memory.       */
        compilator_Accumulator__memory_resources_allocate(me);                 
    }                                                                          

    return true;
}

inline void  
compilator_Accumulator_print_this(compilator_Accumulator* me)
{
    /* All functions must ensure that there is one cell left to store the terminating zero. */


    QUEX_DEBUG_PRINT("  accumulator: ");
    if( ! me->text.end || ! me->text.begin ) {
        QUEX_DEBUG_PRINT("<uninitialized>\n");
    }
    else {
        __quex_assert(me->text.end < me->text.memory_end);
        *(me->text.end) = (compilator_lexatom_t)0; /* see above '__quex_assert()' */
        QUEX_DEBUG_PRINT1("'%s'\n", (const char*)me->text.begin);
    }
}


inline 
compilator_Accumulator::compilator_Accumulator()
{ /* C/C++ Compability: Constructors/Destructors do nothing. */ }
                      
inline 
compilator_Accumulator::~compilator_Accumulator()
{ /* C/C++ Compability: Constructors/Destructors do nothing. */ }
                      
inline void      
compilator_Accumulator::clear()
{ compilator_Accumulator__clear(this); }
                      
inline void      
compilator_Accumulator::add(const compilator_lexatom_t* Begin, 
                            const compilator_lexatom_t* End)
{ compilator_Accumulator__add(this, Begin, End); }
                      
inline void      
compilator_Accumulator::add_character(const compilator_lexatom_t  Lexatom)
{ compilator_Accumulator__add_character(this, Lexatom); }
                      
inline bool      
compilator_Accumulator::extend(size_t MinAddSize)
{ return compilator_Accumulator__extend(this, MinAddSize); }

inline bool      
compilator_Accumulator::flush(const compilator_token_id_t TokenID)
{ return compilator_Accumulator__flush(this, TokenID); }
                      
inline void      
compilator_Accumulator::print_this()
{ compilator_Accumulator_print_this(this); }




#endif /* QUEX_INCLUDE_GUARD_EXTRA__ACCUMULATOR__ACCUMULATOR_I */
