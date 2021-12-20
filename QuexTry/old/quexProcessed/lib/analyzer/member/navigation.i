/* -*- C++ -*- vim: set syntax=cpp:
 * (C) 2005-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY              */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__NAVIGATION_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__NAVIGATION_I

#include "quexProcessed/lib/definitions"



inline size_t  
quexProcessed_MF_tell(quexProcessed* me)
{
    /* No 'undo terminating zero' -- we do not change the lexeme pointer here. */
    return (size_t)quexProcessed_Buffer_tell(&me->buffer);
}

inline void    
quexProcessed_MF_seek(quexProcessed* me, const size_t CharacterIndex)
{
    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    quexProcessed_Buffer_seek(&me->buffer, (ptrdiff_t)CharacterIndex);
}

inline void    
quexProcessed_MF_seek_forward(quexProcessed* me, const size_t CharacterN)
{
    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    quexProcessed_Buffer_seek_forward(&me->buffer, (ptrdiff_t)CharacterN);
}

inline void    
quexProcessed_MF_seek_backward(quexProcessed* me, const size_t CharacterN)
{
    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    quexProcessed_Buffer_seek_backward(&me->buffer, (ptrdiff_t)CharacterN);
}

inline void  
quexProcessed_MF_undo(quexProcessed* me)
{
       me->counter._line_number_at_end   = me->counter._line_number_at_begin;
     me->counter._column_number_at_end = me->counter._column_number_at_begin;

    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);

    me->buffer._read_p = me->buffer._lexeme_start_p;

    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_SET(&me->buffer);
}

inline void  
quexProcessed_MF_undo_n(quexProcessed* me, size_t DeltaN_Backward)
{
       me->counter._line_number_at_end   = me->counter._line_number_at_begin;
     me->counter._column_number_at_end = me->counter._column_number_at_begin;

    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);

    me->buffer._read_p -= (ptrdiff_t)DeltaN_Backward;

    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_SET(&me->buffer);

    __quex_assert(me->buffer._read_p >= me->buffer._lexeme_start_p);
}



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__NAVIGATION_I */
