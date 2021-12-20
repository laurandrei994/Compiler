/* -*- C++ -*- vim:set syntax=cpp: 
 * (C) Frank-Rene Schaefer    
 * ABSOLUTELY NO WARRANTY                                                     */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__LEXEME__BASICS_I
#define QUEX_INCLUDE_GUARD_quexProcessed__LEXEME__BASICS_I

#include "quexProcessed/lib/quex/standard_functions"
#include "quexProcessed/lib/quex/MemoryManager"



extern quexProcessed_lexatom_t quexProcessed_LexemeNull;

inline size_t 
quexProcessed_lexeme_length(const quexProcessed_lexatom_t* Str)
{
    const quexProcessed_lexatom_t* iterator = Str;
    while( *iterator ) ++iterator; 
    return (size_t)(iterator - Str);
}

inline quexProcessed_lexatom_t*
quexProcessed_lexeme_clone(const quexProcessed_lexatom_t* BeginP,
                        size_t                   Length)
{
    quexProcessed_lexatom_t* result;

    if( ! BeginP || ! *BeginP ) {
        return &quexProcessed_LexemeNull;
    }
    
    result = (quexProcessed_lexatom_t*)quex::MemoryManager_allocate(
                   sizeof(quexProcessed_lexatom_t) * (Length + 1),
                   E_MemoryObjectType_TEXT);

    if( result ) {
        __QUEX_STD_memcpy((void*)result, (void*)BeginP, 
                          sizeof(quexProcessed_lexatom_t) * (Length + 1));
    }
    else {
        result = &quexProcessed_LexemeNull; 
    }
    return result;
}

inline size_t 
quexProcessed_lexeme_compare(const quexProcessed_lexatom_t* it0, 
                          const quexProcessed_lexatom_t* it1)
{
    for(; *it0 == *it1; ++it0, ++it1) {
        /* Both letters are the same and == 0?
         * => both reach terminall zero without being different.              */
        if( *it0 == 0 ) return 0;
    }
    return (size_t)(*it0) - (size_t)(*it1);
}



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__LEXEME_BASICS_I */
