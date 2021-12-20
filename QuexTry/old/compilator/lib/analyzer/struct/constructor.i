/* -*- C++ -*- vim:set syntax=cpp:
 *
 * CONSTRUCTION: Setup a lexical analyzer.
 *
 *   -- Construction may fail, but it never throws an exception!
 *      Failure is notified by the '.error_code' flag.
 *   -- '.receive()' may always be called, but that function might return
 *      immediately if '.error_code' is not 'NONE'.
 *   -- The destructor can be called safely for any object that has been 
 *      'constructed'--even if the construction failed.
 *
 * FAILURE => Current lexer: all resources marked absent 
 *                           -> dysfunctional but destruct-able.
 *            Overtaken objects are destructed and freed!
 *
 *  .error_code == 'NONE': All resources have been allocated. Lexical 
 *                         analysis may start.
 *
 *  .error_code != 'NONE': Error during resource allocation.
 *                         Lexical analysis will immediately send 
 *                         'TERMINATION' token.
 *                         The lexer must (and can) be destructed.
 *
 * DESTRUCTION:
 *
 *   -- never fails, never throws exceptions.
 *
 * (C) 2005-2017 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                                                     */
#ifndef  QUEX_INCLUDE_GUARD_compilator__ANALYZER__STRUCT__CONSTRUCTOR_I
#define  QUEX_INCLUDE_GUARD_compilator__ANALYZER__STRUCT__CONSTRUCTOR_I

#include "compilator\lib\buffer/Buffer.i"
#include "compilator\lib\buffer/lexatoms/LexatomLoader.i"
#include "compilator\lib\analyzer/struct/include-stack"


                    
inline void   compilator_Asserts_user_memory(compilator*  me,
                                                  compilator_lexatom_t*   BufferMemoryBegin, 
                                                  size_t               BufferMemorySize,
                                                  compilator_lexatom_t*   BufferEndOfContentP /* = 0 */);
inline void   compilator_Asserts_construct();

inline void
compilator_from_file_name(compilator*     me,
                          const char*             FileName, 
                          compilator_Converter*   converter /* = 0 */)
{
    compilator_ByteLoader*   new_byte_loader;

    compilator_MF_error_code_clear(me);

    new_byte_loader = compilator_ByteLoader_FILE_new_from_file_name(FileName);

    if( ! new_byte_loader ) {
        compilator_MF_error_code_set_if_first(me, E_Error_File_OpenFailed);
        goto ERROR_2;
    }
    compilator_from_ByteLoader(me, new_byte_loader, converter); 

    if( me->error_code != E_Error_None ) {
        goto ERROR_1;
    }
    else if( ! compilator_MF_input_name_set(me, FileName) ) {
        compilator_MF_error_code_set_if_first(me, E_Error_InputName_Set_Failed);
        goto ERROR_0;
    }

    return;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_2:
    if( converter ) converter->delete_self(converter);
    compilator_MF_resources_absent_mark(me);
ERROR_1:
    /* from_ByteLoader(): destructed and marked all resources absent.         */
    return;
ERROR_0:
    __quex_assert(me->__input_name == (char*)0); /* see constructor core      */
    compilator_destruct(me);
}

/* USE: byte_loader = compilator_ByteLoader_FILE_new(fh, BinaryModeF);
 *      byte_loader = compilator_ByteLoader_stream_new(istream_p, BinaryModeF);
 *      byte_loader = compilator_ByteLoader_wstream_new(wistream_p, BinaryModeF);
 *      ...
 *      Unit Test's StrangeStreams:
 *      byte_loader = compilator_ByteLoader_stream_new(strangestr_p, false);  */

