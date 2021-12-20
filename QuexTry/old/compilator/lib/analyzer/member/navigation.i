/* -*- C++ -*- vim: set syntax=cpp:
 * (C) 2005-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY              */
#ifndef QUEX_INCLUDE_GUARD_compilator__ANALYZER__MEMBER__NAVIGATION_I
#define QUEX_INCLUDE_GUARD_compilator__ANALYZER__MEMBER__NAVIGATION_I

#include "compilator\lib\definitions"



inline size_t  
compilator_MF_tell(compilator* me)
{
    /* No 'undo terminating zero' -- we do not change the lexeme pointer here. */
    return (size_t)compilator_Buffer_tell(&me->buffer);
}

inline void    
compilator_MF_seek(compilator* me, const size_t CharacterIndex)
{
    QUEX_compilator_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    compilator_Buffer_seek(&me->buffer, (ptrdiff_t)CharacterIndex);
}

inline void    
compilator_MF_seek_forward(compilator* me, const size_t CharacterN)
{
    QUEX_compilator_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    compilator_Buffer_seek_forward(&me->buffer, (ptrdiff_t)CharacterN);
}

inline void    
compilator_MF_seek_backward(compilator* me, const size_t CharacterN)
{
    QUEX_compilator_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    compilator_Buffer_seek_backward(&me->buffer, (ptrdiff_t)CharacterN);
}

inline void  
compilator_MF_undo(compilator* me)
{
       me->counter._line_number_at_end   = me->counter._line_number_at_begin;
     me->counter._column_number_at_end = me->counter._column_number_at_begin;

    QUEX_compilator_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);

    me->buffer._read_p = me->buffer._lexeme_start_p;

    QUEX_compilator_LEXEME_TERMINATING_ZERO_SET(&me->buffer);
}

inline void  
compilator_MF_undo_n(compilator* me, size_t DeltaN_Backward)
{
       me->counter._line_number_at_end   = me->counter._line_number_at_begin;
     me->counter._column_number_at_end = me->counter._column_number_at_begin;

    QUEX_compilator_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);

    me->buffer._read_p -= (ptrdiff_t)DeltaN_Backward;

    QUEX_compilator_LEXEME_TERMINATING_ZERO_SET(&me->buffer);

    __quex_assert(me->buffer._read_p >= me->buffer._lexeme_start_p);
}



#endif /* QUEX_INCLUDE_GUARD_compilator__ANALYZER__MEMBER__NAVIGATION_I */
