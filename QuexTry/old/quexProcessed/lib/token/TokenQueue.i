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
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__TOKEN__TOKEN_QUEUE_I
#define QUEX_INCLUDE_GUARD_quexProcessed__TOKEN__TOKEN_QUEUE_I

#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/quex/asserts"
#include "quexProcessed/lib/quex/MemoryManager"

/* NOTE: quexProcessed_Token must be defined at this place!                       */

#include "quexProcessed/lib/token/TokenQueue"



inline void             
quexProcessed_TokenQueue_push_core(quexProcessed_TokenQueue* me, quexProcessed_token_id_t Id);

inline bool
quexProcessed_TokenQueue_construct(quexProcessed_TokenQueue* me, 
                                quexProcessed*    lexer,
                                const size_t           N)
/* me:     The token queue.
 * Memory: Pointer to memory of token queue, 0x0 --> no initial memory.
 * N:      Number of token objects that the array can carry.                  */
{
    quexProcessed_Token*   iterator   = 0x0;
    quexProcessed_Token*   memory     = (quexProcessed_Token*)quex::MemoryManager_allocate(
                                             N * sizeof(quexProcessed_Token),
                                             E_MemoryObjectType_TOKEN_ARRAY);
    quexProcessed_Token*   memory_end = &memory[N];

    if( ! memory ) {
        quexProcessed_TokenQueue_resources_absent_mark(me);
        return false;
    }

    __quex_assert(memory != 0x0);

    /* Call placement new (plain constructor) for all tokens in chunk.        */
    for(iterator = memory; iterator != memory_end; ++iterator) {
        quexProcessed_Token_construct(iterator);
    }
    quexProcessed_TokenQueue_init(me, memory, memory_end); 
    me->the_lexer = lexer;
    return true;
}

inline void
quexProcessed_TokenQueue_reset(quexProcessed_TokenQueue* me) 
{                                                    
    me->read_iterator  = (quexProcessed_Token*)me->begin; 
    me->write_iterator = (quexProcessed_Token*)me->begin; 
}

inline void
quexProcessed_TokenQueue_init(quexProcessed_TokenQueue* me, 
                           quexProcessed_Token*       Memory, 
                           quexProcessed_Token*       MemoryEnd) 
{
    me->begin = Memory;                           
    me->end   = MemoryEnd;                        
    quexProcessed_TokenQueue_reset(me);                                
}

inline void
quexProcessed_TokenQueue_resources_absent_mark(quexProcessed_TokenQueue* me) 
{
    me->begin          = (quexProcessed_Token*)0;                           
    me->end            = (quexProcessed_Token*)0;
    me->read_iterator  = (quexProcessed_Token*)0; 
    me->write_iterator = (quexProcessed_Token*)0; 
    me->the_lexer      = (quexProcessed*)0; 
}

inline bool
quexProcessed_TokenQueue_resources_absent(quexProcessed_TokenQueue* me) 
{
    return    me->begin          == (quexProcessed_Token*)0                           
           && me->end            == (quexProcessed_Token*)0
           && me->read_iterator  == (quexProcessed_Token*)0 
           && me->write_iterator == (quexProcessed_Token*)0
           && me->the_lexer      == (quexProcessed*)0;
}

inline void
quexProcessed_TokenQueue_destruct(quexProcessed_TokenQueue* me)
{
    quexProcessed_Token* iterator = 0x0;
    /* Call explicit destructors for all tokens in array                      */
    for(iterator = me->begin; iterator != me->end; ++iterator) {
        quexProcessed_Token_destruct(iterator);
    }

    quex::MemoryManager_free((void*)&me->begin[0],
                               E_MemoryObjectType_TOKEN_ARRAY);

    /* The memory chunk for the token queue itself is located inside the
     * analyzer object. Thus, no explicit free is necessary. In case of user
     * managed token queue memory the user takes care of the deletion.        */
    quexProcessed_TokenQueue_resources_absent_mark(me);
}

inline void   
quexProcessed_TokenQueue_remainder_get(quexProcessed_TokenQueue* me,
                                    quexProcessed_Token**      begin,
                                    quexProcessed_Token**      end)
{
    *begin = me->read_iterator;
    *end   = me->write_iterator;
    quexProcessed_TokenQueue_reset(me);
}

inline void 
quexProcessed_TokenQueue_memory_get(quexProcessed_TokenQueue* me,
                                 quexProcessed_Token**      memory,
                                 size_t*                n)
{
    *memory = me->begin;
    *n      = (size_t)(me->end - me->begin);
}

inline bool 
quexProcessed_TokenQueue_is_full(quexProcessed_TokenQueue* me) 
{ return me->write_iterator >= me->end; }

