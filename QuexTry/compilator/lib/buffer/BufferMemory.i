/* vim:set ft=c: -*- C++ -*- */
#ifndef QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_MEMORY_I
#define QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_MEMORY_I

#include "compilator\lib\quex/asserts"
#include "compilator\lib\buffer/asserts"
#include "compilator\lib\definitions"
#include "compilator\lib\buffer/Buffer"
#include "compilator\lib\buffer/Buffer_print.i"
#include "compilator\lib\buffer/lexatoms/LexatomLoader"
#include "compilator\lib\quex/MemoryManager"



inline void 
compilator_BufferMemory_construct(compilator_BufferMemory*  me, 
                                  compilator_lexatom_t*        Memory, 
                                  const size_t              Size,
                                  E_Ownership               Ownership,
                                  compilator_Buffer*        IncludingBuffer) 
{
    __quex_assert(E_Ownership_is_valid(Ownership));    

    if( Memory ) {
        me->_front    = Memory;
        me->_back     = &Memory[Size-1];
        me->ownership = Ownership;
        me->_front[0] = QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
        me->_back[0]  = QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
    } else {
        me->_front    = (compilator_lexatom_t*)0;
        me->_back     = me->_front;
        me->ownership = Ownership;
    }
    
    if( Ownership == E_Ownership_INCLUDING_BUFFER ) { 
        __quex_assert(0 != IncludingBuffer); 
    }
    else { 
        __quex_assert(0 == IncludingBuffer); 
        __quex_assert(me != &IncludingBuffer->_memory); 
    }

    me->including_buffer = IncludingBuffer;
}

inline void 
compilator_BufferMemory_destruct(compilator_BufferMemory* me) 
/* Does not set 'me->_front' to zero, if it is not deleted. Thus, the user
 * may detect wether it needs to be deleted or not.                           */
{
    if( me->_front ) {
        switch( me->ownership ) {
        case E_Ownership_LEXICAL_ANALYZER:
            __quex_assert(0 == me->including_buffer);
            quex::MemoryManager_free((void*)me->_front, 
                                       E_MemoryObjectType_BUFFER_MEMORY);
            break;
        case E_Ownership_INCLUDING_BUFFER:
            __quex_assert(0 != me->including_buffer);
            __quex_assert(me->_front == me->including_buffer->end(me->including_buffer));
            me->including_buffer->_memory._back = me->_back;
        default: 
            break;
        }
    }
    compilator_BufferMemory_resources_absent_mark(me);
}


inline void 
compilator_BufferMemory_resources_absent_mark(compilator_BufferMemory* me) 
/* Marks memory absent. If previously the ownership was 'E_Ownership_EXTERNAL'.
 * then the concerned memory is no longer referred by this buffer.            */
{
    /* 'me->_front == 0' prevents 'MemoryManager_free()'                      */
    me->_front = me->_back = (compilator_lexatom_t*)0;
    me->ownership        = E_Ownership_LEXICAL_ANALYZER;
    me->including_buffer = (compilator_Buffer*)0;
}

inline bool 
compilator_BufferMemory_resources_absent(compilator_BufferMemory* me) 
{
    /* Ownership is irrelevant.                                               */
    return    (me->_front == me->_back) 
           && (me->_front == (compilator_lexatom_t*)0)
           && (me->including_buffer == (compilator_Buffer*)0);
}

inline size_t          
compilator_BufferMemory_size(compilator_BufferMemory* me)
{ return (size_t)(me->_back - me->_front + 1); }

inline bool
compilator_BufferMemory_check_chunk(const compilator_lexatom_t* Front, 
                                    size_t                   Size, 
                                    const compilator_lexatom_t* EndOfFileP) 
{
    const compilator_lexatom_t* Back = &Front[Size-1];

    if( ! Front ) {
        return (Size == 0 && ! EndOfFileP) ? true : false; 
    }
    else if(   Size < 3  
            || ! EndOfFileP
            || EndOfFileP    <= Front 
            || EndOfFileP    >  Back  
            || Front[0]      != QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER    
            || Back[0]       != QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER 
            || EndOfFileP[0] != QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER ) {
        return false;
    }
    else  {
        return true;
    }
}

inline void
compilator_BufferMemory_print_this(compilator_BufferMemory* me)
{
    QUEX_DEBUG_PRINT("    memory: {\n");
    QUEX_DEBUG_PRINT1("      ownership: %s;\n", E_Ownership_NAME(me->ownership));
    QUEX_DEBUG_PRINT1("      begin:     ((%p)) (== _front);\n",       (void*)me->_front);
    QUEX_DEBUG_PRINT1("      end:       begin + %i (== _back + 1);\n", (int)(me->_back + 1 - me->_front));
    QUEX_DEBUG_PRINT("    }\n");
}



#endif /*  QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_MEMORY_I */
