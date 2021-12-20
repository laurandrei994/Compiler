/* -*- C++ -*- vim: set syntax=cpp: */
#ifndef  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__LEXATOMS__LEXATOM_LOADER_I
#define  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__LEXATOMS__LEXATOM_LOADER_I

#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/buffer/Buffer"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader"
#include "quexProcessed/lib/buffer/Buffer_print"
#include "quexProcessed/lib/quex/MemoryManager"



inline bool       quexProcessed_LexatomLoader_ByteLoader_Converter_consistency(quexProcessed_ByteLoader*  byte_loader, 
                                                                                 quexProcessed_Converter*   converter);
inline bool       quexProcessed_LexatomLoader_lexatom_index_seek(quexProcessed_LexatomLoader*         me, 
                                                                    const quexProcessed_stream_position_t  LexatomIndex);
inline quexProcessed_stream_position_t 
                       quexProcessed_LexatomLoader_lexatom_index_tell(quexProcessed_LexatomLoader* me);
inline bool       quexProcessed_LexatomLoader_lexatom_index_step_to(quexProcessed_LexatomLoader*        me,
                                                                      const quexProcessed_stream_position_t TargetCI);
inline void       quexProcessed_LexatomLoader_reverse_byte_order(quexProcessed_lexatom_t*       Begin, 
                                                                  const quexProcessed_lexatom_t* End);

inline void       quexProcessed_LexatomLoader_delete_self(quexProcessed_LexatomLoader*); 

                       
inline quexProcessed_LexatomLoader*
quexProcessed_LexatomLoader_new(quexProcessed_ByteLoader*  byte_loader, 
                             quexProcessed_Converter*   converter)
{
    quexProcessed_LexatomLoader* filler;

    /* byte_loader = 0; possible if memory is filled manually.               */
    if( converter ) {
        if( ! quexProcessed_LexatomLoader_ByteLoader_Converter_consistency(byte_loader, converter) ) {
            return (quexProcessed_LexatomLoader*)0;
        }
        filler = quexProcessed_LexatomLoader_Converter_new(byte_loader, converter);
    }
    else {
        filler = quexProcessed_LexatomLoader_Plain_new(byte_loader); 
    }
    
    return filler;
}

inline bool
quexProcessed_LexatomLoader_ByteLoader_Converter_consistency(quexProcessed_ByteLoader*  byte_loader, 
                                                          quexProcessed_Converter*   converter)
{
    if( ! byte_loader ) {
        return true;
    }
    else if( converter->input_code_unit_size == -1 ) {
        return true;
    }
    else if( converter->input_code_unit_size >= (int)byte_loader->element_size ) {
        return true;
    }
    else {
        QUEX_DEBUG_PRINT1("Error: The specified byte loader provides elements of size %i.\n", 
                          (int)byte_loader->element_size);
        QUEX_DEBUG_PRINT1("Error: The converter requires input elements of size <= %i.\n", 
                          (int)converter->input_code_unit_size);
        QUEX_DEBUG_PRINT("Error: This happens, for example, when using 'wistream' input\n"
                         "Error: without considering 'sizeof(wchar_t)' with respect to\n"
                         "Error: the encodings code unit's size. (UTF8=1byte, UTF16=2byte, etc.)\n");
        return false;
    }
}

inline void       
quexProcessed_LexatomLoader_delete_self(quexProcessed_LexatomLoader* me)
{ 
    if( ! me ) return;

    if( me->byte_loader ) {
        quexProcessed_ByteLoader_delete(&me->byte_loader);
    }

    /* destruct_self: Free resources occupied by 'me' BUT NOT 'myself'.
     * delete_self:   Free resources occupied by 'me' AND 'myself'.           */
    if( me->derived.destruct_self ) {
        me->derived.destruct_self(me);
    }

    quex::MemoryManager_free((void*)me, E_MemoryObjectType_BUFFER_FILLER);
}

inline void    
quexProcessed_LexatomLoader_setup(quexProcessed_LexatomLoader*   me,
                               size_t       (*derived_load_lexatoms)(quexProcessed_LexatomLoader*,
                                                                     quexProcessed_lexatom_t*, 
                                                                     const size_t, 
                                                                     bool*, bool*),
                               ptrdiff_t    (*stomach_byte_n)(quexProcessed_LexatomLoader*),
                               void         (*stomach_clear)(quexProcessed_LexatomLoader*),
                               void         (*derived_destruct_self)(quexProcessed_LexatomLoader*),
                               void         (*derived_fill_prepare)(quexProcessed_LexatomLoader*  me,
                                                                    quexProcessed_Buffer*         buffer,
                                                                    void**                     begin_p,
                                                                    const void**               end_p),
                               ptrdiff_t    (*derived_fill_finish)(quexProcessed_LexatomLoader* me,
                                                                   quexProcessed_lexatom_t*        BeginP,
                                                                   const quexProcessed_lexatom_t*  EndP,
                                                                   const void*               FilledEndP),
                               void         (*derived_get_fill_boundaries)(quexProcessed_LexatomLoader*  alter_ego,
                                                                           quexProcessed_Buffer*         buffer,
                                                                           void**                     begin_p, 
                                                                           const void**               end_p),
                               void         (*derived_print_this)(quexProcessed_LexatomLoader*  alter_ego),
                               quexProcessed_ByteLoader*  byte_loader,
                               ptrdiff_t    ByteNPerCharacter)
{
    __quex_assert(0 != me);
    __quex_assert(0 != derived_load_lexatoms);
    __quex_assert(0 != derived_destruct_self);

    /* Support for buffer filling without user interaction                   */
    me->stomach_byte_n        = stomach_byte_n;
    me->stomach_clear         = stomach_clear;
    me->input_lexatom_tell    = quexProcessed_LexatomLoader_lexatom_index_tell;
    me->input_lexatom_seek    = quexProcessed_LexatomLoader_lexatom_index_seek;
    me->derived.load_lexatoms = derived_load_lexatoms;
    me->derived.destruct_self = derived_destruct_self;
    me->derived.print_this    = derived_print_this;
    me->delete_self           = quexProcessed_LexatomLoader_delete_self;

    /* Support for manual buffer filling.                                    */
    me->derived.fill_prepare        = derived_fill_prepare;
    me->derived.fill_finish         = derived_fill_finish;
    me->derived.get_fill_boundaries = derived_get_fill_boundaries;

    me->byte_loader                 = byte_loader;

    me->_byte_order_reversion_active_f = false;
    me->lexatom_index_next_to_fill   = 0;
    me->byte_n_per_lexatom           = ByteNPerCharacter;
}

