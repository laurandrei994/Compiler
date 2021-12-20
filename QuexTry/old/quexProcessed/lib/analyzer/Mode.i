/* -*- C++ -*-  vim:set syntax=cpp: 
 *
 * (C) 2004-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY              */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MODE_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MODE_I

#include "quexProcessed/lib/definitions"



inline void
quexProcessed_Mode_uncallable_analyzer_function(quexProcessed* me)
{ 
    __quex_assert(0); 
    (void)me;
    return; 
}



inline void
quexProcessed_Mode_on_entry_exit_null_function(quexProcessed* me, const quexProcessed_Mode* TheMode) 
{ (void)me; (void)TheMode; }

inline bool
quexProcessed_ModeStack_construct(quexProcessed_ModeStack* me, const size_t N)
{
    me->begin = (const quexProcessed_Mode**)quex::MemoryManager_allocate(
                                N * sizeof(quexProcessed_Mode*),
                                E_MemoryObjectType_MODE_STACK);
    if( ! me->begin ) {
        quexProcessed_ModeStack_resources_absent_mark(me);
        return false;
    }
    else {
        me->end        = &me->begin[0];
        me->memory_end = &me->begin[N];
        return true;
    }
}

inline void
quexProcessed_ModeStack_destruct(quexProcessed_ModeStack* me)
{
    if( me->begin ) {
        quex::MemoryManager_free((void*)&me->begin[0],
                                   E_MemoryObjectType_MODE_STACK);
    }
    quexProcessed_ModeStack_resources_absent_mark(me);
}

inline void
quexProcessed_ModeStack_resources_absent_mark(quexProcessed_ModeStack* me)
{
    me->begin      = (const quexProcessed_Mode**)0;
    me->end        = (const quexProcessed_Mode**)0;
    me->memory_end = (const quexProcessed_Mode**)0;
}

inline bool
quexProcessed_ModeStack_resources_absent(quexProcessed_ModeStack* me)
{
    return    me->end        == (const quexProcessed_Mode**)0
           && me->memory_end == (const quexProcessed_Mode**)0;
}

inline void
quexProcessed_ModeStack_print(quexProcessed_ModeStack* me)
{
    const quexProcessed_Mode** iterator = 0x0;
    if( quexProcessed_ModeStack_resources_absent(me) ) {
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



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__MODE_I */
