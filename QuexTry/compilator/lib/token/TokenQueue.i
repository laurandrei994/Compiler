/* -*- C++ -*- vim: set syntax=cpp: 
 * PURPOSE: Token Queue 
 *
 * A token queue is a queue where read and write cycles are separate.
 * That is, when the queue is filled, it is not read until the 
 * filling terminated. Then, the read does not terminate before there
 * is no more token left.
 *
 * Wrap-arround is neither necessary nor meaningful!
 *
 * (C) 2004-2017 Frank-Rene Schaefer                                          */
#ifndef QUEX_INCLUDE_GUARD_compilator__TOKEN__TOKEN_QUEUE_I
#define QUEX_INCLUDE_GUARD_compilator__TOKEN__TOKEN_QUEUE_I

#include "compilator\lib\definitions"
#include "compilator\lib\quex/asserts"
#include "compilator\lib\quex/MemoryManager"

/* NOTE: compilator_Token must be defined at this place!                       */

#include "compilator\lib\token/TokenQueue"



inline void             
compilator_TokenQueue_push_core(compilator_TokenQueue* me, compilator_token_id_t Id);

inline bool
compilator_TokenQueue_construct(compilator_TokenQueue* me, 
                                compilator*    lexer,
                                const size_t           N)
/* me:     The token queue.
 * Memory: Pointer to memory of token queue, 0x0 --> no initial memory.
 * N:      Number of token objects that the array can carry.                  */
{
    compilator_Token*   iterator   = 0x0;
    compilator_Token*   memory     = (compilator_Token*)quex::MemoryManager_allocate(
                                             N * sizeof(compilator_Token),
                                             E_MemoryObjectType_TOKEN_ARRAY);
    compilator_Token*   memory_end = &memory[N];

    if( ! memory ) {
        compilator_TokenQueue_resources_absent_mark(me);
        return false;
    }

    __quex_assert(memory != 0x0);

    /* Call placement new (plain constructor) for all tokens in chunk.        */
    for(iterator = memory; iterator != memory_end; ++iterator) {
        compilator_Token_construct(iterator);
    }
    compilator_TokenQueue_init(me, memory, memory_end); 
    me->the_lexer = lexer;
    return true;
}

inline void
compilator_TokenQueue_reset(compilator_TokenQueue* me) 
{                                                    
    me->read_iterator  = (compilator_Token*)me->begin; 
    me->write_iterator = (compilator_Token*)me->begin; 
}

inline void
compilator_TokenQueue_init(compilator_TokenQueue* me, 
                           compilator_Token*       Memory, 
                           compilator_Token*       MemoryEnd) 
{
    me->begin = Memory;                           
    me->end   = MemoryEnd;                        
    compilator_TokenQueue_reset(me);                                
}

inline void
compilator_TokenQueue_resources_absent_mark(compilator_TokenQueue* me) 
{
    me->begin          = (compilator_Token*)0;                           
    me->end            = (compilator_Token*)0;
    me->read_iterator  = (compilator_Token*)0; 
    me->write_iterator = (compilator_Token*)0; 
    me->the_lexer      = (compilator*)0; 
}

inline bool
compilator_TokenQueue_resources_absent(compilator_TokenQueue* me) 
{
    return    me->begin          == (compilator_Token*)0                           
           && me->end            == (compilator_Token*)0
           && me->read_iterator  == (compilator_Token*)0 
           && me->write_iterator == (compilator_Token*)0
           && me->the_lexer      == (compilator*)0;
}

inline void
compilator_TokenQueue_destruct(compilator_TokenQueue* me)
{
    compilator_Token* iterator = 0x0;
    /* Call explicit destructors for all tokens in array                      */
    for(iterator = me->begin; iterator != me->end; ++iterator) {
        compilator_Token_destruct(iterator);
    }

    quex::MemoryManager_free((void*)&me->begin[0],
                               E_MemoryObjectType_TOKEN_ARRAY);

    /* The memory chunk for the token queue itself is located inside the
     * analyzer object. Thus, no explicit free is necessary. In case of user
     * managed token queue memory the user takes care of the deletion.        */
    compilator_TokenQueue_resources_absent_mark(me);
}

inline void   
compilator_TokenQueue_remainder_get(compilator_TokenQueue* me,
                                    compilator_Token**      begin,
                                    compilator_Token**      end)
{
    *begin = me->read_iterator;
    *end   = me->write_iterator;
    compilator_TokenQueue_reset(me);
}

inline void 
compilator_TokenQueue_memory_get(compilator_TokenQueue* me,
                                 compilator_Token**      memory,
                                 size_t*                n)
{
    *memory = me->begin;
    *n      = (size_t)(me->end - me->begin);
}

inline bool 
compilator_TokenQueue_is_full(compilator_TokenQueue* me) 
{ return me->write_iterator >= me->end; }

