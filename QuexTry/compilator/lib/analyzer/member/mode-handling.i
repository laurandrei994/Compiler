/* -*- C++ -*- vim:set syntax=cpp:
 * (C) Frankt-Rene Schaefer
 * ABSOLUTELY NO WARRANTY               */
#ifndef QUEX_INCLUDE_GUARD_compilator__ANALYZER__MEMBER__MODE_HANDLING_I
#define QUEX_INCLUDE_GUARD_compilator__ANALYZER__MEMBER__MODE_HANDLING_I

#include "compilator\lib\definitions"
#include "compilator\lib\analyzer/Mode"



inline const compilator_Mode*
compilator_MF_mode(compilator* me) 
{ return me->__current_mode_p; }

inline void 
compilator_MF_set_mode_brutally(compilator* me, const compilator_Mode* ModeP) 
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

    compilator_Buffer_callbacks_set(&me->buffer, 
                                    me->__current_mode_p->buffer_callbacks.on_buffer_before_change,
                                    me->__current_mode_p->buffer_callbacks.on_buffer_overflow,
                                    (void*)me);
}

inline void    
compilator_MF_enter_mode(compilator* me, const compilator_Mode* TargetMode) 
{

    const compilator_Mode* SourceMode = me->__current_mode_p;



    me->__current_mode_p->on_exit(me, TargetMode);


    compilator_MF_set_mode_brutally(me, TargetMode);


    TargetMode->on_entry(me, SourceMode);         

}

inline void 
compilator_MF_pop_mode(compilator* me) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.begin ) {
        compilator_MF_error_code_set_if_first(me, E_Error_ModeStack_PopOnTopLevel);
    }
    else {
        --(me->_mode_stack.end);
        compilator_MF_enter_mode(me, *me->_mode_stack.end); 
    }
}

inline void
compilator_MF_pop_drop_mode(compilator* me) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.begin ) {
        compilator_MF_error_code_set_if_first(me, E_Error_ModeStack_PopOnTopLevel);
    }
    else {
        --(me->_mode_stack.end);
    }
}
    
inline void       
compilator_MF_push_mode(compilator* me, compilator_Mode* new_mode) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.memory_end ) {
        compilator_MF_error_code_set_if_first(me, E_Error_ModeStack_Overflow);
    }
    else {
        *me->_mode_stack.end = me->__current_mode_p;
        ++(me->_mode_stack.end);
        compilator_MF_enter_mode(me, new_mode); 
    }
}



#endif /* QUEX_INCLUDE_GUARD_compilator__ANALYZER__MEMBER__MODE_HANDLING_I */
