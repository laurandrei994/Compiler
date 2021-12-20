/* -*- C++ -*- vim: set syntax=cpp: 
 * 
 * PURPOSE: Gavaging -- Running lexical analysis based on content that is fed
 *                      via direct access to the analyzer's internal buffer.
 * 
 * This file implements an adaptor to a lexical analyzer's class in order to
 * specify a specific 'data feeding scenario'. Where 'normal' lexical analysis
 * relies on filling in the background from some stream or socket, feeding
 * and gavaging implies manual interaction of the consumer of the caller.
 *
 * Gavaging can be applied, in case that a framework can be told where to put
 * data. This is particularily useful in small systems with a tiny memory 
 * footprint. The avoidance of copying into the internal buffer (such as by
 * feeding) may imply also performance increase. In case that a lexical
 * analyzer runs on larger server farms this might imply a significant 
 * reduction on power consumption.
 *
 * Neverthelss, gavaging has a significant disadvantage: At one feeding step
 * it cannot feed more than the internal buffers content's free space!
 *
 * PROCEDURE:
 *
 * In a first step, the caller must get access to the free space in the 
 * lexer's buffer using 'access()'. When a converter is used, the reported 
 * pointers are actually pointing into the 'raw buffer', i.e. the buffer that
 * contains data to be converted and transferred to the lexer's buffer.
 *
 * For the second step, the caller must trigger the 'gavage()' function. This
 * initiates internal procedures to prepare lexical analysis. When converters
 * are used, this implies conversion of data.
 *
 * Finaly, the function 'deliver()' must be called. It returns Null if no 
 * token can be produced and new 'gavaging' is necessary. Otherwise, the 
 * returned value is a pointer to the produced token.
 *
 * The constructor of a feeder receives a 'StreamTerminatingTokenId' that 
 * tells when the stream is absolutely terminated. The caller must check
 * the received token against this id and terminate in case that it arrived.
 *
 * EXAMPLES: See the demo's '010' directory.
 *
 * (C) 2016 Frank-Rene Schaefer.                                             */

#ifndef QUEX_INCLUDE_GUARD_compilator__ANALYZER__ADAPTORS__GAVAGER_I
#define QUEX_INCLUDE_GUARD_compilator__ANALYZER__ADAPTORS__GAVAGER_I

#include "compilator\lib\analyzer/adaptors/Gavager"





inline
compilator_Gavager::compilator_Gavager(compilator* lexer,
                                       compilator_token_id_t  StreamTerminatingTokenId)
{ compilator_Gavager_construct(this, lexer, StreamTerminatingTokenId); }

inline bool
compilator_Gavager::access(void** begin_p, const void** end_p)
{ return compilator_Gavager_access(this, begin_p, end_p); }

inline bool
compilator_Gavager::gavage(ptrdiff_t ReceivedN)
{ return compilator_Gavager_gavage(this, ReceivedN); }

inline compilator_Token* 
compilator_Gavager::deliver()
{ return compilator_Gavager_deliver(this); }



inline void
compilator_Gavager_construct(compilator_Gavager*  me, 
                             compilator*     lexer,
                             compilator_token_id_t      StreamTerminatingTokenId)
{
    /* Initialization                                                        */
    me->base.lexer                       = lexer;
    me->base.last_incomplete_lexeme_p    = (compilator_lexatom_t*)0;
    me->base.stream_terminating_token_id = StreamTerminatingTokenId;



    if( ! QUEX_compilator_SETTING_FALLBACK_MANDATORY ) {
        /* For manual buffer filling, the fallback must be finite and computed 
         * during engine generation. (call Quex with '--fallback-mandatory')  */
        compilator_MF_error_code_set_if_first(me->base.lexer, 
                                               E_Error_EngineNotGeneratedWithFallbackMandatory);
    }
}

inline bool
compilator_Gavager_access(compilator_Gavager* me,
                          void** begin_p, const void** end_p)
/* Provides access to internal buffer to be filled. 
 *
 * MODIFIES: [0] 'begin_p' pointing to the beginning of the buffer region that
 *                can be filled with data.
 *           [1] 'end_p' pointing to the end of the buffer's region, i.e. to
 *                the first element behind it.                               */
{
    compilator_Buffer* buffer = &me->base.lexer->buffer;
    return buffer->fill_prepare(&me->base.lexer->buffer, begin_p, end_p);
}

inline bool
compilator_Gavager_gavage(compilator_Gavager* me, ptrdiff_t ReceivedN)
{
    void*              begin_p;
    const void*        end_p;
    compilator_Buffer* buffer = &me->base.lexer->buffer;

    buffer->filler->derived.get_fill_boundaries(buffer->filler, buffer,
                                                &begin_p, &end_p);
    if( ReceivedN > (const uint8_t*)end_p - (uint8_t*)begin_p ) {
        return false;
    }
    buffer->fill_finish(buffer, &((uint8_t*)begin_p)[ReceivedN]);
    return true;
}

inline compilator_Token*
compilator_Gavager_deliver(compilator_Gavager* me)
{
    return compilator_receive_from_chunk(me->base.lexer, true, 
                                         me->base.stream_terminating_token_id);
}




#include "compilator\lib\analyzer/adaptors/Feeder.i"

#endif /*  QUEX_INCLUDE_GUARD_compilator__ANALYZER__ADAPTORS__GAVAGER_I */
