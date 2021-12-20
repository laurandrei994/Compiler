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
#ifndef  QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__STRUCT__CONSTRUCTOR_I
#define  QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__STRUCT__CONSTRUCTOR_I

#include "lexical_analysis/lib/buffer/Buffer.i"
#include "lexical_analysis/lib/buffer/lexatoms/LexatomLoader.i"
#include "lexical_analysis/lib/analyzer/struct/include-stack"


                    
 void   Calc_lexer_Asserts_user_memory(struct Calc_lexer_tag*  me,
                                                  Calc_lexer_lexatom_t*   BufferMemoryBegin, 
                                                  size_t               BufferMemorySize,
                                                  Calc_lexer_lexatom_t*   BufferEndOfContentP /* = 0 */);
 void   Calc_lexer_Asserts_construct();

 void
Calc_lexer_from_file_name(struct Calc_lexer_tag*     me,
                          const char*             FileName, 
                          Calc_lexer_Converter*   converter /* = 0 */)
{
    Calc_lexer_ByteLoader*   new_byte_loader;

    Calc_lexer_MF_error_code_clear(me);

    new_byte_loader = Calc_lexer_ByteLoader_FILE_new_from_file_name(FileName);

    if( ! new_byte_loader ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_File_OpenFailed);
        goto ERROR_2;
    }
    Calc_lexer_from_ByteLoader(me, new_byte_loader, converter); 

    if( me->error_code != E_Error_None ) {
        goto ERROR_1;
    }
    else if( ! Calc_lexer_MF_input_name_set(me, FileName) ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_InputName_Set_Failed);
        goto ERROR_0;
    }

    return;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_2:
    if( converter ) converter->delete_self(converter);
    Calc_lexer_MF_resources_absent_mark(me);
ERROR_1:
    /* from_ByteLoader(): destructed and marked all resources absent.         */
    return;
ERROR_0:
    __quex_assert(me->__input_name == (char*)0); /* see constructor core      */
    Calc_lexer_destruct(me);
}

/* USE: byte_loader = Calc_lexer_ByteLoader_FILE_new(fh, BinaryModeF);
 *      byte_loader = Calc_lexer_ByteLoader_stream_new(istream_p, BinaryModeF);
 *      byte_loader = Calc_lexer_ByteLoader_wstream_new(wistream_p, BinaryModeF);
 *      ...
 *      Unit Test's StrangeStreams:
 *      byte_loader = Calc_lexer_ByteLoader_stream_new(strangestr_p, false);  */

 void
Calc_lexer_from_ByteLoader(struct Calc_lexer_tag*     me,
                           Calc_lexer_ByteLoader*  byte_loader,
                           Calc_lexer_Converter*   converter /* = 0 */)
{
    Calc_lexer_LexatomLoader* new_filler;
    Calc_lexer_lexatom_t*        new_memory;

    Calc_lexer_MF_error_code_clear(me);

    /* NEW: Filler.                                                           */
    new_filler = Calc_lexer_LexatomLoader_new(byte_loader, converter);

    if( ! new_filler ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_Allocation_LexatomLoader_Failed);
        goto ERROR_0;
    }

    /* NEW: Memory.                                                           */
    new_memory = (Calc_lexer_lexatom_t*)quex_MemoryManager_allocate(
                       QUEX_Calc_lexer_SETTING_BUFFER_SIZE * sizeof(Calc_lexer_lexatom_t), 
                       E_MemoryObjectType_BUFFER_MEMORY);
    if( ! new_memory ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_Allocation_BufferMemory_Failed);
        goto ERROR_1;
    }

    Calc_lexer_Buffer_construct(&me->buffer, new_filler,
                                new_memory, QUEX_Calc_lexer_SETTING_BUFFER_SIZE, 
                                (Calc_lexer_lexatom_t*)0,
                                QUEX_Calc_lexer_SETTING_BUFFER_FALLBACK_N,
                                E_Ownership_LEXICAL_ANALYZER,
                                (Calc_lexer_Buffer*)0);

    Calc_lexer_construct_all_but_buffer(me, true);
    if( me->error_code != E_Error_None ) {
        goto ERROR_2;
    }
    return;

    /* ERROR CASES: Free Resources __________________________________________*/
ERROR_2:
    Calc_lexer_Buffer_destruct(&me->buffer);
    Calc_lexer_MF_resources_absent_mark(me);
    return;
ERROR_1:
    if( new_filler ) new_filler->delete_self(new_filler); 
    Calc_lexer_MF_resources_absent_mark(me);
    return;
ERROR_0:
    if( byte_loader ) byte_loader->delete_self(byte_loader);
    if( converter )   converter->delete_self(converter);
    Calc_lexer_MF_resources_absent_mark(me);
    return;
}

 void
