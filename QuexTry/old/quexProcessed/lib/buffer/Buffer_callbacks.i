/* vim:set ft=c: -*- C++ -*- */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFER_CALLBACKS_I
#define QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFER_CALLBACKS_I

#include "quexProcessed/lib/buffer/Buffer"



inline void  
quexProcessed_Buffer_callbacks_set(quexProcessed_Buffer* me,
                                     void   (*on_before_change)(void* aux),
                                     void   (*on_overflow)(void*  aux),
                                     void*  aux)
{
    me->event.on_buffer_before_change = on_before_change;
    me->event.on_buffer_overflow      = on_overflow;
    me->event.aux                     = aux;
}

inline void
quexProcessed_Buffer_callbacks_on_buffer_before_change(quexProcessed_Buffer* me)
{
#   ifdef QUEX_OPTION_ASSERTS
    quexProcessed_BufferInvariance bi;
    quexProcessed_BUFFER_ASSERT_INVARIANCE_SETUP(&bi, me);
#   endif

    if( me->_backup_lexatom_index_of_lexeme_start_p != (quexProcessed_stream_position_t)-1 ) {
        /* Callbacks must have been called bedore the lexeme start position has
         * been back-uped. No pointer positions inside the buffer are referred
         * to by the user while lexeme start is not present inside the buffer.*/
    }
    else if( me->event.on_buffer_before_change ) {
        me->event.on_buffer_before_change(me->event.aux); 
    }

#   ifdef QUEX_OPTION_ASSERTS
    quexProcessed_BUFFER_ASSERT_INVARIANCE_VERIFY_SAME(&bi, me);
#   endif
}

inline void
quexProcessed_Buffer_callbacks_on_buffer_overflow(quexProcessed_Buffer* me)
{
#   ifdef QUEX_OPTION_ASSERTS
    quexProcessed_BufferInvariance bi;
    quexProcessed_BUFFER_ASSERT_INVARIANCE_SETUP(&bi, me);
#   endif

    if( me->event.on_buffer_overflow ) {
        me->event.on_buffer_overflow(me->event.aux);
    }

#   ifdef QUEX_OPTION_ASSERTS
    quexProcessed_BUFFER_ASSERT_INVARIANCE_VERIFY(&bi, me);
#   endif
}

inline bool
quexProcessed_Buffer_callbacks_on_cannot_move_towards_begin(quexProcessed_Buffer*  me, 
                                                         ptrdiff_t*          move_distance)
/* Calls the 'on_buffer_oveflow' callback where new buffer memory may be 
 * provided and checks whether memory is then sufficient.
 *
 * RETURNS: true, if space for reload could be provided.
 *          false, else.                                                      */
{
    if(    me->content_end(me) <  me->content_space_end(me) 
        || me->content_end(me) != me->_read_p ) {
        return true;
    }

    /* No free space can be provided for loading new content. 
     * The lexeme spans complete buffer.                                      */
    quexProcessed_Buffer_callbacks_on_buffer_overflow(me);

    if( me->content_end(me) < &me->content_space_end(me)[-1] ) {
        return true;                                          /* Fair enough! */
    }

    /* 'on_buffer_overflow' may have extended the buffer's memory.
     * => second chance!                                                      */
    *move_distance = quexProcessed_Buffer_move_get_max_distance_towards_begin(me);
    return 0 != *move_distance;
}




#endif /* QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFER_CALLBACKS_I */
