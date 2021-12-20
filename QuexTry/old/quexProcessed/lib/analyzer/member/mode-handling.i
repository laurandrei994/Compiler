/* -*- C++ -*- vim:set syntax=cpp:
 * (C) Frankt-Rene Schaefer
 * ABSOLUTELY NO WARRANTY               */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__MODE_HANDLING_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__MODE_HANDLING_I

#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/analyzer/Mode"



inline const quexProcessed_Mode*
quexProcessed_MF_mode(quexProcessed* me) 
{ return me->__current_mode_p; }

inline void 
quexProcessed_MF_set_mode_brutally(quexProcessed* me, const quexProcessed_Mode* ModeP) 
/* Core of all mode setting functions. 
 *
 * ADAPTS: -- current mode pointer.
 *         -- current analyzer function pointer
 *         -- setting the buffer's handlers for 'on_buffer_overflow' and 
 *            'on_buffer_before_change'                                   */
{ 
    __quex_debug_show_mode_transition(me, ModeP);

    me->__current_mode_p          = ModeP;
    me->current_analyzer_function = ModeP->analyzer_function; 

    quexProcessed_Buffer_callbacks_set(&me->buffer, 
                                    me->__current_mode_p->buffer_callbacks.on_buffer_before_change,
                                    me->__current_mode_p->buffer_callbacks.on_buffer_overflow,
                                    (void*)me);
}

inline void    
quexProcessed_MF_enter_mode(quexProcessed* me, const quexProcessed_Mode* TargetMode) 
{

    const quexProcessed_Mode* SourceMode = me->__current_mode_p;



    me->__current_mode_p->on_exit(me, TargetMode);


    quexProcessed_MF_set_mode_brutally(me, TargetMode);


    TargetMode->on_entry(me, SourceMode);         

}

inline void 
quexProcessed_MF_pop_mode(quexProcessed* me) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.begin ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_ModeStack_PopOnTopLevel);
    }
    else {
        --(me->_mode_stack.end);
        quexProcessed_MF_enter_mode(me, *me->_mode_stack.end); 
    }
}

inline void
quexProcessed_MF_pop_drop_mode(quexProcessed* me) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.begin ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_ModeStack_PopOnTopLevel);
    }
    else {
        --(me->_mode_stack.end);
    }
}
    
inline void       
quexProcessed_MF_push_mode(quexProcessed* me, quexProcessed_Mode* new_mode) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.memory_end ) {
        quexProcessed_MF_error_code_set_if_first(me, E_Error_ModeStack_Overflow);
    }
    else {
        *me->_mode_stack.end = me->__current_mode_p;
        ++(me->_mode_stack.end);
        quexProcessed_MF_enter_mode(me, new_mode); 
    }
}



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MEMBER__MODE_HANDLING_I */