Calc_lexer_from_memory(struct Calc_lexer_tag* me,
                       Calc_lexer_lexatom_t*  Memory,
                       const size_t        MemorySize,
                       Calc_lexer_lexatom_t*  EndOfFileP)

/* When memory is provided from extern, the 'external entity' is responsible
 * for filling it. There is no 'file/stream handle', no 'ByteLoader', and no
 * 'LexatomLoader'.                                                           */
{
    Calc_lexer_MF_error_code_clear(me);

    if( ! Calc_lexer_BufferMemory_check_chunk(Memory, MemorySize, EndOfFileP) ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_ProvidedExternal_Memory_Corrupt);
        goto ERROR_0;
    }

    Calc_lexer_Buffer_construct(&me->buffer, 
                                (Calc_lexer_LexatomLoader*)0,
                                Memory, MemorySize, EndOfFileP,
                                QUEX_Calc_lexer_SETTING_BUFFER_FALLBACK_N,
                                E_Ownership_EXTERNAL,
                                (Calc_lexer_Buffer*)0);

    if( ! Calc_lexer_construct_all_but_buffer(me, true) ) {
        goto ERROR_1;
    }
    return;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_1:
    Calc_lexer_Buffer_destruct(&me->buffer); 
ERROR_0:
    Calc_lexer_MF_resources_absent_mark(me);
}

 bool
Calc_lexer_construct_all_but_buffer(struct Calc_lexer_tag* me, 
                                    bool                CallUserConstructorF)
/* Constructs anything but 'LexatomLoader' and 'Buffer'.
 * 
 * RETURNS: true, for success.
 *          false, for failure.                                               */
{
    Calc_lexer_Asserts_construct();

     Calc_lexer_member_functions_assign(me);

    me->__input_name = (char*)0;
    me->_parent_memento = (struct Calc_lexer_Memento_tag*)0;

    if( ! Calc_lexer_TokenQueue_construct(&me->_token_queue, me,
                                          QUEX_Calc_lexer_SETTING_TOKEN_QUEUE_SIZE) ) {
        goto ERROR_0;
    }
    else if( ! Calc_lexer_ModeStack_construct(&me->_mode_stack, 
                                              QUEX_Calc_lexer_SETTING_MODE_STACK_SIZE) ) {
        goto ERROR_1;
    }
    
    else if( ! Calc_lexer_Counter_construct(&me->counter) ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_Constructor_Counter_Failed);
        goto ERROR_2;
    }
    
    

    /* A user's mode change callbacks may be called as a consequence of the 
     * call to 'set_mode_brutally_by_id()'. The current mode must be set to '0'
     * so that the user may detect whether this is the first mode transition.*/
    me->__current_mode_p = (Calc_lexer_Mode*)0;
    Calc_lexer_MF_set_mode_brutally(me, QUEX_Calc_lexer_SETTING_MODE_INITIAL_P);

    if( CallUserConstructorF && ! Calc_lexer_user_constructor(me) ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_UserConstructor_Failed);
        goto ERROR_3;
    }

    Calc_lexer_MF_error_code_clear(me);
    return true;

    /* ERROR CASES: Free Resources ___________________________________________*/
ERROR_3:
    /* NO ALLOCATED RESOURCES IN: 'me->counter'                               */

ERROR_2:

    Calc_lexer_ModeStack_destruct(&me->_mode_stack);
ERROR_1:
    Calc_lexer_TokenQueue_destruct(&me->_token_queue);
ERROR_0:
    Calc_lexer_all_but_buffer_resources_absent_mark(me);
    return false;
}

 void
Calc_lexer_destruct(struct Calc_lexer_tag* me)
{
    Calc_lexer_destruct_all_but_buffer(me);

    Calc_lexer_Buffer_destruct(&me->buffer);

    Calc_lexer_user_destructor(me);

    /* Protect against double destruction.                                    */
    Calc_lexer_MF_resources_absent_mark(me);
}

 void
Calc_lexer_destruct_all_but_buffer(struct Calc_lexer_tag* me)
{
    Calc_lexer_MF_include_stack_delete(me);
    /*
     *              DESTRUCT ANYTHING ONLY AFTER INCLUDE STACK                
     *
     * During destruction the all previously pushed analyzer states are 
     * popped and destructed, until only the outest state remains. This
     * is then the state that is destructed here.                             */
    Calc_lexer_TokenQueue_destruct(&me->_token_queue);
    Calc_lexer_ModeStack_destruct(&me->_mode_stack);

    if( me->__input_name ) {
        quex_MemoryManager_free(me->__input_name, E_MemoryObjectType_BUFFER_MEMORY);
    }

    Calc_lexer_all_but_buffer_resources_absent_mark(me);
}

 void
