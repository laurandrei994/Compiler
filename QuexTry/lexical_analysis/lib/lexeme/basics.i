/* -*- C++ -*- vim:set syntax=cpp: 
 * (C) Frank-Rene Schaefer    
 * ABSOLUTELY NO WARRANTY                                                     */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__LEXEME__BASICS_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__LEXEME__BASICS_I

#include "lexical_analysis/lib/quex/standard_functions"
#include "lexical_analysis/lib/quex/MemoryManager"



extern Calc_lexer_lexatom_t Calc_lexer_LexemeNull;

 size_t 
Calc_lexer_lexeme_length(const Calc_lexer_lexatom_t* Str)
{
    const Calc_lexer_lexatom_t* iterator = Str;
    while( *iterator ) ++iterator; 
    return (size_t)(iterator - Str);
}

 Calc_lexer_lexatom_t*
Calc_lexer_lexeme_clone(const Calc_lexer_lexatom_t* BeginP,
                        size_t                   Length)
{
    Calc_lexer_lexatom_t* result;

    if( ! BeginP || ! *BeginP ) {
        return &Calc_lexer_LexemeNull;
    }
    
    result = (Calc_lexer_lexatom_t*)quex_MemoryManager_allocate(
                   sizeof(Calc_lexer_lexatom_t) * (Length + 1),
                   E_MemoryObjectType_TEXT);

    if( result ) {
        __QUEX_STD_memcpy((void*)result, (void*)BeginP, 
                          sizeof(Calc_lexer_lexatom_t) * (Length + 1));
    }
    else {
        result = &Calc_lexer_LexemeNull; 
    }
    return result;
}

 size_t 
Calc_lexer_lexeme_compare(const Calc_lexer_lexatom_t* it0, 
                          const Calc_lexer_lexatom_t* it1)
{
    for(; *it0 == *it1; ++it0, ++it1) {
        /* Both letters are the same and == 0?
         * => both reach terminall zero without being different.              */
        if( *it0 == 0 ) return 0;
    }
    return (size_t)(*it0) - (size_t)(*it1);
}



#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__LEXEME_BASICS_I */
