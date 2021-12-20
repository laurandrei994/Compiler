/* -*- C++ -*-  vim: set syntax=cpp:
 *
 * (C) 2008 Frank-Rene Schaefer */
#ifndef QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_PRINT_I
#define QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_PRINT_I

#include "compilator\lib\definitions"
#include "compilator\lib\buffer/Buffer"
#include "compilator\lib\buffer/lexatoms/LexatomLoader"
#include "compilator\lib\buffer/asserts"
#include "compilator\lib\buffer/asserts.i"
#include "compilator\lib\buffer/Buffer_print"
#include "compilator\lib\lexeme/converter-from-lexeme"



inline void  
compilator_Buffer_print_content_detailed_lines(compilator_lexatom_t** iterator, 
                                               compilator_lexatom_t*  Begin, 
                                               compilator_lexatom_t*  TotalEnd, 
                                               compilator_Buffer*  buffer);

inline void  
compilator_Buffer_print_content(compilator_Buffer* me)
{
    compilator_Buffer_print_content_core(sizeof(compilator_lexatom_t),
                                         (const uint8_t*)me->begin(me),
                                         (const uint8_t*)me->content_space_end(me), 
                                         (const uint8_t*)me->_read_p, 
                                         (const uint8_t*)me->content_end(me),
                                         /* BordersF */ true);

}

inline void  
compilator_Buffer_print_content_detailed(compilator_Buffer* me) 
{
    /* Assumptions: 
     *    (1) width of terminal     = 80 chars
     *    (2) border right and left = 3 chars
     *    (3) display at least the last 5 chars at the begin of buffer.
     *                                  5 chars around input_p.
     *                                  5 chars from lexeme_start.
     *                                  5 chars to the end of buffer.
     *
     *    |12345 ...      12345  ....       12345      ....    12345|
     *    Begin           lexeme start        input_p               buffer end     */ 
    compilator_lexatom_t*  iterator  = me->begin(me);
    compilator_lexatom_t*  total_end = me->end(me); 
    __quex_assert(me != 0x0);

    if( compilator_Buffer_resources_absent(me) ) {
        QUEX_DEBUG_PRINT("  <detailed buffer content cannot be displayed>\n");
        return;
    }

    QUEX_DEBUG_PRINT("_________________________________________________________________\n");
    compilator_Buffer_print_content_detailed_lines(&iterator, me->begin(me),      total_end, me);
    compilator_Buffer_print_content_detailed_lines(&iterator, me->_lexeme_start_p - 2, total_end, me);
    compilator_Buffer_print_content_detailed_lines(&iterator, me->_read_p        - 2, total_end, me);
    if( me->content_end(me) != 0x0 ) {
        compilator_Buffer_print_content_detailed_lines(&iterator, me->content_end(me) - 4, total_end, me);
    }
    compilator_Buffer_print_content_detailed_lines(&iterator, me->content_space_end(me)   - 4, total_end, me);
    QUEX_DEBUG_PRINT("_________________________________________________________________\n");
}

inline void  
compilator_Buffer_print_content_core(const size_t   ElementSize, 
                                     const uint8_t* Front,
                                     const uint8_t* Back,
                                     const uint8_t* ReadP,
                                     const uint8_t* InputEndP,
                                     bool           BordersF)
{
    const uint8_t* it;
    QUEX_DEBUG_PRINT("[");
    for(it=Front; it <= Back; it += ElementSize) {
        if( it < InputEndP ) {
            switch( ElementSize ) {
            case 1:  QUEX_DEBUG_PRINT1("%02X", it[0]); break;
            case 2:  QUEX_DEBUG_PRINT1("%04X", ((uint16_t*)it)[0]); break;
            case 4: 
            default: QUEX_DEBUG_PRINT1("%08X", ((uint32_t*)it)[0]); break;
            }
        }
        else {
            QUEX_DEBUG_PRINT("--");
        }

        if( &it[ElementSize] == ReadP ) {
            QUEX_DEBUG_PRINT(">");
        }
        else if( BordersF && (it == Front || &it[1] == Back ) ) {
            QUEX_DEBUG_PRINT("|");
        }
        else if( it != Back && &it[ElementSize] != ReadP ) {
            QUEX_DEBUG_PRINT(".");
        }
    }
    QUEX_DEBUG_PRINT("]");
}