Calc_lexer_MF_resources_absent_mark(struct Calc_lexer_tag* me)
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
    Calc_lexer_TokenQueue_resources_absent_mark(&me->_token_queue);

     Calc_lexer_member_functions_assign(me);

     Calc_lexer_Counter_resources_absent_mark(&me->counter);

    Calc_lexer_Buffer_resources_absent_mark(&me->buffer);

    me->current_analyzer_function = (Calc_lexer_AnalyzerFunctionP)0;
    me->__current_mode_p          = (Calc_lexer_Mode*)0; 

    Calc_lexer_ModeStack_resources_absent_mark(&me->_mode_stack);
    me->_parent_memento = (struct Calc_lexer_Memento_tag*)0;
    me->__input_name = (char*)0;
}

 void
Calc_lexer_all_but_buffer_resources_absent_mark(struct Calc_lexer_tag* me)
{
    uint8_t backup[sizeof(Calc_lexer_Buffer)];

    /* Plain copy suffices (backup holds pointers safely).                    */
    memcpy((void*)&backup[0], (void*)&me->buffer, sizeof(Calc_lexer_Buffer));

    Calc_lexer_MF_resources_absent_mark(me);

    /* Plain copy suffices (backup resets pointers safely).                   */
    memcpy((void*)&me->buffer, (void*)&backup[0], sizeof(Calc_lexer_Buffer));
}

 bool
Calc_lexer_MF_resources_absent(struct Calc_lexer_tag* me)
/* RETURNS: 'true' if all resources are marked absent.
 *          'false' if at least one is not marked absent.                     */
{
    if( ! Calc_lexer_TokenQueue_resources_absent(&me->_token_queue) ) {
        return false;
    }
    else if( me->_parent_memento != (struct Calc_lexer_Memento_tag*)0 ) {
        return false;
    }
    else if( ! Calc_lexer_Buffer_resources_absent(&me->buffer) ) {
        return false;
    }
    else if( ! Calc_lexer_ModeStack_resources_absent(&me->_mode_stack) ) {
        return false;
    }
    else if(    me->current_analyzer_function != (Calc_lexer_AnalyzerFunctionP)0
             || me->__current_mode_p          != (Calc_lexer_Mode*)0
             || me->__input_name              != (char*)0 ) {
        return false;
    }
    else {
        return true;
    }
}


 void
Calc_lexer_Asserts_user_memory(struct Calc_lexer_tag* me,
                               Calc_lexer_lexatom_t*  BufferMemoryBegin, 
                               size_t              BufferMemorySize,
                               Calc_lexer_lexatom_t*  BufferEndOfContentP /* = 0 */)
{
#   ifdef QUEX_OPTION_ASSERTS
    size_t               memory_size = BufferMemoryBegin ? BufferMemorySize 
                                       :                   QUEX_Calc_lexer_SETTING_BUFFER_SIZE;
    Calc_lexer_lexatom_t*   iterator = 0x0;

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
            if(    *iterator == QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER 
                || *iterator == QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_PATH_TERMINATION ) {
                QUEX_ERROR_EXIT("\nConstructor: Buffer limit code and/or path termination code appeared in buffer\n"
                                "Constructor: when pointed to user memory. Note, that the memory pointed to must\n"
                                "Constructor: be initialized! You might redefine QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_PATH_TERMINATION\n"
                                "Constructor: and/or QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_PATH_TERMINATION; or use command line arguments\n"
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

 void
Calc_lexer_Asserts_construct()
{
#   if      defined(QUEX_OPTION_ASSERTS) \
       && ! defined(QUEX_OPTION_ASSERTS_WARNING_MESSAGE_DISABLED_EXT)
    QUEX_DEBUG_PRINT(__QUEX_MESSAGE_ASSERTS_INFO);
#   endif

#   if defined(QUEX_OPTION_ASSERTS) 
    if( QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER == QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_PATH_TERMINATION ) {
        QUEX_ERROR_EXIT("Path termination code (PTC) and buffer limit code (BLC) must be different.\n");
    }
#   endif
}

 void
Calc_lexer_MF_collect_user_memory(struct Calc_lexer_tag* me, 
                                  Calc_lexer_lexatom_t** user_buffer_memory)
{
    *user_buffer_memory = me->buffer._memory.ownership == E_Ownership_LEXICAL_ANALYZER ?
                            (Calc_lexer_lexatom_t*)0 
                          : me->buffer.begin(&me->buffer);
}



#endif /*  QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__STRUCT__CONSTRUCTOR_I */
