/* vim:set ft=c: -*- C++ -*- */
#ifndef QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_INVARIANCE_I
#define QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_INVARIANCE_I



inline void
compilator_BufferInvariance_construct(compilator_BufferInvariance* me, 
                                      compilator_Buffer*           subject)
/* Store all buffer related pointers and indicates present in 'subject'.      */
{
    compilator_Buffer_assert_pointers_in_range(subject);

    me->front_p             = subject->begin(subject);
    me->back_p              = subject->content_space_end(subject);
    me->end_p               = subject->content_end(subject);
    me->read_p              = subject->_read_p;
    me->lexeme_start_p      = subject->_lexeme_start_p;
    me->lexatom_index_begin = subject->input.lexatom_index_begin;
}

inline void
compilator_BufferInvariance_assert(compilator_BufferInvariance* me, 
                                   compilator_Buffer*           subject,
                                   bool                         SameF)
/* Assert that pointers and indices in 'me' and 'subject' are equivalent or
 * the same. When 'SameF' is true, equivalents is required.
 *
 * ASSERTS: see above.                                                        */
{
    (void)me; (void)subject; (void)SameF;
    if( SameF ) {
        __quex_assert(me->front_p             == subject->begin(subject));
        __quex_assert(me->back_p              == subject->content_space_end(subject));
        __quex_assert(me->end_p               == subject->content_end(subject));
        __quex_assert(me->lexatom_index_begin == subject->input.lexatom_index_begin);
    }

    /* Dislocation of '_read_p' same as the dislocation of '_lexeme_start_p'. */
    __quex_assert(me->read_p - subject->_read_p == me->lexeme_start_p - subject->_lexeme_start_p);
}

inline void
compilator_BufferInvariance_restore(compilator_BufferInvariance* me, 
                                    compilator_Buffer*           subject)
/* Restores all pointers and indices relevant for a buffer from 'me' into 
 * 'subject'.                                                                 */
{
    subject->_memory._front            = me->front_p;
    subject->_memory._back             = me->back_p;
    subject->input.end_p               = me->end_p;
    subject->_read_p                   = me->read_p;
    subject->_lexeme_start_p           = me->lexeme_start_p;
    subject->input.lexatom_index_begin = me->lexatom_index_begin;
}



#endif /* QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_INVARIANCE_I */
