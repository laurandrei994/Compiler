/* -*- C++ -*-  vim: set syntax=cpp:
 * (C) 2007-2008 Frank-Rene Schaefer  */
#ifndef  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__LEXATOMS__CONVERTER__ICONV__CONVERTER_ICONV_I
#define  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__LEXATOMS__CONVERTER__ICONV__CONVERTER_ICONV_I



#include <errno.h>


#include "lexical_analysis/lib/definitions"
#include "lexical_analysis/lib/analyzer/configuration/validation"

#include "lexical_analysis/lib/buffer/lexatoms/converter/iconv/Converter_IConv"
#include "lexical_analysis/lib/quex/MemoryManager"




 bool 
Calc_lexer_Converter_IConv_initialize(Calc_lexer_Converter* me,
                                const char* FromCodec, const char* ToCodec);

 bool    
Calc_lexer_Converter_IConv_initialize_by_bom_id(struct Calc_lexer_Converter_tag* me,
                                                E_ByteOrderMark                    BomId);

 E_LoadResult 
Calc_lexer_Converter_IConv_convert(Calc_lexer_Converter*     me, 
                                   uint8_t**                 source, 
                                   const uint8_t*            SourceEnd,
                                   Calc_lexer_lexatom_t**       drain,  
                                   const Calc_lexer_lexatom_t*  DrainEnd);
 void 
Calc_lexer_Converter_IConv_delete_self(Calc_lexer_Converter* me);

 ptrdiff_t 
Calc_lexer_Converter_IConv_stomach_byte_n(Calc_lexer_Converter* me);

 void 
Calc_lexer_Converter_IConv_stomach_clear(Calc_lexer_Converter* me);

 void 
Calc_lexer_Converter_IConv_print_this(Calc_lexer_Converter* me);

 Calc_lexer_Converter*
Calc_lexer_Converter_IConv_new(const char* FromCodec, const char* ToCodec)
{
    Calc_lexer_Converter_IConv*  me = \
       (Calc_lexer_Converter_IConv*)
       quex_MemoryManager_allocate(sizeof(Calc_lexer_Converter_IConv),
                                      E_MemoryObjectType_CONVERTER);
    if( ! me ) {
        return (Calc_lexer_Converter*)0;
    }

    me->handle = (iconv_t)-1;
    if( ! Calc_lexer_Converter_construct(&me->base,
                                         FromCodec, ToCodec,
                                         Calc_lexer_Converter_IConv_initialize,
                                         Calc_lexer_Converter_IConv_initialize_by_bom_id,
                                         Calc_lexer_Converter_IConv_convert,
                                         Calc_lexer_Converter_IConv_delete_self,
                                         Calc_lexer_Converter_IConv_stomach_byte_n,
                                         Calc_lexer_Converter_IConv_stomach_clear,
                                         Calc_lexer_Converter_IConv_print_this) ) {
        quex_MemoryManager_free((void*)me, E_MemoryObjectType_CONVERTER);
        return (Calc_lexer_Converter*)0;
    }

    return &me->base;
}

 bool 
Calc_lexer_Converter_IConv_initialize(Calc_lexer_Converter* alter_ego,
                                      const char*           FromCodec, 
                                      const char*           ToCodec)
