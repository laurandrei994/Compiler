/* -*- C++ -*-   vim: set syntax=cpp: */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__TOKEN__RECEIVING_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__TOKEN__RECEIVING_I

#include "lexical_analysis/lib/definitions"



 struct Calc_lexer_Token_tag*
Calc_lexer_remaining_token_pop(struct Calc_lexer_tag*);

 bool
Calc_lexer_MF_run(struct Calc_lexer_tag* me, 
                  bool                (*callback_on_token)(struct Calc_lexer_Token_tag*),
                  bool                ErrorPrintF)
/* Implements the reception loop relying on user's callback. If 'ErrorPrintF'
 * is 'true' an error message is printed in case of error.
 *
 * RETURNS: true, in case no error occurred.
 *          false, else.                                                      */
{
    struct Calc_lexer_Token_tag* token_p = (struct Calc_lexer_Token_tag*)0;

    /* Reception loop.                                                        */
    do {
        Calc_lexer_MF_receive(me, &token_p);
        if     ( ! token_p ) break;
        else if( ! callback_on_token(token_p) ) break;
    } while( token_p->id !=  TKN_TERMINATION );

    /* Error handling.                                                        */
    if( me->error_code != E_Error_None ) {
        if( ErrorPrintF ) Calc_lexer_MF_print_this(me); 
        return false;
    }
    else {
        return true;
    } 
}

 void
Calc_lexer_MF_receive(struct Calc_lexer_tag* me, struct Calc_lexer_Token_tag** result_pp)
{ 
    *result_pp = Calc_lexer_remaining_token_pop(me);
    if( *result_pp ) return; 

    /* Restart filling the queue from begin                                   */
    Calc_lexer_TokenQueue_reset(&me->_token_queue); /* Use 1st token of queue */

    /* Analyze until there is some content in the queue                       */
    do {
        me->current_analyzer_function(me);

        Calc_lexer_TokenQueue_assert_after_sending(&me->_token_queue);

        if( me->error_code != E_Error_None ) {
            Calc_lexer_TokenQueue_set_token_TERMINATION(&me->_token_queue);
            break;
        }

    } while( Calc_lexer_TokenQueue_is_empty(&me->_token_queue) );
    
    *result_pp = Calc_lexer_TokenQueue_pop(&me->_token_queue);
}

 struct Calc_lexer_Token_tag*
Calc_lexer_receive_from_chunk(struct Calc_lexer_tag*    me, 
                              bool                   EndOfChunkF, 
                              Calc_lexer_token_id_t     StreamTerminatingTokenId)
/* Receives tokens from memory chunks. This function is only to be used by the
 * Feeder and the Gavager adapters.
 * 
 * RETURNS: NULL, requires refill.
 *          Pointer to token, that has been identified 
 *          (This may be the 'BYE' token).                                    */
{
    struct Calc_lexer_Token_tag*       token_p;
    Calc_lexer_lexatom_t*     start_p;
    const struct Calc_lexer_Token_tag* last_token_in_queue_p;

    /* If token queue is not empty => it has been ensured that all tokens are
     * generated well inside the buffer's boundaries.                         */
    token_p = Calc_lexer_remaining_token_pop(me);
    if( token_p ) return token_p;

    /* Restart filling the queue from begin                                   */
    Calc_lexer_TokenQueue_reset(&me->_token_queue); /* Use 1st token of queue */

    /* Token queue is empty. A new step begins. 
     * Backup read position. It may be reset in case of reaching boundaries.  */
    do {
        start_p = me->buffer._read_p;

        me->current_analyzer_function(me);
        Calc_lexer_TokenQueue_assert_after_sending(&me->_token_queue);

        if( me->error_code != E_Error_None ) {
            Calc_lexer_TokenQueue_reset(&me->_token_queue);
            return (struct Calc_lexer_Token_tag*)0; 
        }
    } while( Calc_lexer_TokenQueue_is_empty(&me->_token_queue) );

    if( me->buffer._read_p < me->buffer.content_end(&me->buffer) ) {
        /* Complete token queue is generated without reaching buffer boarders.*/
        return token_p;
    }

    /* Last token ended on the content's border. 
     * Last token id 'stream end' => token queue is ok. 
     * Else                       => must refill and restart from 'start_p'.  */
    last_token_in_queue_p = Calc_lexer_TokenQueue_last_token(&me->_token_queue); 
    __quex_assert(0 != last_token_in_queue_p); /* not empty => last token exists.  */
    if( EndOfChunkF && last_token_in_queue_p->id == StreamTerminatingTokenId ) {
        /* The 'good bye' token may stand very well on the border.            */
        return token_p;                                                       
    }                                                                         
    else {                                                                    
        /* All generated tokens are in doubt.                                 
         * Reset token queue. Restart analysis with more content.             */
        Calc_lexer_TokenQueue_reset(&me->_token_queue);
        me->buffer._read_p = start_p;
        return (struct Calc_lexer_Token_tag*)0; 
    }
}

 struct Calc_lexer_Token_tag*
Calc_lexer_remaining_token_pop(struct Calc_lexer_tag* me)
/* Considers the current 'error_code' and the remaining token queue. If the 
 * current state is 'error', then the complete token queue is deleted and the
 * TERMINATION token is setup. Else, it is tried to take a token which remained
 * in the token queue.
 *
 * RETURNS: Pointer to token, if a token could be found (without analysis).
 *          Null, else.                                                       */
{
    /* Make sure that all remaining tokens are passed to the receiver, before
     * notifying about error.                                                 */
    struct Calc_lexer_Token_tag* token_p = Calc_lexer_TokenQueue_pop(&me->_token_queue);

    if( token_p ) {
        return token_p;
    }
    else if( me->error_code != E_Error_None ) {
        Calc_lexer_TokenQueue_set_token_TERMINATION(&me->_token_queue);
        return Calc_lexer_TokenQueue_pop(&me->_token_queue);
    }
    else {
        return (struct Calc_lexer_Token_tag*)0;
    }
}


#endif
