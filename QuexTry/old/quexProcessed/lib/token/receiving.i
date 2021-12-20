/* -*- C++ -*-   vim: set syntax=cpp: */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__TOKEN__RECEIVING_I
#define QUEX_INCLUDE_GUARD_quexProcessed__TOKEN__RECEIVING_I

#include "quexProcessed/lib/definitions"



inline quexProcessed_Token*
quexProcessed_remaining_token_pop(quexProcessed*);

inline bool
quexProcessed_MF_run(quexProcessed* me, 
                  bool                (*callback_on_token)(quexProcessed_Token*),
                  bool                ErrorPrintF)
/* Implements the reception loop relying on user's callback. If 'ErrorPrintF'
 * is 'true' an error message is printed in case of error.
 *
 * RETURNS: true, in case no error occurred.
 *          false, else.                                                      */
{
    quexProcessed_Token* token_p = (quexProcessed_Token*)0;

    /* Reception loop.                                                        */
    do {
        quexProcessed_MF_receive(me, &token_p);
        if     ( ! token_p ) break;
        else if( ! callback_on_token(token_p) ) break;
    } while( token_p->id !=  QUEX_TKN_TERMINATION );

    /* Error handling.                                                        */
    if( me->error_code != E_Error_None ) {
        if( ErrorPrintF ) quexProcessed_MF_print_this(me); 
        return false;
    }
    else {
        return true;
    } 
}

inline void
quexProcessed_MF_receive(quexProcessed* me, quexProcessed_Token** result_pp)
{ 
    *result_pp = quexProcessed_remaining_token_pop(me);
    if( *result_pp ) return; 

    /* Restart filling the queue from begin                                   */
    quexProcessed_TokenQueue_reset(&me->_token_queue); /* Use 1st token of queue */

    /* Analyze until there is some content in the queue                       */
    do {
        me->current_analyzer_function(me);

        quexProcessed_TokenQueue_assert_after_sending(&me->_token_queue);

        if( me->error_code != E_Error_None ) {
            quexProcessed_TokenQueue_set_token_TERMINATION(&me->_token_queue);
            break;
        }

    } while( quexProcessed_TokenQueue_is_empty(&me->_token_queue) );
    
    *result_pp = quexProcessed_TokenQueue_pop(&me->_token_queue);
}

inline quexProcessed_Token*
quexProcessed_receive_from_chunk(quexProcessed*    me, 
                              bool                   EndOfChunkF, 
                              quexProcessed_token_id_t     StreamTerminatingTokenId)
/* Receives tokens from memory chunks. This function is only to be used by the
 * Feeder and the Gavager adapters.
 * 
 * RETURNS: NULL, requires refill.
 *          Pointer to token, that has been identified 
 *          (This may be the 'BYE' token).                                    */
{
    quexProcessed_Token*       token_p;
    quexProcessed_lexatom_t*     start_p;
    const quexProcessed_Token* last_token_in_queue_p;

    /* If token queue is not empty => it has been ensured that all tokens are
     * generated well inside the buffer's boundaries.                         */
    token_p = quexProcessed_remaining_token_pop(me);
    if( token_p ) return token_p;

    /* Restart filling the queue from begin                                   */
    quexProcessed_TokenQueue_reset(&me->_token_queue); /* Use 1st token of queue */

    /* Token queue is empty. A new step begins. 
     * Backup read position. It may be reset in case of reaching boundaries.  */
    do {
        start_p = me->buffer._read_p;

        me->current_analyzer_function(me);
        quexProcessed_TokenQueue_assert_after_sending(&me->_token_queue);

        if( me->error_code != E_Error_None ) {
            quexProcessed_TokenQueue_reset(&me->_token_queue);
            return (quexProcessed_Token*)0; 
        }
    } while( quexProcessed_TokenQueue_is_empty(&me->_token_queue) );

    if( me->buffer._read_p < me->buffer.content_end(&me->buffer) ) {
        /* Complete token queue is generated without reaching buffer boarders.*/
        return token_p;
    }

    /* Last token ended on the content's border. 
     * Last token id 'stream end' => token queue is ok. 
     * Else                       => must refill and restart from 'start_p'.  */
    last_token_in_queue_p = quexProcessed_TokenQueue_last_token(&me->_token_queue); 
    __quex_assert(0 != last_token_in_queue_p); /* not empty => last token exists.  */
    if( EndOfChunkF && last_token_in_queue_p->id == StreamTerminatingTokenId ) {
        /* The 'good bye' token may stand very well on the border.            */
        return token_p;                                                       
    }                                                                         
    else {                                                                    
        /* All generated tokens are in doubt.                                 
         * Reset token queue. Restart analysis with more content.             */
        quexProcessed_TokenQueue_reset(&me->_token_queue);
        me->buffer._read_p = start_p;
        return (quexProcessed_Token*)0; 
    }
}

inline quexProcessed_Token*
quexProcessed_remaining_token_pop(quexProcessed* me)
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
    quexProcessed_Token* token_p = quexProcessed_TokenQueue_pop(&me->_token_queue);

    if( token_p ) {
        return token_p;
    }
    else if( me->error_code != E_Error_None ) {
        quexProcessed_TokenQueue_set_token_TERMINATION(&me->_token_queue);
        return quexProcessed_TokenQueue_pop(&me->_token_queue);
    }
    else {
        return (quexProcessed_Token*)0;
    }
}


#endif
