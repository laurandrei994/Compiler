/* -*- C++ -*- vim:set syntax=cpp: 
 * (C) Frank-Rene Schaefer    
 * ABSOLUTELY NO WARRANTY                                                     */
#ifndef QUEX_INCLUDE_GUARD_compilator__LEXEME__BASICS_I
#define QUEX_INCLUDE_GUARD_compilator__LEXEME__BASICS_I

#include "compilator\lib\quex/standard_functions"
#include "compilator\lib\quex/MemoryManager"



extern compilator_lexatom_t compilator_LexemeNull;

inline size_t 
compilator_lexeme_length(const compilator_lexatom_t* Str)
{
    const compilator_lexatom_t* iterator = Str;
    while( *iterator ) ++iterator; 
    return (size_t)(iterator - Str);
}

inline compilator_lexatom_t*
compilator_lexeme_clone(const compilator_lexatom_t* BeginP,
                        size_t                   Length)
{
    compilator_lexatom_t* result;

    if( ! BeginP || ! *BeginP ) {
        return &compilator_LexemeNull;
    }
    
    result = (compilator_lexatom_t*)quex::MemoryManager_allocate(
                   sizeof(compilator_lexatom_t) * (Length + 1),
                   E_MemoryObjectType_TEXT);

    if( result ) {
        __QUEX_STD_memcpy((void*)result, (void*)BeginP, 
                          sizeof(compilator_lexatom_t) * (Length + 1));
    }
    else {
        result = &compilator_LexemeNull; 
    }
    return result;
}

inline size_t 
compilator_lexeme_compare(const compilator_lexatom_t* it0, 
                          const compilator_lexatom_t* it1)
{
    for(; *it0 == *it1; ++it0, ++it1) {
        /* Both letters are the same and == 0?
         * => both reach terminall zero without being different.              */
        if( *it0 == 0 ) return 0;
    }
    return (size_t)(*it0) - (size_t)(*it1);
}



#endif /* QUEX_INCLUDE_GUARD_compilator__LEXEME_BASICS_I */