/* Initializes the converter, or in case that 'FromCodec == 0', it marks
 * the object as 'not-initialized'. 'Converter_IConv_initialize_by_bom_id()'
 * will act upon that information.  
 *
 * RETURNS: true, if success. false, else.                                    */
{
    Calc_lexer_Converter_IConv* me              = (Calc_lexer_Converter_IConv*)alter_ego;
    const bool                  little_endian_f = quex_system_is_little_endian();

    if( ! FromCodec ) {
        me->handle = (iconv_t)-1;               /* mark 'not-initialized'.    */
        return true;                            /* still, nothing went wrong. */
    }

    /* Setup conversion handle */
    if( ! ToCodec ) {
        switch( sizeof(Calc_lexer_lexatom_t) ) {
        case 4:  ToCodec = little_endian_f ? "UCS-4LE" : "UCS-4BE"; break;
        case 2:  ToCodec = little_endian_f ? "UCS-2LE" : "UCS-2BE"; break;
        case 1:  ToCodec = "ASCII"; break;
        default:  __quex_assert(false); return false;
        }
    } 
    me->handle = iconv_open(ToCodec, FromCodec);
    if( me->handle == (iconv_t)-1 ) return false;
    
    /* ByteN / Character:
     * IConv does not provide something like 'isFixedWidth()'. So, the 
     * safe assumption "byte_n/lexatom != const" is made, except for some
     * well-known examples.                                              */
    me->base.byte_n_per_lexatom = -1;
    if(    __QUEX_STD_strcmp(FromCodec, "UCS-4LE") == 0 
        || __QUEX_STD_strcmp(FromCodec, "UCS-4BE")  == 0) {
        me->base.byte_n_per_lexatom   = 4;
        me->base.input_code_unit_size = 4;
    }
    else if(   __QUEX_STD_strcmp(FromCodec, "UCS-2LE") == 0 
            || __QUEX_STD_strcmp(FromCodec, "UCS-2BE")  == 0) {
        me->base.byte_n_per_lexatom   = 2;
        me->base.input_code_unit_size = 2;
    }
    else if( __QUEX_STD_strcmp(FromCodec, "UTF16") == 0 ) {
        me->base.byte_n_per_lexatom   = -1;
        me->base.input_code_unit_size = 2;
    }
    else if( __QUEX_STD_strcmp(FromCodec, "UTF8") == 0 ) {
        me->base.byte_n_per_lexatom   = -1;
        me->base.input_code_unit_size = 1;
    }

    return true;
}

 bool    
Calc_lexer_Converter_IConv_initialize_by_bom_id(Calc_lexer_Converter* alter_ego,
                                                E_ByteOrderMark         BomId)
{
    Calc_lexer_Converter_IConv* me = (Calc_lexer_Converter_IConv*)alter_ego;
    const char* name;

    if( me->handle != (iconv_t)-1 ) {
        iconv_close(me->handle); 
    }

    switch( BomId ) {
    case QUEX_BOM_UTF_8:           name = "UTF-8"; break;                      
    case QUEX_BOM_UTF_1:           name = "UTF-1"; break;                      
    case QUEX_BOM_UTF_EBCDIC:      return false; /* name = "UTF_EBCDIC"; break; */
    case QUEX_BOM_BOCU_1:          return false; /* name = "BOCU_1"; break;     */
    case QUEX_BOM_GB_18030:        name = "GB18030"; break;                
    case QUEX_BOM_UTF_7:           name = "UTF-7"; break;                      
    case QUEX_BOM_UTF_16:          name = "UTF-16"; break;                                  
    case QUEX_BOM_UTF_16_LE:       name = "UTF-16LE"; break;              
    case QUEX_BOM_UTF_16_BE:       name = "UTF-16BE"; break;              
    case QUEX_BOM_UTF_32:          name = "UTF-32"; break;                    
    case QUEX_BOM_UTF_32_LE:       name = "UTF-32LE"; break;              
    case QUEX_BOM_UTF_32_BE:       name = "UTF-32BE"; break;              
    case QUEX_BOM_SCSU:            /* not supported. */
    case QUEX_BOM_SCSU_TO_UCS:     /* not supported. */
    case QUEX_BOM_SCSU_W0_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W1_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W2_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W3_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W4_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W5_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W6_TO_FE80: /* not supported. */
    case QUEX_BOM_SCSU_W7_TO_FE80: /* not supported. */
    default:
    case QUEX_BOM_NONE:            return false;
    }

    return me->base.initialize(alter_ego, name, NULL);
}

#ifndef QUEX_ADAPTER_ICONV_2ND_ARG_DEFINITION_DONE
#define QUEX_ADAPTER_ICONV_2ND_ARG_DEFINITION_DONE