inline bool 
compilator_TokenQueue_is_empty(compilator_TokenQueue* me)
{ return me->read_iterator == me->write_iterator; }

inline void             
compilator_TokenQueue_push(compilator_TokenQueue* me,
                           compilator_token_id_t     Id)
/* Push a token and set only its token identifier.                           */
{

    compilator_TokenQueue_push_core(me, Id);
}

inline void             
compilator_TokenQueue_push_core(compilator_TokenQueue* me,
                                compilator_token_id_t     Id)
{
    if( compilator_TokenQueue_is_full(me) ) {
        me->the_lexer->error_code = E_Error_Token_QueueOverflow;
        return;
    }
    compilator_TokenQueue_assert_before_sending(me);  

       me->write_iterator->_line_n   = me->the_lexer->counter._line_number_at_begin;
     me->write_iterator->_column_n = me->the_lexer->counter._column_number_at_begin;

    me->write_iterator->id = Id;              
    ++(me->write_iterator);       
}


inline bool             
compilator_TokenQueue_push_text(compilator_TokenQueue* me,
                                compilator_token_id_t     Id,
                                compilator_lexatom_t*     BeginP,
                                compilator_lexatom_t*     EndP)
/* Push a token and set its 'text' member.                                    */
{
    bool ownership_transferred_to_token_f = false;
    compilator_TokenQueue_assert_before_sending(me);
    ownership_transferred_to_token_f = compilator_Token_take_text(me->write_iterator, BeginP, EndP);
    compilator_TokenQueue_push(me, Id);
    return ownership_transferred_to_token_f;
}







inline void             
compilator_TokenQueue_push_repeated(compilator_TokenQueue* me,
                                    compilator_token_id_t     Id,
                                    size_t                 RepetitionN)
/* Push a repeated token by 'RepetitionN' times. This is only addmissible for
 * TokenId-s specified in the 'repeated_token' section of the '.qx' file.     */
{
    compilator_TokenQueue_assert_before_sending(me);  
    (void)me; (void)Id; (void)RepetitionN;
    __quex_assert(RepetitionN != 0);        

    __quex_assert((const char*)0 == "Token type does not support token repetition.");
    compilator_TokenQueue_set_token_TERMINATION(me);
}

inline compilator_Token* 
compilator_TokenQueue_pop(compilator_TokenQueue* me)
{
    __quex_assert(compilator_TokenQueue_begin(me) != 0x0);

    if( compilator_TokenQueue_is_empty(me) ) {        
        return (compilator_Token*)0;
    }
    /* Tokens are in queue --> take next token from queue                    */ 
    return me->read_iterator++;
}


inline compilator_Token* compilator_TokenQueue_begin(compilator_TokenQueue* me)
{ return me->begin; }

inline compilator_Token* compilator_TokenQueue_back(compilator_TokenQueue* me)
{ return me->end - 1; }

inline compilator_Token* compilator_TokenQueue_last_token(compilator_TokenQueue* me)
{ return me->write_iterator == me->begin ? (compilator_Token*)0 : &me->write_iterator[-1]; }

inline size_t compilator_TokenQueue_available_n(compilator_TokenQueue* me) 
{ return (size_t)(me->end - me->write_iterator); }

inline void
compilator_TokenQueue_set_token_TERMINATION(compilator_TokenQueue* me) 
/* Reset entire token queue and set the token 'TERMINATION'. This should
 * only be called in case of a detected error.                                */
{
    compilator_TokenQueue_reset(me);

    compilator_TokenQueue_push_text(me, TKN_TERMINATION, 
                                    (compilator_lexatom_t*)0, (compilator_lexatom_t*)0);


}

inline bool             
compilator_TokenQueue_assert_before_sending(compilator_TokenQueue* me)
{                                                                              
    if( ! compilator_TokenQueue_assert_after_sending(me) ) {
        return false;
    } 
    /* End of token queue has not been reached.                       */          
    __quex_assert((me)->write_iterator != (me)->end);                             
    /* No token sending after 'TERMINATION'.                          */          
    __quex_assert(   (me)->write_iterator         == (me)->begin                  
                  || (me)->write_iterator[-1].id !=  TKN_TERMINATION ); 
    return true;
} 

inline bool             
compilator_TokenQueue_assert_after_sending(compilator_TokenQueue* me)
{                                                                     
    __quex_assert((me)->begin != 0x0);                                   
    __quex_assert((me)->read_iterator  >= (me)->begin);                  
    __quex_assert((me)->write_iterator >= (me)->read_iterator);          
    /* If the following breaks, then the given queue size was to small*/ 
    if( (me)->write_iterator > (me)->end ) {                            
        QUEX_ERROR_EXIT("Error: Token queue overflow.");                 
        return false;
    }                                                                    
    return true;
}



#endif /* QUEX_INCLUDE_GUARD_compilator__TOKEN__TOKEN_QUEUE_I */