inline void
compilator_from_ByteLoader(compilator*     me,
                           compilator_ByteLoader*  byte_loader,
                           compilator_Converter*   converter /* = 0 */)
{
    compilator_LexatomLoader* new_filler;
    compilator_lexatom_t*        new_memory;

    compilator_MF_error_code_clear(me);

    /* NEW: Filler.                                                           */
    new_filler = compilator_LexatomLoader_new(byte_loader, converter);

    if( ! new_filler ) {
        compilator_MF_error_code_set_if_first(me, E_Error_Allocation_LexatomLoader_Failed);
        goto ERROR_0;
    }

    /* NEW: Memory.                                                           */
    new_memory = (compilator_lexatom_t*)quex::MemoryManager_allocate(
                       QUEX_compilator_SETTING_BUFFER_SIZE * sizeof(compilator_lexatom_t), 
                       E_MemoryObjectType_BUFFER_MEMORY);
    if( ! new_memory ) {
        compilator_MF_error_code_set_if_first(me, E_Error_Allocation_BufferMemory_Failed);
        goto ERROR_1;
    }

    compilator_Buffer_construct(&me->buffer, new_filler,
                                new_memory, QUEX_compilator_SETTING_BUFFER_SIZE, 
                                (compilator_lexatom_t*)0,
                                QUEX_compilator_SETTING_BUFFER_FALLBACK_N,
                                E_Ownership_LEXICAL_ANALYZER,
                                (compilator_Buffer*)0);

    compilator_construct_all_but_buffer(me, true);
    if( me->error_code != E_Error_None ) {
        goto ERROR_2;
    }
    return;

    /* ERROR CASES: Free Resources __________________________________________*/
ERROR_2:
    compilator_Buffer_destruct(&me->buffer);
    compilator_MF_resources_absent_mark(me);
    return;
ERROR_1:
    if( new_filler ) new_filler->delete_self(new_filler); 
    compilator_MF_resources_absent_mark(me);
    return;
ERROR_0:
    if( byte_loader ) byte_loader->delete_self(byte_loader);
    if( converter )   converter->delete_self(converter);
    compilator_MF_resources_absent_mark(me);
    return;
}

inline void
compilator_from_memory(compilator* me,
                       compilator_lexatom_t*  Memory,
                       const size_t        MemorySize,
                       compilator_lexatom_t*  EndOfFileP)

/* When memory is provided from extern, the 'external entity' is responsible
 * for filling it. There is no 'file/stream handle', no 'ByteLoader', and no
 * 'LexatomLoader'.                                                           */
{
    compilator_MF_error_code_clear(me);

    if( ! compilator_BufferMemory_check_chunk(Memory, MemorySize, EndOfFileP) ) {
        compilator_MF_error_code_set_if_first(me, E_Error_ProvidedExternal_Memory_Corrupt);
        goto ERROR_0;
    }

    compilator_Buffer_construct(&me->buffer, 
                                (compilator_LexatomLoader*)0,
                                Memory, MemorySize, EndOfFileP,
                                QUEX_compilator_SETTING_BUFFER_FALLBACK_N,
                                E_Ownership_EXTERNAL,
                                (compilator_Buffer*)0);

    if( ! compilator_construct_all_but_buffer(me, true) ) {
        goto ERROR_1;
    }
    return;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_1:
    compilator_Buffer_destruct(&me->buffer); 
ERROR_0:
    compilator_MF_resources_absent_mark(me);
}

inline bool
compilator_construct_all_but_buffer(compilator* me, 
                                    bool                CallUserConstructorF)
/* Constructs anything but 'LexatomLoader' and 'Buffer'.
 * 
 * RETURNS: true, for success.
 *          false, for failure.                                               */
{
    compilator_Asserts_construct();

    

    me->__input_name = (char*)0;
    me->_parent_memento = (compilator_Memento*)0;

    if( ! compilator_TokenQueue_construct(&me->_token_queue, me,
                                          QUEX_compilator_SETTING_TOKEN_QUEUE_SIZE) ) {
        goto ERROR_0;
    }
    else if( ! compilator_ModeStack_construct(&me->_mode_stack, 
                                              QUEX_compilator_SETTING_MODE_STACK_SIZE) ) {
        goto ERROR_1;
    }
    
    else if( ! compilator_Counter_construct(&me->counter) ) {
        compilator_MF_error_code_set_if_first(me, E_Error_Constructor_Counter_Failed);
        goto ERROR_2;
    }
    
    

    /* A user's mode change callbacks may be called as a consequence of the 
     * call to 'set_mode_brutally_by_id()'. The current mode must be set to '0'
     * so that the user may detect whether this is the first mode transition.*/
    me->__current_mode_p = (compilator_Mode*)0;
    compilator_MF_set_mode_brutally(me, QUEX_compilator_SETTING_MODE_INITIAL_P);

    if( CallUserConstructorF && ! compilator_user_constructor(me) ) {
        compilator_MF_error_code_set_if_first(me, E_Error_UserConstructor_Failed);
        goto ERROR_3;
    }

    compilator_MF_error_code_clear(me);
    return true;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_3:
    /* NO ALLOCATED RESOURCES IN: 'me->counter'                               */

ERROR_2:

    compilator_ModeStack_destruct(&me->_mode_stack);
ERROR_1:
    compilator_TokenQueue_destruct(&me->_token_queue);
ERROR_0:
    compilator_all_but_buffer_resources_absent_mark(me);
    return false;
}

