/* vim:set ft=c: -*- C++ -*- */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFER_MEMORY_I
#define QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFER_MEMORY_I

#include "quexProcessed/lib/quex/asserts"
#include "quexProcessed/lib/buffer/asserts"
#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/buffer/Buffer"
#include "quexProcessed/lib/buffer/Buffer_print.i"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader"
#include "quexProcessed/lib/quex/MemoryManager"



inline void 
quexProcessed_BufferMemory_construct(quexProcessed_BufferMemory*  me, 
                                  quexProcessed_lexatom_t*        Memory, 
                                  const size_t              Size,
                                  E_Ownership               Ownership,
                                  quexProcessed_Buffer*        IncludingBuffer) 
{
    __quex_assert(E_Ownership_is_valid(Ownership));    

    if( Memory ) {
        me->_front    = Memory;
        me->_back     = &Memory[Size-1];
        me->ownership = Ownership;
        me->_front[0] = QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
        me->_back[0]  = QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
    } else {
        me->_front    = (quexProcessed_lexatom_t*)0;
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
quexProcessed_BufferMemory_destruct(quexProcessed_BufferMemory* me) 
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
    quexProcessed_BufferMemory_resources_absent_mark(me);
}


inline void 
quexProcessed_BufferMemory_resources_absent_mark(quexProcessed_BufferMemory* me) 
/* Marks memory absent. If previously the ownership was 'E_Ownership_EXTERNAL'.
 * then the concerned memory is no longer referred by this buffer.            */
{
    /* 'me->_front == 0' prevents 'MemoryManager_free()'                      */
    me->_front = me->_back = (quexProcessed_lexatom_t*)0;
    me->ownership        = E_Ownership_LEXICAL_ANALYZER;
    me->including_buffer = (quexProcessed_Buffer*)0;
}

inline bool 
quexProcessed_BufferMemory_resources_absent(quexProcessed_BufferMemory* me) 
{
    /* Ownership is irrelevant.                                               */
    return    (me->_front == me->_back) 
           && (me->_front == (quexProcessed_lexatom_t*)0)
           && (me->including_buffer == (quexProcessed_Buffer*)0);
}

inline size_t          
quexProcessed_BufferMemory_size(quexProcessed_BufferMemory* me)
{ return (size_t)(me->_back - me->_front + 1); }

inline bool
quexProcessed_BufferMemory_check_chunk(const quexProcessed_lexatom_t* Front, 
                                    size_t                   Size, 
                                    const quexProcessed_lexatom_t* EndOfFileP) 
{
    const quexProcessed_lexatom_t* Back = &Front[Size-1];

    if( ! Front ) {
        return (Size == 0 && ! EndOfFileP) ? true : false; 
    }
    else if(   Size < 3  
            || ! EndOfFileP
            || EndOfFileP    <= Front 
            || EndOfFileP    >  Back  
            || Front[0]      != QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER    
            || Back[0]       != QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER 
            || EndOfFileP[0] != QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER ) {
        return false;
    }
    else  {
        return true;
    }
}

inline void
quexProcessed_BufferMemory_print_this(quexProcessed_BufferMemory* me)
{
    QUEX_DEBUG_PRINT("    memory: {\n");
    QUEX_DEBUG_PRINT1("      ownership: %s;\n", E_Ownership_NAME(me->ownership));
    QUEX_DEBUG_PRINT1("      begin:     ((%p)) (== _front);\n",       (void*)me->_front);
    QUEX_DEBUG_PRINT1("      end:       begin + %i (== _back + 1);\n", (int)(me->_back + 1 - me->_front));
    QUEX_DEBUG_PRINT("    }\n");
}



#endif /*  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BUFFER_MEMORY_I */