inline void  
compilator_Buffer_print_this(compilator_Buffer* me)
{
    QUEX_DEBUG_PRINT("  buffer: ");
    if( compilator_Buffer_resources_absent(me) ) {
        QUEX_DEBUG_PRINT("<uninitialized>\n");
        return;
    }
    QUEX_DEBUG_PRINT("{\n");
    compilator_BufferMemory_print_this(&me->_memory);

    QUEX_DEBUG_PRINT("    _read_p:                      ");
    quex::print_relative_positions(me->begin(me), me->end(me), 
                                             sizeof(compilator_lexatom_t), me->_read_p);
    QUEX_DEBUG_PRINT("\n");
    QUEX_DEBUG_PRINT("    _lexeme_start_p:              ");
    quex::print_relative_positions(me->begin(me), me->end(me), 
                                     sizeof(compilator_lexatom_t), me->_lexeme_start_p);
    QUEX_DEBUG_PRINT("\n");

    QUEX_DEBUG_PRINT1("    _lexatom_at_lexeme_start:     0x%X;\n", (int)me->_lexatom_at_lexeme_start);
    

    compilator_LexatomLoader_print_this(me->filler);

    QUEX_DEBUG_PRINT("    input: {\n");
    QUEX_DEBUG_PRINT1("      lexatom_index_begin: %i;\n", (int)compilator_Buffer_input_lexatom_index_begin(me));
    QUEX_DEBUG_PRINT1("      end_character_index: %i;\n", (int)compilator_Buffer_input_lexatom_index_end(me));
    QUEX_DEBUG_PRINT("      end_p:               ");
    quex::print_relative_positions(me->begin(me), me->end(me), 
                                     sizeof(compilator_lexatom_t), me->content_end(me));
    QUEX_DEBUG_PRINT("\n");
    QUEX_DEBUG_PRINT("    }\n");
    QUEX_DEBUG_PRINT("  }\n");
}


inline void  
compilator_Buffer_print_content_detailed_lines(compilator_lexatom_t** iterator, 
                                               compilator_lexatom_t*  Begin, 
                                               compilator_lexatom_t*  TotalEnd, 
                                               compilator_Buffer*  buffer)
{
    int                 length = 0;
    compilator_lexatom_t*  end    = Begin + 5 > TotalEnd ? TotalEnd : Begin + 5;

    if( Begin > *iterator ) {
        *iterator = Begin;
        QUEX_DEBUG_PRINT("                                           ...\n");
    } else if( *iterator >= end ) {
        return;
    }

    for(; *iterator < end; ++*iterator) {
        length = 0;
        QUEX_DEBUG_PRINT("   ");

        if( *iterator == buffer->begin(buffer) ) {
            QUEX_DEBUG_PRINT("buffer front");
            length += 12;
        }
        if( *iterator == buffer->_lexeme_start_p ) {
            if( length ) { QUEX_DEBUG_PRINT(", "); length += 2; }
            QUEX_DEBUG_PRINT("lexeme start");
            length += 12;
        }
        if( *iterator == buffer->_read_p ) {
            if( length ) { QUEX_DEBUG_PRINT(", "); length += 2; }
            QUEX_DEBUG_PRINT("input");
            length += 5;
        }
        if( *iterator == buffer->content_end(buffer) ) {
            if( length ) { QUEX_DEBUG_PRINT(", "); length += 2; }
            QUEX_DEBUG_PRINT("end of file");
            length += 11;
        }
        if( *iterator == buffer->content_space_end(buffer) ) {
            if( length ) { QUEX_DEBUG_PRINT(", "); length += 2; }
            QUEX_DEBUG_PRINT("buffer back");
            length += 11;
        }
        if( length ) {
            for(; length < 39; ++length)
                QUEX_DEBUG_PRINT("-");
            QUEX_DEBUG_PRINT(">");
        } else {
            QUEX_DEBUG_PRINT("                                        ");
        }

        /* Print the character information */
        QUEX_DEBUG_PRINT2("[%04X] 0x%04X\n", (int)(*iterator - buffer->begin(buffer)),
                           (int)(**iterator));
    }
}

inline void
compilator_Buffer_print_overflow_message(compilator_Buffer* me)
{
    (void)me; 
    uint8_t                   utf8_encoded_str[512]; 
    char                      message[1024];
    char*                     it         = &message[0];
    const char*               MessageEnd = &message[1024];
    uint8_t*                  WEnd       = 0x0;
    uint8_t*                  witerator  = 0x0;
    compilator_lexatom_t*        End        = 0x0;
    const compilator_lexatom_t*  iterator   = 0x0;

    /* No use of 'snprintf()' because not all systems seem to support it propperly. */
    it += __QUEX_STD_strlcpy(it,
             "Distance between lexeme start and current pointer exceeds buffer size.\n"
             "=> Quex mode contains a pattern that 'eats' more from current stream\n"
             "   than can be contained in a buffer.\n"
             "Solution: Increase buffer size or use skippers.\n\n",
             MessageEnd - it);

    it += __QUEX_STD_strlcpy(it, "Lexeme causing overflow:\n[[", 
                             MessageEnd - it);

    WEnd        = &utf8_encoded_str[512 - 7];
    witerator   = utf8_encoded_str; 
    End         = me->content_space_end(me); 
    iterator    = me->_lexeme_start_p; 

    compilator_lexeme_nnzt_to_utf8(&iterator, End, &witerator, WEnd);
    it += __QUEX_STD_strlcpy(it, (char*)utf8_encoded_str, MessageEnd - it);
    it += __QUEX_STD_strlcpy(it, "]]\n", MessageEnd - it);
    QUEX_DEBUG_PRINT(message);
}



#endif /* QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_PRINT_I */