inline ptrdiff_t       
quexProcessed_LexatomLoader_load(quexProcessed_LexatomLoader*  me, 
                              quexProcessed_lexatom_t*         LoadP, 
                              const ptrdiff_t            LoadN,
                              quexProcessed_stream_position_t  StartLexatomIndex,
                              bool*                      end_of_stream_f,
                              bool*                      encoding_error_f)
/* Seeks the input position StartLexatomIndex and loads 'LoadN' 
 * lexatoms into the engine's buffer starting from 'LoadP'.
 *
 * RETURNS: Number of loaded lexatoms.                                       */
{
    ptrdiff_t                loaded_n;

    /* (1) Seek to the position where loading shall start.                       
     *                                                                       */
    if( ! me->input_lexatom_seek(me, StartLexatomIndex) ) {
        return 0;
    }
    __quex_assert(me->lexatom_index_next_to_fill == StartLexatomIndex);

    /* (2) Load content into the given region.                                   
     *                                                                       */
    loaded_n = (ptrdiff_t)me->derived.load_lexatoms(me, LoadP, (size_t)LoadN,
                                                    end_of_stream_f, encoding_error_f);
#   ifdef QUEX_OPTION_ASSERTS
    {
        const quexProcessed_lexatom_t* p;
        /* The buffer limit code is not to appear inside the loaded content. */
        for(p=LoadP; p != &LoadP[loaded_n]; ++p) {
            __quex_assert(*p != QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);
        }
    }
#   endif

    __quex_assert(loaded_n <= LoadN);
    me->lexatom_index_next_to_fill += loaded_n;

    /* (3) Optionally reverse the byte order.                                    
     *                                                                       */
    if( me->_byte_order_reversion_active_f ) {
        quexProcessed_LexatomLoader_reverse_byte_order(LoadP, &LoadP[loaded_n]);
    }

    return loaded_n;
}

inline void
quexProcessed_LexatomLoader_reverse_byte_order(quexProcessed_lexatom_t*       Begin, 
                                           const quexProcessed_lexatom_t* End)
{
    uint8_t              tmp = 0xFF;
    quexProcessed_lexatom_t* iterator = 0x0;

    switch( sizeof(quexProcessed_lexatom_t) ) {
    default:
        __quex_assert(false);
        break;
    case 1:
        /* Nothing to be done */
        break;
    case 2:
        for(iterator=Begin; iterator != End; ++iterator) {
            tmp = *(((uint8_t*)iterator) + 0);
            *(((uint8_t*)iterator) + 0) = *(((uint8_t*)iterator) + 1);
            *(((uint8_t*)iterator) + 1) = tmp;
        }
        break;
    case 4:
        for(iterator=Begin; iterator != End; ++iterator) {
            tmp = *(((uint8_t*)iterator) + 0);
            *(((uint8_t*)iterator) + 0) = *(((uint8_t*)iterator) + 3);
            *(((uint8_t*)iterator) + 3) = tmp;
            tmp = *(((uint8_t*)iterator) + 1);
            *(((uint8_t*)iterator) + 1) = *(((uint8_t*)iterator) + 2);
            *(((uint8_t*)iterator) + 2) = tmp;
        }
        break;
    }
}

inline void       
quexProcessed_LexatomLoader_print_this(quexProcessed_LexatomLoader* me)
{
    QUEX_DEBUG_PRINT("    filler: {\n");
    if( ! me ) {
        QUEX_DEBUG_PRINT("      type: <none>\n");
    }
    else {
        QUEX_DEBUG_PRINT1("      lexatom_index_next_to_fill:     %i;\n", 
                          (int)me->lexatom_index_next_to_fill);
        QUEX_DEBUG_PRINT1("      byte_n_per_lexatom:             %i;\n", 
                          (int)me->byte_n_per_lexatom);
        QUEX_DEBUG_PRINT1("      _byte_order_reversion_active_f: %s;\n", 
                          E_Boolean_NAME(me->_byte_order_reversion_active_f)); 
        /* me->byte_loader->print_this(me->byte_loader); */
        if( me->derived.print_this ) me->derived.print_this(me);
        if( ! me->byte_loader ) {
            QUEX_DEBUG_PRINT("      byte_loader: <none>\n");
        }
        else {
            if( me->byte_loader->print_this ) me->byte_loader->print_this(me->byte_loader); 
        }
    }
    QUEX_DEBUG_PRINT("    }\n");
}



#include "quexProcessed/lib/buffer/Buffer.i"
#include "quexProcessed/lib/buffer/bytes/ByteLoader.i"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader_navigation.i"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader_Converter.i"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader_Plain.i"

#endif /* QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFERFILLER_I */

