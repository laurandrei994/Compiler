/* -*- C++ -*-   vim: set syntax=cpp:
 * (C) Frankt-Rene Schaefer
 * ABSOLUTELY NO WARRANTY               */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__MISC_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__MISC_I

#include "quexProcessed/lib/analyzer/Counter"
#include "quexProcessed/lib/buffer/Buffer_print"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader"
#include "quexProcessed/lib/lexeme/basics"





inline void 
quexProcessed_MF_error_code_clear(quexProcessed* me)
{ me->error_code = E_Error_None; }

inline void 
quexProcessed_MF_error_code_set_void(quexProcessed* me)
{ me->error_code = E_Error_Uninitialized; }

inline bool 
quexProcessed_MF_error_code_is_void(quexProcessed* me)
{ return me->error_code == E_Error_Uninitialized; }

inline void 
quexProcessed_MF_error_code_set_if_first(quexProcessed* me, E_Error ErrorCode)
/* Never overwrite an error code
 * => original error is maintained.                                           */
{ if( me->error_code == E_Error_None ) me->error_code = ErrorCode; }

inline quexProcessed_Token*  
quexProcessed_MF_token_p(quexProcessed* me)
{
    return me->_token_queue.write_iterator; 
}

inline void 
quexProcessed_MF_send(quexProcessed* me, 
                   quexProcessed_token_id_t  Id)
{ quexProcessed_TokenQueue_push(&me->_token_queue, Id); }

inline void 
quexProcessed_MF_send_n(quexProcessed* me, 
                     quexProcessed_token_id_t  Id, 
                     size_t              RepetitionN)
{ quexProcessed_TokenQueue_push_repeated(&me->_token_queue, Id, RepetitionN); }

inline bool 
quexProcessed_MF_send_text(quexProcessed* me, 
                        quexProcessed_token_id_t  Id,
                        quexProcessed_lexatom_t*  BeginP, 
                        quexProcessed_lexatom_t*  EndP)
{ return quexProcessed_TokenQueue_push_text(&me->_token_queue, Id, BeginP, EndP); }

inline bool 
quexProcessed_MF_send_string(quexProcessed* me,
                          quexProcessed_token_id_t  Id,
                          quexProcessed_lexatom_t*  ZeroTerminatedString)
{ 
    const size_t Length = quexProcessed_lexeme_length((const quexProcessed_lexatom_t*)ZeroTerminatedString);

    return quexProcessed_TokenQueue_push_text(&me->_token_queue, Id, ZeroTerminatedString, 
                                           ZeroTerminatedString + (ptrdiff_t)Length + 1); 
}

inline bool
quexProcessed_MF_byte_order_reversion(quexProcessed* me)
{ 
    __quex_assert(0 != me->buffer.filler);
    return me->buffer.filler->_byte_order_reversion_active_f; 
}

inline void     
quexProcessed_MF_byte_order_reversion_set(quexProcessed* me, bool Value)
{ 
    __quex_assert(0 != me->buffer.filler);
    me->buffer.filler->_byte_order_reversion_active_f = Value; 
}

inline const char*
quexProcessed_MF_input_name(quexProcessed* me)
{ return me->__input_name; }

inline bool
quexProcessed_MF_input_name_set(quexProcessed* me, const char* InputNameP)
/* Sets the 'input name', i.e. some string that identifies the input stream.
 * In case of failure '.__input_name' is set to NULL.
 *
 * RETURNS: true, for success. false, else.                                   */
{ 
    if( me->__input_name ) {
        quex::MemoryManager_free(me->__input_name, E_MemoryObjectType_INPUT_NAME);
    }
    if(  ! InputNameP ) {
        me->__input_name = (char*)0;
        return true;
    }
    else {
        me->__input_name = quex::MemoryManager_clone_string(InputNameP);
        return me->__input_name ? true : false;
    }
}

inline const char* 
quexProcessed_MF_version(quexProcessed* me)
{ 
    (void)me;
    return          QUEX_STRING(quexProcessed)           \
           ": Version "         QUEX_quexProcessed_SETTING_ANALYZER_VERSION \
           ". Date "            QUEX_quexProcessed_SETTING_BUILD_DATE       \
           "Generated by Quex " QUEX_quexProcessed_SETTING_VERSION ".";
}

inline void
quexProcessed_MF_print_this(quexProcessed* me)
{
    const char*       handler_name = (const char*)0;

    QUEX_DEBUG_PRINT1("  mode:       %s;\n", 
                      me->__current_mode_p == 0x0 ? "0x0" : me->__current_mode_p->name);
    QUEX_DEBUG_PRINT1("  error_code: %s;\n", E_Error_NAME(me->error_code));

    if( me->error_code != E_Error_None ) {
        handler_name = E_Error_MISSING_HANDLER_NAME(me->error_code);
        if( handler_name ) {
            QUEX_DEBUG_PRINT1("              (* '%s' has not been specified for mode*)\n", 
                              handler_name);
        }
    }

     quexProcessed_Counter_print_this(&me->counter);
    

    QUEX_DEBUG_PRINT("  _mode_stack: ");
    quexProcessed_ModeStack_print(&me->_mode_stack);

    quexProcessed_Buffer_print_this(&me->buffer);

    quexProcessed_user_print(me);

    if( me->error_code != E_Error_None ) {
        quexProcessed_Buffer_print_content_detailed(&me->buffer);
        QUEX_DEBUG_PRINT("\n\n");
    }
}


inline size_t quexProcessed_MF_line_number(const quexProcessed* me)            { return quexProcessed_MF_line_number_at_begin(me); }
inline size_t quexProcessed_MF_line_number_at_begin(const quexProcessed* me)   { return me->counter._line_number_at_begin; }
inline size_t quexProcessed_MF_line_number_at_end(const quexProcessed* me)     { return me->counter._line_number_at_end; }
inline void   quexProcessed_MF_line_number_set(quexProcessed* me, size_t Value) { me->counter._line_number_at_end = Value; }


inline size_t quexProcessed_MF_column_number(const quexProcessed* me)          { return quexProcessed_MF_column_number_at_begin(me); }
inline size_t quexProcessed_MF_column_number_at_begin(const quexProcessed* me) { return me->counter._column_number_at_begin; }
inline size_t quexProcessed_MF_column_number_at_end(const quexProcessed* me)   { return me->counter._column_number_at_end; }
inline void   quexProcessed_MF_column_number_set(quexProcessed* me, size_t Value) { me->counter._column_number_at_end = Value; }







#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__MISC_I */