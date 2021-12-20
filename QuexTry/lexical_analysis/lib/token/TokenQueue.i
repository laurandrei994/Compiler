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
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__TOKEN__TOKEN_QUEUE_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__TOKEN__TOKEN_QUEUE_I

#include "lexical_analysis/lib/definitions"
#include "lexical_analysis/lib/quex/asserts"
#include "lexical_analysis/lib/quex/MemoryManager"

/* NOTE: struct Calc_lexer_Token_tag must be defined at this place!                       */

#include "lexical_analysis/lib/token/TokenQueue"



 void             
Calc_lexer_TokenQueue_push_core(Calc_lexer_TokenQueue* me, Calc_lexer_token_id_t Id);

 bool
Calc_lexer_TokenQueue_construct(Calc_lexer_TokenQueue* me, 
                                struct Calc_lexer_tag*    lexer,
                                const size_t           N)
/* me:     The token queue.
 * Memory: Pointer to memory of token queue, 0x0 --> no initial memory.
 * N:      Number of token objects that the array can carry.                  */
{
    struct Calc_lexer_Token_tag*   iterator   = 0x0;
    struct Calc_lexer_Token_tag*   memory     = (struct Calc_lexer_Token_tag*)quex_MemoryManager_allocate(
                                             N * sizeof(struct Calc_lexer_Token_tag),
                                             E_MemoryObjectType_TOKEN_ARRAY);
    struct Calc_lexer_Token_tag*   memory_end = &memory[N];

    if( ! memory ) {
        Calc_lexer_TokenQueue_resources_absent_mark(me);
        return false;
    }

    __quex_assert(memory != 0x0);

    /* Call placement new (plain constructor) for all tokens in chunk.        */
    for(iterator = memory; iterator != memory_end; ++iterator) {
        Calc_lexer_Token_construct(iterator);
    }
    Calc_lexer_TokenQueue_init(me, memory, memory_end); 
    me->the_lexer = lexer;
    return true;
}

 void
Calc_lexer_TokenQueue_reset(Calc_lexer_TokenQueue* me) 
{                                                    
    me->read_iterator  = (struct Calc_lexer_Token_tag*)me->begin; 
    me->write_iterator = (struct Calc_lexer_Token_tag*)me->begin; 
}

 void
Calc_lexer_TokenQueue_init(Calc_lexer_TokenQueue* me, 
                           struct Calc_lexer_Token_tag*       Memory, 
                           struct Calc_lexer_Token_tag*       MemoryEnd) 
{
    me->begin = Memory;                           
    me->end   = MemoryEnd;                        
    Calc_lexer_TokenQueue_reset(me);                                
}

 void
Calc_lexer_TokenQueue_resources_absent_mark(Calc_lexer_TokenQueue* me) 
{
    me->begin          = (struct Calc_lexer_Token_tag*)0;                           
    me->end            = (struct Calc_lexer_Token_tag*)0;
    me->read_iterator  = (struct Calc_lexer_Token_tag*)0; 
    me->write_iterator = (struct Calc_lexer_Token_tag*)0; 
    me->the_lexer      = (struct Calc_lexer_tag*)0; 
}

 bool
Calc_lexer_TokenQueue_resources_absent(Calc_lexer_TokenQueue* me) 
{
    return    me->begin          == (struct Calc_lexer_Token_tag*)0                           
           && me->end            == (struct Calc_lexer_Token_tag*)0
           && me->read_iterator  == (struct Calc_lexer_Token_tag*)0 
           && me->write_iterator == (struct Calc_lexer_Token_tag*)0
           && me->the_lexer      == (struct Calc_lexer_tag*)0;
}

 void
Calc_lexer_TokenQueue_destruct(Calc_lexer_TokenQueue* me)
{
    struct Calc_lexer_Token_tag* iterator = 0x0;
    /* Call explicit destructors for all tokens in array                      */
    for(iterator = me->begin; iterator != me->end; ++iterator) {
        Calc_lexer_Token_destruct(iterator);
    }

    quex_MemoryManager_free((void*)&me->begin[0],
                               E_MemoryObjectType_TOKEN_ARRAY);

    /* The memory chunk for the token queue itself is located inside the
     * analyzer object. Thus, no explicit free is necessary. In case of user
     * managed token queue memory the user takes care of the deletion.        */
    Calc_lexer_TokenQueue_resources_absent_mark(me);
}

 void   
Calc_lexer_TokenQueue_remainder_get(Calc_lexer_TokenQueue* me,
                                    struct Calc_lexer_Token_tag**      begin,
                                    struct Calc_lexer_Token_tag**      end)
{
    *begin = me->read_iterator;
    *end   = me->write_iterator;
    Calc_lexer_TokenQueue_reset(me);
}

 void 
Calc_lexer_TokenQueue_memory_get(Calc_lexer_TokenQueue* me,
                                 struct Calc_lexer_Token_tag**      memory,
                                 size_t*                n)
{
    *memory = me->begin;
    *n      = (size_t)(me->end - me->begin);
}

 bool 
