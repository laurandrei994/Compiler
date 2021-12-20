/* vim:set ft=c: -*- C++ -*- */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BUFFER_MEMORY_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BUFFER_MEMORY_I

#include "lexical_analysis/lib/quex/asserts"
#include "lexical_analysis/lib/buffer/asserts"
#include "lexical_analysis/lib/definitions"
#include "lexical_analysis/lib/buffer/Buffer"
#include "lexical_analysis/lib/buffer/Buffer_print.i"
#include "lexical_analysis/lib/buffer/lexatoms/LexatomLoader"
#include "lexical_analysis/lib/quex/MemoryManager"



 void 
Calc_lexer_BufferMemory_construct(Calc_lexer_BufferMemory*  me, 
                                  Calc_lexer_lexatom_t*        Memory, 
                                  const size_t              Size,
                                  E_Ownership               Ownership,
                                  Calc_lexer_Buffer*        IncludingBuffer) 
{
    __quex_assert(E_Ownership_is_valid(Ownership));    

    if( Memory ) {
        me->_front    = Memory;
        me->_back     = &Memory[Size-1];
        me->ownership = Ownership;
        me->_front[0] = QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
        me->_back[0]  = QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
    } else {
        me->_front    = (Calc_lexer_lexatom_t*)0;
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

 void 
Calc_lexer_BufferMemory_destruct(Calc_lexer_BufferMemory* me) 
/* Does not set 'me->_front' to zero, if it is not deleted. Thus, the user
 * may detect wether it needs to be deleted or not.                           */
{
    if( me->_front ) {
        switch( me->ownership ) {
        case E_Ownership_LEXICAL_ANALYZER:
            __quex_assert(0 == me->including_buffer);
            quex_MemoryManager_free((void*)me->_front, 
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
    Calc_lexer_BufferMemory_resources_absent_mark(me);
}


 void 
Calc_lexer_BufferMemory_resources_absent_mark(Calc_lexer_BufferMemory* me) 
/* Marks memory absent. If previously the ownership was 'E_Ownership_EXTERNAL'.
 * then the concerned memory is no longer referred by this buffer.            */
{
    /* 'me->_front == 0' prevents 'MemoryManager_free()'                      */
    me->_front = me->_back = (Calc_lexer_lexatom_t*)0;
    me->ownership        = E_Ownership_LEXICAL_ANALYZER;
    me->including_buffer = (Calc_lexer_Buffer*)0;
}

 bool 
Calc_lexer_BufferMemory_resources_absent(Calc_lexer_BufferMemory* me) 
{
    /* Ownership is irrelevant.                                               */
    return    (me->_front == me->_back) 
           && (me->_front == (Calc_lexer_lexatom_t*)0)
           && (me->including_buffer == (Calc_lexer_Buffer*)0);
}

 size_t          
Calc_lexer_BufferMemory_size(Calc_lexer_BufferMemory* me)
{ return (size_t)(me->_back - me->_front + 1); }

 bool
Calc_lexer_BufferMemory_check_chunk(const Calc_lexer_lexatom_t* Front, 
                                    size_t                   Size, 
                                    const Calc_lexer_lexatom_t* EndOfFileP) 
{
    const Calc_lexer_lexatom_t* Back = &Front[Size-1];

    if( ! Front ) {
        return (Size == 0 && ! EndOfFileP) ? true : false; 
    }
    else if(   Size < 3  
            || ! EndOfFileP
            || EndOfFileP    <= Front 
            || EndOfFileP    >  Back  
            || Front[0]      != QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER    
            || Back[0]       != QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER 
            || EndOfFileP[0] != QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER ) {
        return false;
    }
    else  {
        return true;
    }
}

 void
Calc_lexer_BufferMemory_print_this(Calc_lexer_BufferMemory* me)
{
    QUEX_DEBUG_PRINT("    memory: {\n");
    QUEX_DEBUG_PRINT1("      ownership: %s;\n", E_Ownership_NAME(me->ownership));
    QUEX_DEBUG_PRINT1("      begin:     ((%p)) (== _front);\n",       (void*)me->_front);
    QUEX_DEBUG_PRINT1("      end:       begin + %i (== _back + 1);\n", (int)(me->_back + 1 - me->_front));
    QUEX_DEBUG_PRINT("    }\n");
}



#endif /*  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BUFFER_MEMORY_I */
