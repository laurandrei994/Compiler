/* -*- C++ -*- vim: set syntax=cpp: */
#ifndef QUEX_INCLUDE_GUARD_compilator__BUFFER__ASSERTS_I
#define QUEX_INCLUDE_GUARD_compilator__BUFFER__ASSERTS_I

#include "compilator\lib\buffer/asserts"
#include "compilator\lib\buffer/Buffer"

#if defined(QUEX_OPTION_ASSERTS)



inline void
compilator_BUFFER_ASSERT_INVARIANCE_SETUP(compilator_BufferInvariance* bi, 
                                          compilator_Buffer*           me)
{
    compilator_BufferInvariance_construct(bi, me);
    compilator_Buffer_assert_consistency(me);
}

inline void
compilator_BUFFER_ASSERT_INVARIANCE_VERIFY(compilator_BufferInvariance* bi, 
                                           compilator_Buffer*           me)     
{
    compilator_Buffer_assert_consistency(me);                   
    compilator_BufferInvariance_assert(bi, me, false);
}

inline void
compilator_BUFFER_ASSERT_INVARIANCE_VERIFY_SAME(compilator_BufferInvariance* bi, 
                                                compilator_Buffer*           me)     
{
    compilator_Buffer_assert_consistency(me);                   
    compilator_BufferInvariance_assert(bi, me, true);
}


inline void
compilator_Buffer_assert_pointers_in_range(const compilator_Buffer* B)                                      
/* Check whether _read_p and _lexeme_start_p are in ther appropriate range. */
{                                                                                    
    __quex_assert( (B) != 0x0 );                                                     
    if( ! (*B)._memory._front && ! (*B)._memory._back ) {                    
        return;
    }

    __quex_assert((*B).begin(B)        <  (*B).content_space_end(B));                     
    __quex_assert((*B).content_end(B)  >= (*B).content_begin(B));          
    __quex_assert((*B).content_end(B)  <= (*B).content_space_end(B));               

    __quex_assert((*B)._read_p         >= (*B).begin(B));                
    __quex_assert((*B)._read_p         <= (*B).content_end(B));              
    __quex_assert((*B)._lexeme_start_p >= (*B).begin(B));                
    __quex_assert((*B)._lexeme_start_p <= (*B).content_end(B));              
}

inline void
compilator_Buffer_assert_limit_codes_in_place(const compilator_Buffer* B)                                            
{
    if( ! (*B)._memory._front && ! (*B)._memory._back ) {                    
        return;
    }
    __quex_assert((*B).begin(B)[0]              == QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);    
    __quex_assert((*B).content_space_end(B)[0]  == QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);    
    __quex_assert((*B).content_end(B)[0]        == QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);   
}

inline void
compilator_Buffer_assert_consistency(const compilator_Buffer* B)                                            
{                                                                                    
    const compilator_Buffer* focus;
    if( ! B ) return;
    __quex_assert(   B->input.lexatom_index_begin == -1
                  || B->input.lexatom_index_begin >= 0);
    __quex_assert(   B->input.lexatom_index_end_of_stream == -1 
                  || B->input.lexatom_index_end_of_stream >= B->input.lexatom_index_begin);
    compilator_Buffer_assert_pointers_in_range(B);                                              
    compilator_Buffer_assert_limit_codes_in_place(B);

    if( B->_memory.ownership == E_Ownership_INCLUDING_BUFFER ) {
        __quex_assert(0 != B->_memory.including_buffer);
        /* No cyclic nesting of buffers.                                      */
        for(focus = B; 0 != focus->_memory.including_buffer; ) { 
            __quex_assert(focus->_memory.ownership == E_Ownership_INCLUDING_BUFFER);
            focus = focus->_memory.including_buffer;
            __quex_assert(focus != B);
        }
        /* NOT:
         *     __quex_assert(&including_buffer->_memory._back[1] == &front[0]);
         * BECAUSE: (1) Pointer adaption happens from back to front.
         *              => consistency could not be checked during adaption.
         *          (2) Future versions may store more in the buffer region.  */
    }
    else {
        __quex_assert(0 == B->_memory.including_buffer);
    }
    compilator_Buffer_member_functions_assert(B);
}

inline void
compilator_Buffer_member_functions_assert(const compilator_Buffer* me)
{
    __quex_assert(me->fill                == compilator_Buffer_fill);
    __quex_assert(me->fill_prepare        == compilator_Buffer_fill_prepare);
    __quex_assert(me->fill_finish         == compilator_Buffer_fill_finish);

    __quex_assert(me->begin               == compilator_Buffer_memory_begin);
    __quex_assert(me->end                 == compilator_Buffer_memory_end);
    __quex_assert(me->size                == compilator_Buffer_memory_size);

    __quex_assert(me->content_space_end   == compilator_Buffer_memory_content_space_end);
    __quex_assert(me->content_space_size  == compilator_Buffer_memory_content_space_size);

    __quex_assert(me->content_begin       == compilator_Buffer_memory_content_begin);
    __quex_assert(me->content_end         == compilator_Buffer_memory_content_end);
    __quex_assert(me->content_size        == compilator_Buffer_memory_content_size);
}

inline void
compilator_Buffer_assert_no_lexatom_is_buffer_border(const compilator_lexatom_t* Begin, 
                                                     const compilator_lexatom_t* End)
{
    const compilator_lexatom_t* iterator = 0x0;
    __quex_assert(Begin <= End);

    for(iterator = Begin; iterator != End; ++iterator) {
        if( *iterator != QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER ) continue;

        if( iterator == Begin ) {
            QUEX_ERROR_EXIT("Buffer limit code character appeared as first character in buffer.\n"
                            "This is most probably a load failure.\n");
        } else {
            QUEX_ERROR_EXIT("Buffer limit code character appeared as normal text content.\n");
        }
    }
}



#endif

#endif /* QUEX_INCLUDE_GUARD_compilator__BUFFER__ASSERTS_I */