#if defined(QUEX_OPTION_ICONV_2ND_ARG_CONST_CHARPP_EXT)
#    define QUEX_ADAPTER_ICONV_2ND_ARG(ARG)  ((const char**)(ARG))
#else
#    define QUEX_ADAPTER_ICONV_2ND_ARG(ARG)  ((char**)(ARG))
#endif

#endif

 E_LoadResult 
Calc_lexer_Converter_IConv_convert(Calc_lexer_Converter*     alter_ego, 
                                   uint8_t**                 source, 
                                   const uint8_t*            SourceEnd,
                                   Calc_lexer_lexatom_t**       drain,  
                                   const Calc_lexer_lexatom_t*  DrainEnd)
/* RETURNS:  true  --> User buffer is filled as much as possible with 
 *                     converted lexatoms.
 *           false --> More raw bytes are needed to fill the user buffer.           
 *
 *  <fschaef@users.sourceforge.net>.                                          */
{
    Calc_lexer_Converter_IConv* me                  = (Calc_lexer_Converter_IConv*)alter_ego;
    size_t                      source_bytes_left_n = (size_t)(SourceEnd - *source);
    size_t                      drain_bytes_left_n  = (size_t)(DrainEnd - *drain)*sizeof(Calc_lexer_lexatom_t);
    size_t                      report;
    
    /* Compilation error for second argument in some versions of IConv?
     * => define "QUEX_OPTION_ICONV_2ND_ARG_CONST_CHARPP_EXT"                */
    report = iconv(me->handle, 
                   QUEX_ADAPTER_ICONV_2ND_ARG(source), &source_bytes_left_n,
                   (char**)drain,                        &drain_bytes_left_n);
    /* Avoid strange error reports from 'iconv' in case that the source 
     * buffer is empty.                                                      */

    if( report != (size_t)-1 ) { 
        /* No Error => Raw buffer COMPLETELY converted.                      */
        __quex_assert(! source_bytes_left_n);
        return drain_bytes_left_n ? E_LoadResult_INCOMPLETE 
                                  : E_LoadResult_COMPLETE;
    }

    switch( errno ) {
    default:
        QUEX_ERROR_EXIT("Unexpected setting of 'errno' after call to GNU's iconv().");

    case EILSEQ:
        return E_LoadResult_ENCODING_ERROR;

    case EINVAL:
        /* Incomplete byte sequence for lexatom conversion.
         * => '*source' points to the beginning of the incomplete sequence.
         * => If drain is not filled, then new source content must be 
         *    provided.                                                      */
        return drain_bytes_left_n ? E_LoadResult_INCOMPLETE 
                                  : E_LoadResult_COMPLETE;

    case E2BIG:
        /* The input buffer was not able to hold the number of converted 
         * lexatoms. => Drain is filled to the limit.                        */
        return E_LoadResult_COMPLETE;
    }
}

 ptrdiff_t 
Calc_lexer_Converter_IConv_stomach_byte_n(Calc_lexer_Converter* me)
{ (void)me; return 0; }

 void 
Calc_lexer_Converter_IConv_stomach_clear(Calc_lexer_Converter* me)
{ (void)me; }

 void 
Calc_lexer_Converter_IConv_delete_self(Calc_lexer_Converter* alter_ego)
{
    Calc_lexer_Converter_IConv* me = (Calc_lexer_Converter_IConv*)alter_ego;

    iconv_close(me->handle); 
    quex_MemoryManager_free((void*)me, E_MemoryObjectType_CONVERTER);
}

 void 
Calc_lexer_Converter_IConv_print_this(Calc_lexer_Converter* alter_ego)
{
    Calc_lexer_Converter_IConv* me = (Calc_lexer_Converter_IConv*)alter_ego;

    QUEX_DEBUG_PRINT("        type:                 IConv, GNU;\n");
    QUEX_DEBUG_PRINT1("        handle:               ((%p));\n", (const void*)(me->handle));
}




#endif /*  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__LEXATOMS__CONVERTER__ICONV__CONVERTER_ICONV_I */