Calc_lexer_TokenQueue_is_full(Calc_lexer_TokenQueue* me) 
{ return me->write_iterator >= me->end; }

 bool 
Calc_lexer_TokenQueue_is_empty(Calc_lexer_TokenQueue* me)
{ return me->read_iterator == me->write_iterator; }

 void             
Calc_lexer_TokenQueue_push(Calc_lexer_TokenQueue* me,
                           Calc_lexer_token_id_t     Id)
/* Push a token and set only its token identifier.                           */
{

    Calc_lexer_TokenQueue_push_core(me, Id);
}

 void             
Calc_lexer_TokenQueue_push_core(Calc_lexer_TokenQueue* me,
                                Calc_lexer_token_id_t     Id)
{
    if( Calc_lexer_TokenQueue_is_full(me) ) {
        me->the_lexer->error_code = E_Error_Token_QueueOverflow;
        return;
    }
    Calc_lexer_TokenQueue_assert_before_sending(me);  

       me->write_iterator->_line_n   = me->the_lexer->counter._line_number_at_begin;
     me->write_iterator->_column_n = me->the_lexer->counter._column_number_at_begin;

    me->write_iterator->id = Id;              
    ++(me->write_iterator);       
}


 bool             
Calc_lexer_TokenQueue_push_text(Calc_lexer_TokenQueue* me,
                                Calc_lexer_token_id_t     Id,
                                Calc_lexer_lexatom_t*     BeginP,
                                Calc_lexer_lexatom_t*     EndP)
/* Push a token and set its 'text' member.                                    */
{
    bool ownership_transferred_to_token_f = false;
    Calc_lexer_TokenQueue_assert_before_sending(me);
    ownership_transferred_to_token_f = Calc_lexer_Token_take_text(me->write_iterator, BeginP, EndP);
    Calc_lexer_TokenQueue_push(me, Id);
    return ownership_transferred_to_token_f;
}







 void             
Calc_lexer_TokenQueue_push_repeated(Calc_lexer_TokenQueue* me,
                                    Calc_lexer_token_id_t     Id,
                                    size_t                 RepetitionN)
/* Push a repeated token by 'RepetitionN' times. This is only addmissible for
 * TokenId-s specified in the 'repeated_token' section of the '.qx' file.     */
{
    Calc_lexer_TokenQueue_assert_before_sending(me);  
    (void)me; (void)Id; (void)RepetitionN;
    __quex_assert(RepetitionN != 0);        

    __quex_assert((const char*)0 == "Token type does not support token repetition.");
    Calc_lexer_TokenQueue_set_token_TERMINATION(me);
}

 struct Calc_lexer_Token_tag* 
Calc_lexer_TokenQueue_pop(Calc_lexer_TokenQueue* me)
{
    __quex_assert(Calc_lexer_TokenQueue_begin(me) != 0x0);

    if( Calc_lexer_TokenQueue_is_empty(me) ) {        
        return (struct Calc_lexer_Token_tag*)0;
    }
    /* Tokens are in queue --> take next token from queue                    */ 
    return me->read_iterator++;
}


 struct Calc_lexer_Token_tag* Calc_lexer_TokenQueue_begin(Calc_lexer_TokenQueue* me)
{ return me->begin; }

 struct Calc_lexer_Token_tag* Calc_lexer_TokenQueue_back(Calc_lexer_TokenQueue* me)
{ return me->end - 1; }

 struct Calc_lexer_Token_tag* Calc_lexer_TokenQueue_last_token(Calc_lexer_TokenQueue* me)
{ return me->write_iterator == me->begin ? (struct Calc_lexer_Token_tag*)0 : &me->write_iterator[-1]; }

 size_t Calc_lexer_TokenQueue_available_n(Calc_lexer_TokenQueue* me) 
{ return (size_t)(me->end - me->write_iterator); }

 void
Calc_lexer_TokenQueue_set_token_TERMINATION(Calc_lexer_TokenQueue* me) 
/* Reset entire token queue and set the token 'TERMINATION'. This should
 * only be called in case of a detected error.                                */
{
    Calc_lexer_TokenQueue_reset(me);

    Calc_lexer_TokenQueue_push_text(me, TKN_TERMINATION, 
                                    (Calc_lexer_lexatom_t*)0, (Calc_lexer_lexatom_t*)0);


}

 bool             
Calc_lexer_TokenQueue_assert_before_sending(Calc_lexer_TokenQueue* me)
{                                                                              
    if( ! Calc_lexer_TokenQueue_assert_after_sending(me) ) {
        return false;
    } 
    /* End of token queue has not been reached.                       */          
    __quex_assert((me)->write_iterator != (me)->end);                             
    /* No token sending after 'TERMINATION'.                          */          
    __quex_assert(   (me)->write_iterator         == (me)->begin                  
                  || (me)->write_iterator[-1].id !=  TKN_TERMINATION ); 
    return true;
} 

 bool             
Calc_lexer_TokenQueue_assert_after_sending(Calc_lexer_TokenQueue* me)
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



#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__TOKEN__TOKEN_QUEUE_I */
