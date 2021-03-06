/* -*- C++ -*- vim:set syntax=cpp:
 *
 * RESET: Reset lexical analysis with a new input stream.
 *
 * All components of the lexer are reset into a state so that the new input
 * stream can be analyzed. 
 *
 *   -- Reset may fail, but it never throws an exception!
 *      Failure is notified by the '.error_code' flag.
 *   -- '.receive()' may always be called, but that function might return
 *      immediately if '.error_code' is not 'NONE'.
 *   -- The destructor can be called safely for any object that has been 
 *      'reset'--even if the reset failed.
 *
 * FAILURE => Current lexer: all resources marked absent 
                             -> dysfunctional but destruct-able.
 *            Overtaken objects are destructed and freed!
 *
 * NOTE: The state before the reset is FORGOTTEN. For a 'reminiscent reset' 
 *       the 'include' feature may be considered.
 *
 *______________________________________________________________________________
 * INSIGHT: 
 *
 *    Reset consists of two major phases:
 * 
 *    (1) Resources and contents are reset. FAILURE MAY OCCURR.
 *        If errors occur, the lexer is still UNTOUCHED!
 *
 *    (2) All allocation has been done. SUCCESS IS GRANTED. 
 *        Only then, the lexer object is assigned new content.
 * 
 * The *pivot point* of 'success granted' is inside the function 
 * 'MF_reset_all_but_buffer()'. If it returns != NULL, success is granted.
 * Anything that might fail, *must happen before* the call to this function.
 * The exact 'pivot point' is marked in a comment by '[PIVOT POINT]'.
 *______________________________________________________________________________
 *
 * (C) 2006-2017 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                                                     */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__STRUCT__RESET_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__STRUCT__RESET_I

#include "quexProcessed/lib/buffer/Buffer.i"
#include "quexProcessed/lib/analyzer/struct/reset"



inline bool
quexProcessed_MF_reset(quexProcessed* me)  
/* Reset given setup to initial position. This works on 'byte_loader' buffers
 * as well as buffers initialized to run on memory only.
 *
 * RETURNS: true, in case of success.
 *          false, in case of failure.                                        */
{
    if( me->buffer.filler ) {
        if( ! quexProcessed_LexatomLoader_lexatom_index_reset(me->buffer.filler) ) {
            goto ERROR_0;
        }
    }

    quexProcessed_Buffer_init(&me->buffer, (quexProcessed_lexatom_t*)0); 

    if( ! quexProcessed_MF_reset_all_but_buffer(me) ) {
        goto ERROR_0;
    }

    return true;

ERROR_0:
    quexProcessed_Buffer_destruct(&me->buffer);
    return false;
}

inline bool
quexProcessed_MF_reset_file_name(quexProcessed*   me, 
                           const char*           FileName, 
                           quexProcessed_Converter* new_converter /* = 0 */)
/* Reset on file 'FileName' as C-Standard Lib 'FILE'. 
 *
 *                OWNERSHIP OF 'converter' IS TAKEN OVER!
 *                USER IS **NOT** RESPONSIBLE FOR DELETING IT!
 *
 * 'reset_memory()' or 'include_push_memory()' has been applied before?
 * => 'collect_user_memory()' delivers memory to be user-de-allocated.
 *
 * RETURNS: true, in case of success.
 *          false, in case of failure.                                        */
{
    quexProcessed_ByteLoader*   new_byte_loader;

    /* NEW: ByteLoader.                                                       */
    new_byte_loader = quexProcessed_ByteLoader_FILE_new_from_file_name(FileName);
    if( ! new_byte_loader ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_File_OpenFailed);
        goto ERROR_0;
    }

    if( ! quexProcessed_MF_reset_ByteLoader(me, new_byte_loader, new_converter) ) {
        goto ERROR_1;
    }
    else if( ! quexProcessed_MF_input_name_set(me, FileName) ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_InputName_Set_Failed);
        goto ERROR_0;
    }

    return true;

ERROR_1:
    /* 'MF_reset_ByteLoader()': deletes and mark absent everything.              */
ERROR_0:
    /* 'destruct' marks resources as absent => double destruction is safe.    */
    quexProcessed_destruct(me);
    return false;
}

/* USE: byte_loader = quexProcessed_ByteLoader_FILE_new(fh, BinaryModeF);
 *      byte_loader = quexProcessed_ByteLoader_stream_new(istream_p, BinaryModeF);
 *      byte_loader = quexProcessed_ByteLoader_wstream_new(wistream_p, BinaryModeF);
 *      ...
 *      Unit Test's StrangeStreams:
 *      byte_loader = quexProcessed_ByteLoader_stream_new(strangestr_p, false);  */
inline bool
quexProcessed_MF_reset_ByteLoader(quexProcessed*     me,
                            quexProcessed_ByteLoader*  new_byte_loader,
                            quexProcessed_Converter*   new_converter /* = 0 */)