inline void
compilator_destruct(compilator* me)
{
    compilator_destruct_all_but_buffer(me);

    compilator_Buffer_destruct(&me->buffer);

    compilator_user_destructor(me);

    /* Protect against double destruction.                                    */
    compilator_MF_resources_absent_mark(me);
}

inline void
compilator_destruct_all_but_buffer(compilator* me)
{
    compilator_MF_include_stack_delete(me);
    /*
     *              DESTRUCT ANYTHING ONLY AFTER INCLUDE STACK                
     *
     * During destruction the all previously pushed analyzer states are 
     * popped and destructed, until only the outest state remains. This
     * is then the state that is destructed here.                             */
    compilator_TokenQueue_destruct(&me->_token_queue);
    compilator_ModeStack_destruct(&me->_mode_stack);

    if( me->__input_name ) {
        quex::MemoryManager_free(me->__input_name, E_MemoryObjectType_BUFFER_MEMORY);
    }

    compilator_all_but_buffer_resources_absent_mark(me);
}

inline void
compilator_MF_resources_absent_mark(compilator* me)
/* Resouces = 'absent' => Destructor knows that it must not be freed. 
 * 
 * This function is essential to set the lexical analyzer into a state
 * where it is safe to be destructed, even if some resources were missing.    
 *
 * IMPORTANT: The '.error_code' remains intact!
 *______________________________________________________________________________
 * WARNING: This function is NOT to be called, if not all resources are 
 *          disattached (destructed/freed) from the lexical analyzer. 
 *          Otherwise: unreferenced trailing objects; memory leaks.
 *____________________________________________________________________________*/
{
    /* NOTE: 'memset()' would destroy the v-table in case that the analyzer 
     *       is a c++ class object.                                           */
    compilator_TokenQueue_resources_absent_mark(&me->_token_queue);

    

     compilator_Counter_resources_absent_mark(&me->counter);

    compilator_Buffer_resources_absent_mark(&me->buffer);

    me->current_analyzer_function = (compilator_AnalyzerFunctionP)0;
    me->__current_mode_p          = (compilator_Mode*)0; 

    compilator_ModeStack_resources_absent_mark(&me->_mode_stack);
    me->_parent_memento = (compilator_Memento*)0;
    me->__input_name = (char*)0;
}

inline void
compilator_all_but_buffer_resources_absent_mark(compilator* me)
{
    uint8_t backup[sizeof(compilator_Buffer)];

    /* Plain copy suffices (backup holds pointers safely).                    */
    memcpy((void*)&backup[0], (void*)&me->buffer, sizeof(compilator_Buffer));

    compilator_MF_resources_absent_mark(me);

    /* Plain copy suffices (backup resets pointers safely).                   */
    memcpy((void*)&me->buffer, (void*)&backup[0], sizeof(compilator_Buffer));
}

inline bool
compilator_MF_resources_absent(compilator* me)
/* RETURNS: 'true' if all resources are marked absent.
 *          'false' if at least one is not marked absent.                     */
{
    if( ! compilator_TokenQueue_resources_absent(&me->_token_queue) ) {
        return false;
    }
    else if( me->_parent_memento != (compilator_Memento*)0 ) {
        return false;
    }
    else if( ! compilator_Buffer_resources_absent(&me->buffer) ) {
        return false;
    }
    else if( ! compilator_ModeStack_resources_absent(&me->_mode_stack) ) {
        return false;
    }
    else if(    me->current_analyzer_function != (compilator_AnalyzerFunctionP)0
             || me->__current_mode_p          != (compilator_Mode*)0
             || me->__input_name              != (char*)0 ) {
        return false;
    }
    else {
        return true;
    }
}


