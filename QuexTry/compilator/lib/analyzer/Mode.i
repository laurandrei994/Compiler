/* -*- C++ -*-  vim:set syntax=cpp: 
 *
 * (C) 2004-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY              */
#ifndef QUEX_INCLUDE_GUARD_compilator__ANALYZER__MODE_I
#define QUEX_INCLUDE_GUARD_compilator__ANALYZER__MODE_I

#include "compilator\lib\definitions"



inline void
compilator_Mode_uncallable_analyzer_function(compilator* me)
{ 
    __quex_assert(0); 
    (void)me;
    return; 
}



inline void
compilator_Mode_on_entry_exit_null_function(compilator* me, const compilator_Mode* TheMode) 
{ (void)me; (void)TheMode; }

inline bool
compilator_ModeStack_construct(compilator_ModeStack* me, const size_t N)
{
    me->begin = (const compilator_Mode**)quex::MemoryManager_allocate(
                                N * sizeof(compilator_Mode*),
                                E_MemoryObjectType_MODE_STACK);
    if( ! me->begin ) {
        compilator_ModeStack_resources_absent_mark(me);
        return false;
    }
    else {
        me->end        = &me->begin[0];
        me->memory_end = &me->begin[N];
        return true;
    }
}

inline void
compilator_ModeStack_destruct(compilator_ModeStack* me)
{
    if( me->begin ) {
        quex::MemoryManager_free((void*)&me->begin[0],
                                   E_MemoryObjectType_MODE_STACK);
    }
    compilator_ModeStack_resources_absent_mark(me);
}

inline void
compilator_ModeStack_resources_absent_mark(compilator_ModeStack* me)
{
    me->begin      = (const compilator_Mode**)0;
    me->end        = (const compilator_Mode**)0;
    me->memory_end = (const compilator_Mode**)0;
}

inline bool
compilator_ModeStack_resources_absent(compilator_ModeStack* me)
{
    return    me->end        == (const compilator_Mode**)0
           && me->memory_end == (const compilator_Mode**)0;
}

inline void
compilator_ModeStack_print(compilator_ModeStack* me)
{
    const compilator_Mode** iterator = 0x0;
    if( compilator_ModeStack_resources_absent(me) ) {
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



#endif /* QUEX_INCLUDE_GUARD_compilator__ANALYZER__MODE_I */