/* Resets the 'filler' to a new 'new_byte_loader' and 'new_converter'. If it fails
 * the 'filler' is freed and set to NULL. '.error_code' contains the code of
 * the error that occurred.
 *
 *                OWNERSHIP OF 'new_byte_loader' IS TAKEN OVER!
 *                OWNERSHIP OF 'new_converter' IS TAKEN OVER!
 *                USER IS **NOT** RESPONSIBLE FOR DELETING IT!
 *
 * 'reset_memory()' or 'include_push_memory()' has been applied before?
 * => 'collect_user_memory()' delivers memory to be user-de-allocated.
 *
 * RETURNS: true, in case of success.
 *          false, in case of failure.                                        */
{
    quexProcessed_LexatomLoader* new_filler;

    if( me->error_code != E_Error_None ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_Reset_OnError);
        goto ERROR_0;
    }
     
    new_filler = quexProcessed_LexatomLoader_new(new_byte_loader, new_converter);
    if( ! new_filler ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_Allocation_LexatomLoader_Failed);
        goto ERROR_0;
    }
    if( me->buffer.filler ) {
        me->buffer.filler->delete_self(me->buffer.filler);
    }
    me->buffer.filler = new_filler;

    quexProcessed_Buffer_init(&me->buffer, (quexProcessed_lexatom_t*)0);

    if( ! quexProcessed_MF_reset_all_but_buffer(me) ) {
        goto ERROR_1;
    }
    return true;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_0:
    if( new_byte_loader ) new_byte_loader->delete_self(new_byte_loader);
    if( new_converter )   new_converter->delete_self(new_converter);
    /* 'destruct' marks resources as absent => double destruction is safe.    */
ERROR_1:
    quexProcessed_destruct(me);  /* Destructs also 'me->buffer'                  */
    return false;
}

inline bool
quexProcessed_MF_reset_memory(quexProcessed*  me, 
                        quexProcessed_lexatom_t*   Memory,
                        const size_t         MemorySize,
                        quexProcessed_lexatom_t*   EndOfFileP)
/* Take-in a user's chunk of memory--filled as it is. There is no LexatomLoader.
 * If the buffer's current memory is owned externally, a pointer to it is 
 * returned. Else, zero is returned.
 *
 *                  OWNERSHIP OF 'Memory' REMAINS AT USER!
 *                  USER IS RESPONSIBLE FOR DELETING IT!
 *
 * 'reset_memory()' or 'include_push_memory()' has been applied before?
 * => 'collect_user_memory()' delivers memory to be user-de-allocated.
 *
 * RETURNS: true, in case of success.
 *          false, in case of failure.                                        */
{
    if( ! quexProcessed_BufferMemory_check_chunk(Memory, MemorySize, EndOfFileP) ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_ProvidedExternal_Memory_Corrupt);
        goto ERROR_0;
    }
    else if( me->error_code != E_Error_None ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_Reset_OnError);
        goto ERROR_0;
    }

    quexProcessed_Buffer_destruct(&me->buffer); 
    /* Buffer's memory owned externally => memory NOT freed!
     * but 'me->buffer._memory._front = NULL'!                                */

    if( ! quexProcessed_MF_reset_all_but_buffer(me) ) {
        goto ERROR_1;
    }

    quexProcessed_Buffer_construct(&me->buffer, 
                                (quexProcessed_LexatomLoader*)0,
                                Memory, MemorySize, EndOfFileP,
                                QUEX_quexProcessed_SETTING_BUFFER_FALLBACK_N,
                                E_Ownership_EXTERNAL,
                                (quexProcessed_Buffer*)0);
    return true;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_1:
    /* 'MF_reset_all_but_buffer()' All but the buffer resource destructed and 
     *                          marked as absent.                             */
    quexProcessed_Buffer_destruct(&me->buffer);
    return false;

ERROR_0:
    quexProcessed_destruct(me);
    return false;
}

inline bool
quexProcessed_MF_reset_all_but_buffer(quexProcessed*  me) 
/* Resets anything but 'Buffer'. In general reset is not equal to 'destruct'
 * followed by 'construct'. However, for the concerned components it is 
 * convenient.
 *
 * FAILURE: All but the buffer's resources are destructed and marked absent.
 * 
 * RETURNS: true, for success.
 *          false, else. Buffer's resource must be destructed/marked absent.  */
{
    quexProcessed_destruct_all_but_buffer(me);

    /*__________________________________________________________________________
     *
     * [PIVOT POINT] All but buffer's resources are desctructed.
     *
     * From here: Construct new lexical analyzer object.
     *________________________________________________________________________*/

    if( ! quexProcessed_user_reset(me) ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_UserReset_Failed);
        goto ERROR_0;
    }
    else if( ! quexProcessed_construct_all_but_buffer(me, false) ) {
        goto ERROR_0;
    }
    return true;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_0:
    return false;
}




#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__STRUCT__RESET_I */