inline bool 
quexProcessed_TokenQueue_is_empty(quexProcessed_TokenQueue* me)
{ return me->read_iterator == me->write_iterator; }

inline void             
quexProcessed_TokenQueue_push(quexProcessed_TokenQueue* me,
                           quexProcessed_token_id_t     Id)
/* Push a token and set only its token identifier.                           */
{

    quexProcessed_TokenQueue_push_core(me, Id);
}

inline void             
quexProcessed_TokenQueue_push_core(quexProcessed_TokenQueue* me,
                                quexProcessed_token_id_t     Id)
{
    if( quexProcessed_TokenQueue_is_full(me) ) {
        me->the_lexer->error_code = E_Error_Token_QueueOverflow;
        return;
    }
    quexProcessed_TokenQueue_assert_before_sending(me);  

       me->write_iterator->_line_n   = me->the_lexer->counter._line_number_at_begin;
     me->write_iterator->_column_n = me->the_lexer->counter._column_number_at_begin;

    me->write_iterator->id = Id;              
    ++(me->write_iterator);       
}


inline bool             
quexProcessed_TokenQueue_push_text(quexProcessed_TokenQueue* me,
                                quexProcessed_token_id_t     Id,
                                quexProcessed_lexatom_t*     BeginP,
                                quexProcessed_lexatom_t*     EndP)
/* Push a token and set its 'text' member.                                    */
{
    bool ownership_transferred_to_token_f = false;
    quexProcessed_TokenQueue_assert_before_sending(me);
    ownership_transferred_to_token_f = quexProcessed_Token_take_text(me->write_iterator, BeginP, EndP);
    quexProcessed_TokenQueue_push(me, Id);
    return ownership_transferred_to_token_f;
}







inline void             
quexProcessed_TokenQueue_push_repeated(quexProcessed_TokenQueue* me,
                                    quexProcessed_token_id_t     Id,
                                    size_t                 RepetitionN)
/* Push a repeated token by 'RepetitionN' times. This is only addmissible for
 * TokenId-s specified in the 'repeated_token' section of the '.qx' file.     */
{
    quexProcessed_TokenQueue_assert_before_sending(me);  
    (void)me; (void)Id; (void)RepetitionN;
    __quex_assert(RepetitionN != 0);        

    __quex_assert((const char*)0 == "Token type does not support token repetition.");
    quexProcessed_TokenQueue_set_token_TERMINATION(me);
}

inline quexProcessed_Token* 
quexProcessed_TokenQueue_pop(quexProcessed_TokenQueue* me)
{
    __quex_assert(quexProcessed_TokenQueue_begin(me) != 0x0);

    if( quexProcessed_TokenQueue_is_empty(me) ) {        
        return (quexProcessed_Token*)0;
    }
    /* Tokens are in queue --> take next token from queue                    */ 
    return me->read_iterator++;
}


inline quexProcessed_Token* quexProcessed_TokenQueue_begin(quexProcessed_TokenQueue* me)
{ return me->begin; }

inline quexProcessed_Token* quexProcessed_TokenQueue_back(quexProcessed_TokenQueue* me)
{ return me->end - 1; }

inline quexProcessed_Token* quexProcessed_TokenQueue_last_token(quexProcessed_TokenQueue* me)
{ return me->write_iterator == me->begin ? (quexProcessed_Token*)0 : &me->write_iterator[-1]; }

inline size_t quexProcessed_TokenQueue_available_n(quexProcessed_TokenQueue* me) 
{ return (size_t)(me->end - me->write_iterator); }

inline void
quexProcessed_TokenQueue_set_token_TERMINATION(quexProcessed_TokenQueue* me) 
/* Reset entire token queue and set the token 'TERMINATION'. This should
 * only be called in case of a detected error.                                */
{
    quexProcessed_TokenQueue_reset(me);

    quexProcessed_TokenQueue_push_text(me, QUEX_TKN_TERMINATION, 
                                    (quexProcessed_lexatom_t*)0, (quexProcessed_lexatom_t*)0);


}

inline bool             
quexProcessed_TokenQueue_assert_before_sending(quexProcessed_TokenQueue* me)
{                                                                              
    if( ! quexProcessed_TokenQueue_assert_after_sending(me) ) {
        return false;
    } 
    /* End of token queue has not been reached.                       */          
    __quex_assert((me)->write_iterator != (me)->end);                             
    /* No token sending after 'TERMINATION'.                          */          
    __quex_assert(   (me)->write_iterator         == (me)->begin                  
                  || (me)->write_iterator[-1].id !=  QUEX_TKN_TERMINATION ); 
    return true;
} 

inline bool             
quexProcessed_TokenQueue_assert_after_sending(quexProcessed_TokenQueue* me)
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



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__TOKEN__TOKEN_QUEUE_I */
