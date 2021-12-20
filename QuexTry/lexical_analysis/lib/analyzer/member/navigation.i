/* -*- C++ -*- vim: set syntax=cpp:
 * (C) 2005-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY              */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MEMBER__NAVIGATION_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MEMBER__NAVIGATION_I

#include "lexical_analysis/lib/definitions"



 size_t  
Calc_lexer_MF_tell(struct Calc_lexer_tag* me)
{
    /* No 'undo terminating zero' -- we do not change the lexeme pointer here. */
    return (size_t)Calc_lexer_Buffer_tell(&me->buffer);
}

 void    
Calc_lexer_MF_seek(struct Calc_lexer_tag* me, const size_t CharacterIndex)
{
    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    Calc_lexer_Buffer_seek(&me->buffer, (ptrdiff_t)CharacterIndex);
}

 void    
Calc_lexer_MF_seek_forward(struct Calc_lexer_tag* me, const size_t CharacterN)
{
    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    Calc_lexer_Buffer_seek_forward(&me->buffer, (ptrdiff_t)CharacterN);
}

 void    
Calc_lexer_MF_seek_backward(struct Calc_lexer_tag* me, const size_t CharacterN)
{
    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
    Calc_lexer_Buffer_seek_backward(&me->buffer, (ptrdiff_t)CharacterN);
}

 void  
Calc_lexer_MF_undo(struct Calc_lexer_tag* me)
{
       me->counter._line_number_at_end   = me->counter._line_number_at_begin;
     me->counter._column_number_at_end = me->counter._column_number_at_begin;

    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);

    me->buffer._read_p = me->buffer._lexeme_start_p;

    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_SET(&me->buffer);
}

 void  
Calc_lexer_MF_undo_n(struct Calc_lexer_tag* me, size_t DeltaN_Backward)
{
       me->counter._line_number_at_end   = me->counter._line_number_at_begin;
     me->counter._column_number_at_end = me->counter._column_number_at_begin;

    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);

    me->buffer._read_p -= (ptrdiff_t)DeltaN_Backward;

    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_SET(&me->buffer);

    __quex_assert(me->buffer._read_p >= me->buffer._lexeme_start_p);
}



#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MEMBER__NAVIGATION_I */
