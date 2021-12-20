#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__COUNTER_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__COUNTER_I

#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/analyzer/asserts"
#include "quexProcessed/lib/analyzer/Counter"



inline bool
quexProcessed_Counter_construct(quexProcessed_Counter* me)
{
       me->_line_number_at_begin   = (size_t)1;
       me->_line_number_at_end     = (size_t)1;
     me->_column_number_at_begin = (size_t)1;
     me->_column_number_at_end   = (size_t)1;

    
    return true;
}

inline void
quexProcessed_Counter_resources_absent_mark(quexProcessed_Counter* me)
{
     me->_line_number_at_begin               = (size_t)0;
     me->_line_number_at_end                 = (size_t)0;
     me->_column_number_at_begin           = (size_t)0;
     me->_column_number_at_end             = (size_t)0;
    
    
}

inline bool
quexProcessed_Counter_resources_absent(quexProcessed_Counter* me)
{
     if( me->_line_number_at_begin               != (size_t)0) return false;
     if( me->_line_number_at_end                 != (size_t)0) return false;
     if( me->_column_number_at_begin           != (size_t)0) return false;
     if( me->_column_number_at_end             != (size_t)0) return false;
    
    
    return true;
}


inline void 
quexProcessed_Counter_print_this(quexProcessed_Counter* me)
{
    

    QUEX_DEBUG_PRINT("  counter: ");
    if( quexProcessed_Counter_resources_absent(me) ) {
        QUEX_DEBUG_PRINT("<unitialized>\n");
        return;
    }
    QUEX_DEBUG_PRINT("{\n");


    QUEX_DEBUG_PRINT1("    _line_number_at_begin:   %i;\n", (int)me->_line_number_at_begin);
    QUEX_DEBUG_PRINT1("    _line_number_at_end:     %i;\n", (int)me->_line_number_at_end);


    QUEX_DEBUG_PRINT1("    _column_number_at_begin: %i;\n", (int)me->_column_number_at_begin);
    QUEX_DEBUG_PRINT1("    _column_number_at_end:   %i;\n", (int)me->_column_number_at_end);


    QUEX_DEBUG_PRINT("  }\n");
}




#ifdef QUEX_OPTION_ASSERTS
inline void
quexProcessed_Counter_assert_consistency(quexProcessed_Counter* me)
{

    /* The line number can never decrease.                                   */ 
    __quex_assert(me->_line_number_at_begin <= me->_line_number_at_end);            
    /* Line number remained the same => column number *must* have increased. */ 
    /* There is not pattern of a length less than 1                          */ 
    if(me->_line_number_at_begin == me->_line_number_at_end ) {                     
        __quex_assert(me->_column_number_at_begin < me->_column_number_at_end);     
    }                                                                                   


    /* If only column numbers are counted, then no assumptions can be made 
     * about increase or decrease. If a newline appears, for example, the 
     * column number may decrease.                                            */
}
#endif



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__COUNTER_I */