inline void
compilator_Asserts_user_memory(compilator* me,
                               compilator_lexatom_t*  BufferMemoryBegin, 
                               size_t              BufferMemorySize,
                               compilator_lexatom_t*  BufferEndOfContentP /* = 0 */)
{
#   ifdef QUEX_OPTION_ASSERTS
    size_t               memory_size = BufferMemoryBegin ? BufferMemorySize 
                                       :                   QUEX_compilator_SETTING_BUFFER_SIZE;
    compilator_lexatom_t*   iterator = 0x0;

    __quex_assert(memory_size == 0 || memory_size > 2);
    if( BufferMemoryBegin ) {
        /* End of File must be inside the buffer, because we assume that the 
         * buffer contains all that is required.                              */
        if(    BufferEndOfContentP < BufferMemoryBegin 
            || BufferEndOfContentP > (BufferMemoryBegin + BufferMemorySize - 1)) {
            QUEX_ERROR_EXIT("\nConstructor: Argument 'BufferEndOfContentP' must be inside the provided memory\n"
                            "Constructor: buffer (speficied by 'BufferMemoryBegin' and 'BufferMemorySize').\n"
                            "Constructor: Note, that the last element of the buffer is to be filled with\n"
                            "Constructor: the buffer limit code character.\n");
        }
    }
    if( BufferEndOfContentP ) {
        __quex_assert(BufferEndOfContentP >  BufferMemoryBegin);
        __quex_assert(BufferEndOfContentP <= BufferMemoryBegin + memory_size - 1);

        /* The memory provided must be initialized. If it is not, then that's wrong.
         * Try to detect me by searching for BLC and PTC.                         */
        for(iterator = BufferMemoryBegin + 1; iterator != BufferEndOfContentP; ++iterator) {
            if(    *iterator == QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER 
                || *iterator == QUEX_compilator_SETTING_BUFFER_LEXATOM_PATH_TERMINATION ) {
                QUEX_ERROR_EXIT("\nConstructor: Buffer limit code and/or path termination code appeared in buffer\n"
                                "Constructor: when pointed to user memory. Note, that the memory pointed to must\n"
                                "Constructor: be initialized! You might redefine QUEX_compilator_SETTING_BUFFER_LEXATOM_PATH_TERMINATION\n"
                                "Constructor: and/or QUEX_compilator_SETTING_BUFFER_LEXATOM_PATH_TERMINATION; or use command line arguments\n"
                                "Constructor: '--buffer-limit' and '--path-termination'.");
            }
        }
    }
#   endif

    /* NOT: before ifdef, otherwise c90 issue: mixed declarations and code   */
    (void)me; (void)BufferMemoryBegin; (void)BufferMemorySize; (void)BufferEndOfContentP;
}

/* AUXILIARY FUNCTIONS FOR CONSTRUCTION _______________________________________                                     
 *                                                                           */

inline void
compilator_Asserts_construct()
{
#   if      defined(QUEX_OPTION_ASSERTS) \
       && ! defined(QUEX_OPTION_ASSERTS_WARNING_MESSAGE_DISABLED_EXT)
    QUEX_DEBUG_PRINT(__QUEX_MESSAGE_ASSERTS_INFO);
#   endif

#   if defined(QUEX_OPTION_ASSERTS) 
    if( QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER == QUEX_compilator_SETTING_BUFFER_LEXATOM_PATH_TERMINATION ) {
        QUEX_ERROR_EXIT("Path termination code (PTC) and buffer limit code (BLC) must be different.\n");
    }
#   endif
}

inline void
compilator_MF_collect_user_memory(compilator* me, 
                                  compilator_lexatom_t** user_buffer_memory)
{
    *user_buffer_memory = me->buffer._memory.ownership == E_Ownership_LEXICAL_ANALYZER ?
                            (compilator_lexatom_t*)0 
                          : me->buffer.begin(&me->buffer);
}



#endif /*  QUEX_INCLUDE_GUARD_compilator__ANALYZER__STRUCT__CONSTRUCTOR_I */
