/* -*- C++ -*-  vim:set syntax=cpp: 
 *
 * (C) 2004-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY              */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MODE_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MODE_I

#include "lexical_analysis/lib/definitions"



 void
Calc_lexer_Mode_uncallable_analyzer_function(struct Calc_lexer_tag* me)
{ 
    __quex_assert(0); 
    (void)me;
    return; 
}



 void
Calc_lexer_Mode_on_entry_exit_null_function(struct Calc_lexer_tag* me, const Calc_lexer_Mode* TheMode) 
{ (void)me; (void)TheMode; }

 bool
Calc_lexer_ModeStack_construct(Calc_lexer_ModeStack* me, const size_t N)
{
    me->begin = (const Calc_lexer_Mode**)quex_MemoryManager_allocate(
                                N * sizeof(Calc_lexer_Mode*),
                                E_MemoryObjectType_MODE_STACK);
    if( ! me->begin ) {
        Calc_lexer_ModeStack_resources_absent_mark(me);
        return false;
    }
    else {
        me->end        = &me->begin[0];
        me->memory_end = &me->begin[N];
        return true;
    }
}

 void
Calc_lexer_ModeStack_destruct(Calc_lexer_ModeStack* me)
{
    if( me->begin ) {
        quex_MemoryManager_free((void*)&me->begin[0],
                                   E_MemoryObjectType_MODE_STACK);
    }
    Calc_lexer_ModeStack_resources_absent_mark(me);
}

 void
Calc_lexer_ModeStack_resources_absent_mark(Calc_lexer_ModeStack* me)
{
    me->begin      = (const Calc_lexer_Mode**)0;
    me->end        = (const Calc_lexer_Mode**)0;
    me->memory_end = (const Calc_lexer_Mode**)0;
}

 bool
Calc_lexer_ModeStack_resources_absent(Calc_lexer_ModeStack* me)
{
    return    me->end        == (const Calc_lexer_Mode**)0
           && me->memory_end == (const Calc_lexer_Mode**)0;
}

 void
Calc_lexer_ModeStack_print(Calc_lexer_ModeStack* me)
{
    const Calc_lexer_Mode** iterator = 0x0;
    if( Calc_lexer_ModeStack_resources_absent(me) ) {
        QUEX_DEBUG_PRINT("<uninitialized>\n");
    }
    else {
        QUEX_DEBUG_PRINT("{\n");
        QUEX_DEBUG_PRINT1("    size:    %i;\n",
                          (int)(me->memory_end - me->begin));
        QUEX_DEBUG_PRINT("    content: [");
        if( me->end > me->memory_end || me->end < me->begin ) {
            QUEX_DEBUG_PRINT("<pointer corrupted>");
        }
        else {
            for(iterator=&me->end[-1]; iterator >= me->begin; --iterator) {
                QUEX_DEBUG_PRINT1("%s, ", (*iterator)->name);
            }
        }
        QUEX_DEBUG_PRINT("]\n");
        QUEX_DEBUG_PRINT("  }\n");
    }
}



#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__MODE_I */
