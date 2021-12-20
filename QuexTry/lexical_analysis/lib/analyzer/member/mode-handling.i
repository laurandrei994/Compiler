/* -*- C++ -*- vim:set syntax=cpp:
 * (C) Frankt-Rene Schaefer
 * ABSOLUTELY NO WARRANTY               */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MEMBER__MODE_HANDLING_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MEMBER__MODE_HANDLING_I

#include "lexical_analysis/lib/definitions"
#include "lexical_analysis/lib/analyzer/Mode"



 const Calc_lexer_Mode*
Calc_lexer_MF_mode(struct Calc_lexer_tag* me) 
{ return me->__current_mode_p; }

 void 
Calc_lexer_MF_set_mode_brutally(struct Calc_lexer_tag* me, const Calc_lexer_Mode* ModeP) 
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

    Calc_lexer_Buffer_callbacks_set(&me->buffer, 
                                    me->__current_mode_p->buffer_callbacks.on_buffer_before_change,
                                    me->__current_mode_p->buffer_callbacks.on_buffer_overflow,
                                    (void*)me);
}

 void    
Calc_lexer_MF_enter_mode(struct Calc_lexer_tag* me, const Calc_lexer_Mode* TargetMode) 
{

    const Calc_lexer_Mode* SourceMode = me->__current_mode_p;



    me->__current_mode_p->on_exit(me, TargetMode);


    Calc_lexer_MF_set_mode_brutally(me, TargetMode);


    TargetMode->on_entry(me, SourceMode);         

}

 void 
Calc_lexer_MF_pop_mode(struct Calc_lexer_tag* me) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.begin ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_ModeStack_PopOnTopLevel);
    }
    else {
        --(me->_mode_stack.end);
        Calc_lexer_MF_enter_mode(me, *me->_mode_stack.end); 
    }
}

 void
Calc_lexer_MF_pop_drop_mode(struct Calc_lexer_tag* me) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.begin ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_ModeStack_PopOnTopLevel);
    }
    else {
        --(me->_mode_stack.end);
    }
}
    
 void       
Calc_lexer_MF_push_mode(struct Calc_lexer_tag* me, Calc_lexer_Mode* new_mode) 
{ 
    if( me->_mode_stack.end == me->_mode_stack.memory_end ) {
        Calc_lexer_MF_error_code_set_if_first(me, E_Error_ModeStack_Overflow);
    }
    else {
        *me->_mode_stack.end = me->__current_mode_p;
        ++(me->_mode_stack.end);
        Calc_lexer_MF_enter_mode(me, new_mode); 
    }
}



#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MEMBER__MODE_HANDLING_I */
