
#include "quexProcessed/quexProcessed"
#include "quexProcessed/lib/analyzer/C-adaptions.h"
#include "quexProcessed/lib/implementations.i"



quexProcessed_Mode quexProcessed_ONE_AND_ONLY = {
    /* name              */ "ONE_AND_ONLY",

    /* on_entry          */ quexProcessed_Mode_on_entry_exit_null_function,
    /* on_exit           */ quexProcessed_Mode_on_entry_exit_null_function,
#   if      defined(QUEX_OPTION_ASSERTS)
    /* has_base          */ quexProcessed_ONE_AND_ONLY_has_base,
    /* has_entry_from    */ quexProcessed_ONE_AND_ONLY_has_entry_from,
    /* has_exit_to       */ quexProcessed_ONE_AND_ONLY_has_exit_to,
#   endif
    {
    /* on_buffer_before_change */ quexProcessed_ONE_AND_ONLY_on_buffer_before_change,
    /* on_buffer_overflow      */ quexProcessed_ONE_AND_ONLY_on_buffer_overflow,
    /* aux                     */ (void*)0,
    },

    /* analyzer_function */ quexProcessed_ONE_AND_ONLY_analyzer_function
};

#   ifdef     self
#       undef self
#   endif
#   define self (*((quexProcessed*)me))
#define LexemeNull  (&quexProcessed_LexemeNull)
#define RETURN      return

void
quexProcessed_ONE_AND_ONLY_on_entry(quexProcessed* me, const quexProcessed_Mode* FromMode) {
    (void)me;
    (void)FromMode;
#   ifdef QUEX_OPTION_ASSERTS
    quexProcessed_ONE_AND_ONLY.has_entry_from(FromMode);
#   endif

}

void
quexProcessed_ONE_AND_ONLY_on_exit(quexProcessed* me, const quexProcessed_Mode* ToMode)  {
    (void)me;
    (void)ToMode;
#   ifdef QUEX_OPTION_ASSERTS
    quexProcessed_ONE_AND_ONLY.has_exit_to(ToMode);
#   endif

}



#ifdef QUEX_OPTION_ASSERTS
bool
quexProcessed_ONE_AND_ONLY_has_base(const quexProcessed_Mode* Mode) {
    (void)Mode;
    return false;
}

bool
quexProcessed_ONE_AND_ONLY_has_entry_from(const quexProcessed_Mode* Mode) {
    (void)Mode;
return false;
}

bool
quexProcessed_ONE_AND_ONLY_has_exit_to(const quexProcessed_Mode* Mode) {
    (void)Mode;
return false;
}
#endif    

void
quexProcessed_ONE_AND_ONLY_on_buffer_before_change(void* me /* 'aux' -> 'self' via 'me' */)
{
    const quexProcessed_lexatom_t* BufferBegin = self.buffer.begin(&self.buffer);
    const quexProcessed_lexatom_t* BufferEnd   = self.buffer.end(&self.buffer);
    (void)me; (void)BufferBegin; (void)BufferEnd;

}

inline void
quexProcessed_Buffer_print_overflow_message(quexProcessed_Buffer* buffer); 

void
quexProcessed_ONE_AND_ONLY_on_buffer_overflow(void*  me /* 'aux' -> 'self' via 'me' */)
{
    const quexProcessed_lexatom_t* LexemeBegin = self.buffer._lexeme_start_p;
    const quexProcessed_lexatom_t* LexemeEnd   = self.buffer._read_p;
    const size_t             BufferSize  = (size_t)(self.buffer.size(&self.buffer)); 


    /* Try to double the size of the buffer, by default.                      */
    if( ! quexProcessed_Buffer_nested_negotiate_extend(&self.buffer, 2.0) ) {
        quexProcessed_MF_error_code_set_if_first(&self, E_Error_Buffer_Overflow_LexemeTooLong);
        quexProcessed_Buffer_print_overflow_message(&self.buffer);
    }

    (void)me; (void)LexemeBegin; (void)LexemeEnd; (void)BufferSize;
}
#undef self
#undef LexemeNull
#undef RETURN

static void
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme(quexProcessed* me, quexProcessed_lexatom_t* LexemeBegin, quexProcessed_lexatom_t* LexemeEnd)
{
#   define self (*me)
/*  'QUEX_GOTO_STATE' requires 'QUEX_LABEL_STATE_ROUTER' */
#   define QUEX_LABEL_STATE_ROUTER _18
    quexProcessed_lexatom_t    input                   = (quexProcessed_lexatom_t)(0x00);
    quexProcessed_goto_label_t target_state_else_index = (quexProcessed_goto_label_t)-1;
    quexProcessed_goto_label_t target_state_index      = (quexProcessed_goto_label_t)-1;
    quexProcessed_lexatom_t*   count_reference_p       = (quexProcessed_lexatom_t*)0x0;
    (void)me;
    me->counter._column_number_at_begin = me->counter._column_number_at_end;
    me->counter._line_number_at_begin = me->counter._line_number_at_end;
    /* Allow LexemeBegin == LexemeEnd (e.g. END_OF_STREAM)
     * => Caller does not need to check
     * BUT, if so quit immediately after 'shift values'.
     */
    __quex_assert(LexemeBegin <= LexemeEnd);
    if( LexemeBegin == LexemeEnd ) {
        return;
    }
    me->buffer._read_p = LexemeBegin;

    /* (241 from BEFORE_ENTRY)  */
     count_reference_p = (me->buffer._read_p);

 count_reference_p = (me->buffer._read_p);

    input = *(me->buffer._read_p);

_13:
    __quex_debug_init_state("Counter:ONE_AND_ONLY", 241);
if     ( input >= 0xB )  goto _4;
else if( input == 0xA )  goto _2;
else if( input == 0x9 )  goto _3;
else                     goto _4;


    __quex_assert_no_passage();
_8:
    /* (241 from 246)  */
    goto _13;


    __quex_assert_no_passage();
_5:
    /* (DROP_OUT from 242)  */
goto _9;

    __quex_debug("%s" " Drop-Out Catcher\n");


    __quex_assert_no_passage();
_6:
    /* (DROP_OUT from 243)  */
goto _10;


    __quex_assert_no_passage();
_7:
    /* (DROP_OUT from 244)  */
goto _11;


    __quex_assert_no_passage();
_2:
    /* (242 from 241)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(242);
goto _5;


    __quex_assert_no_passage();
_3:
    /* (243 from 241)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(243);
goto _6;


    __quex_assert_no_passage();
_4:
    /* (244 from 241)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(244);
goto _7;

    /* (*) Terminal states _______________________________________________________
     *
     * States that implement actions of the 'winner patterns.                     */
_12:
    __quex_debug("* TERMINAL <LOOP EXIT>\n");
    --(me->buffer._read_p);

me->counter._column_number_at_end += ((size_t)(((me->buffer._read_p) - count_reference_p))); __quex_debug_counter();

goto _0;

_9:
    __quex_debug("* TERMINAL <LOOP TERMINAL 59>\n");
me->counter._line_number_at_end += ((size_t)1); __quex_debug_counter();

     (me->counter._column_number_at_end) = (size_t)1;

 count_reference_p = (me->buffer._read_p);

if( me->buffer._read_p != LexemeEnd ) goto _8;

goto _0;

_10:
    __quex_debug("* TERMINAL <LOOP TERMINAL 60>\n");
me->counter._column_number_at_end += ((size_t)(((me->buffer._read_p) - count_reference_p - 1))); __quex_debug_counter();


self.counter._column_number_at_end -= 1;
self.counter._column_number_at_end &= ~ ((size_t)0x3);
self.counter._column_number_at_end += 4 + 1;


 count_reference_p = (me->buffer._read_p);

if( me->buffer._read_p != LexemeEnd ) goto _8;

goto _0;

_11:
    __quex_debug("* TERMINAL <LOOP TERMINAL 61>\n");
if( me->buffer._read_p != LexemeEnd ) goto _8;

me->counter._column_number_at_end += ((size_t)(((me->buffer._read_p) - count_reference_p))); __quex_debug_counter();

goto _0;

if(0) {
    /* Avoid unreferenced labels. */
    goto _12;
    goto _9;
    goto _10;
    goto _11;
}
_20: /* TERMINAL: BAD_LEXATOM */
;
_19: /* TERMINAL: FAILURE     */
goto _0;
_0:
/* Assert: lexeme in codec's character boundaries. */

     __quex_assert(me->buffer._read_p == LexemeEnd);
    return;
    __quex_assert_no_passage();
    goto _18; /* prevent unused label */
_18:

#undef self


#undef QUEX_LABEL_STATE_ROUTER


     goto _18; /* in QUEX_GOTO_STATE       */
     goto _20; /* to BAD_LEXATOM           */

    /* Avoid compiler warning: 'Unused labels' */

    goto _19;
    (void)target_state_index;
    (void)target_state_else_index;
}

#include "quexProcessed/lib/buffer/Buffer"
#include "quexProcessed/lib/token/TokenQueue"

#ifdef    CONTINUE
#   undef CONTINUE
#endif
#define   CONTINUE do { goto _180; } while(0)

#ifdef    RETURN
#   undef RETURN
#endif
#define   RETURN   do { goto _179; } while(0)

void  
quexProcessed_ONE_AND_ONLY_analyzer_function(quexProcessed* me) 
{
    /* NOTE: Different modes correspond to different analyzer functions. The 
     *       analyzer functions are all located inside the main class as static
     *       functions. That means, they are something like 'globals'. They 
     *       receive a pointer to the lexical analyzer, since static members do
     *       not have access to the 'this' pointer.                          */
#   ifdef     self
#       undef self
#   endif
#   define self (*((quexProcessed*)me))
#   define ONE_AND_ONLY    (&quexProcessed_ONE_AND_ONLY)
/*  'QUEX_GOTO_STATE' requires 'QUEX_LABEL_STATE_ROUTER' */
#   define QUEX_LABEL_STATE_ROUTER _183

    /* Lexeme setup: 
     *
     * There is a temporary zero stored at the end of each lexeme, if the action 
     * references to the 'Lexeme'. 'LexemeNull' provides a reference to an empty
     * zero terminated string.                                                    */
#if defined(QUEX_OPTION_ASSERTS)
#   define Lexeme       quexProcessed_access_Lexeme((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#   define LexemeBegin  quexProcessed_access_LexemeBegin((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#   define LexemeL      quexProcessed_access_LexemeL((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#   define LexemeEnd    quexProcessed_access_LexemeEnd((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#else
#   define Lexeme       (me->buffer._lexeme_start_p)
#   define LexemeBegin  Lexeme
#   define LexemeL      ((size_t)(me->buffer._read_p - me->buffer._lexeme_start_p))
#   define LexemeEnd    me->buffer._read_p
#endif

#define LexemeNull      (&quexProcessed_LexemeNull)
    E_LoadResult         load_result             = E_LoadResult_VOID;
    quexProcessed_lexatom_t**  position                = 0x0;
    quexProcessed_goto_label_t target_state_else_index = (quexProcessed_goto_label_t)-1;
    const size_t         PositionRegisterN       = (size_t)0;
    quexProcessed_lexatom_t    input                   = (quexProcessed_lexatom_t)(0x00);
    quexProcessed_goto_label_t target_state_index      = (quexProcessed_goto_label_t)-1;

    /* Post context positions do not have to be reset or initialized. If a state
     * is reached which is associated with 'end of post context' it is clear what
     * post context is meant. This results from the ways the state machine is 
     * constructed. Post context position's live cycle:
     *
     * (1)   unitialized (don't care)
     * (1.b) on buffer reload it may, or may not be adapted (don't care)
     * (2)   when a post context begin state is passed, then it is **SET** (now: take care)
     * (2.b) on buffer reload it **is adapted**.
     * (3)   when a terminal state of the post context is reached (which can only be reached
     *       for that particular post context), then the post context position is used
     *       to reset the input position.                                              */
#   if defined(QUEX_OPTION_ASSERTS)
    me->DEBUG_analyzer_function_at_entry = me->current_analyzer_function;
#   endif
_182:
    me->buffer._lexeme_start_p = me->buffer._read_p;
    QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
_16:
    /* (311 from BEFORE_ENTRY) (311 from RELOAD_FORWARD)  */

    input = *(me->buffer._read_p);


    __quex_debug_init_state("Core:ONE_AND_ONLY", 311);
switch( input ) {
case 0x0: goto _59;
case 0x9: case 0xA: 
case 0xD: 
case 0x20: goto _23;
case 0x30: case 0x31: case 0x32: case 0x33: case 0x34: case 0x35: case 0x36: case 0x37: 
case 0x38: case 0x39: goto _24;
case 0x3B: goto _25;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: goto _18;
case 0x64: goto _20;
case 0x65: goto _21;
case 0x66: case 0x67: case 0x68: goto _18;
case 0x69: goto _26;
case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: goto _18;
case 0x73: goto _19;
case 0x74: case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
case 0x7B: goto _17;
case 0x7D: goto _22;
default: goto _47;
}


    __quex_assert_no_passage();
_49:
    /* (DROP_OUT from 329) (DROP_OUT from 336) (DROP_OUT from 340) (DROP_OUT from 315) (DROP_OUT from 327) (DROP_OUT from 330) (DROP_OUT from 324) (DROP_OUT from 321) (DROP_OUT from 334) (DROP_OUT from 316) (DROP_OUT from 331) (DROP_OUT from 338) (DROP_OUT from 313) (DROP_OUT from 325) (DROP_OUT from 322) (DROP_OUT from 335) (DROP_OUT from 332) (DROP_OUT from 339) (DROP_OUT from 314) (DROP_OUT from 326)  */

goto _10;
_116:
    __quex_debug("%s" " Drop-Out Catcher\n");


    __quex_assert_no_passage();
_48:
    /* (DROP_OUT from 312)  */
goto _7;


    __quex_assert_no_passage();
_50:
    /* (DROP_OUT from 317)  */
goto _8;


    __quex_assert_no_passage();
_51:
    /* (DROP_OUT from 318)  */
goto _0;


    __quex_assert_no_passage();
_52:
    /* (DROP_OUT from 319)  */
goto _9;


    __quex_assert_no_passage();
_53:
    /* (DROP_OUT from 320)  */
goto _6;


    __quex_assert_no_passage();
_54:
    /* (DROP_OUT from 323)  */
goto _2;


    __quex_assert_no_passage();
_55:
    /* (DROP_OUT from 328)  */
goto _5;


    __quex_assert_no_passage();
_56:
    /* (DROP_OUT from 333)  */
goto _3;


    __quex_assert_no_passage();
_57:
    /* (DROP_OUT from 337)  */
goto _4;


    __quex_assert_no_passage();
_58:
    /* (DROP_OUT from 341)  */
goto _1;


    __quex_assert_no_passage();
_47:
    /* (DROP_OUT from 311)  */
    me->buffer._read_p = me->buffer._lexeme_start_p + 1;
goto _14;
    goto _116;


    __quex_assert_no_passage();
_25:
    /* (320 from 311)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(320);
goto _53;


    __quex_assert_no_passage();
_72:
    /* (321 from RELOAD_FORWARD)  */
_120:
    input = *(me->buffer._read_p);


    __quex_debug_state(321);
switch( input ) {
case 0x0: goto _73;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: goto _18;
case 0x6E: goto _27;
case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_26:
    /* (321 from 311)  */
    ++(me->buffer._read_p);

    goto _120;


    __quex_assert_no_passage();
_27:
    /* (322 from 321)  */
    ++(me->buffer._read_p);

_122:
    input = *(me->buffer._read_p);


    __quex_debug_state(322);
switch( input ) {
case 0x0: goto _75;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _18;
case 0x74: goto _28;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_74:
    /* (322 from RELOAD_FORWARD)  */
    goto _122;


    __quex_assert_no_passage();
_28:
    /* (323 from 322)  */
    ++(me->buffer._read_p);

_124:
    input = *(me->buffer._read_p);


    __quex_debug_state(323);
switch( input ) {
case 0x0: goto _77;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _54;
}


    __quex_assert_no_passage();
_76:
    /* (323 from RELOAD_FORWARD)  */
    goto _124;


    __quex_assert_no_passage();
_78:
    /* (324 from RELOAD_FORWARD)  */
_126:
    input = *(me->buffer._read_p);


    __quex_debug_state(324);
switch( input ) {
case 0x0: goto _79;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: goto _18;
case 0x70: goto _30;
case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_29:
    /* (324 from 316)  */
    ++(me->buffer._read_p);

    goto _126;


    __quex_assert_no_passage();
_30:
    /* (325 from 324)  */
    ++(me->buffer._read_p);

_128:
    input = *(me->buffer._read_p);


    __quex_debug_state(325);
switch( input ) {
case 0x0: goto _81;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: goto _18;
case 0x65: goto _31;
case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_80:
    /* (325 from RELOAD_FORWARD)  */
    goto _128;


    __quex_assert_no_passage();
_82:
    /* (326 from RELOAD_FORWARD)  */
_130:
    input = *(me->buffer._read_p);


    __quex_debug_state(326);
switch( input ) {
case 0x0: goto _83;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: goto _18;
case 0x63: goto _32;
case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_31:
    /* (326 from 325)  */
    ++(me->buffer._read_p);

    goto _130;


    __quex_assert_no_passage();
_84:
    /* (327 from RELOAD_FORWARD)  */
_132:
    input = *(me->buffer._read_p);


    __quex_debug_state(327);
switch( input ) {
case 0x0: goto _85;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _18;
case 0x74: goto _33;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_32:
    /* (327 from 326)  */
    ++(me->buffer._read_p);

    goto _132;


    __quex_assert_no_passage();
_33:
    /* (328 from 327)  */
    ++(me->buffer._read_p);

_134:
    input = *(me->buffer._read_p);


    __quex_debug_state(328);
switch( input ) {
case 0x0: goto _87;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _55;
}


    __quex_assert_no_passage();
_86:
    /* (328 from RELOAD_FORWARD)  */
    goto _134;


    __quex_assert_no_passage();
_88:
    /* (329 from RELOAD_FORWARD)  */
_136:
    input = *(me->buffer._read_p);


    __quex_debug_state(329);
switch( input ) {
case 0x0: goto _89;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: goto _18;
case 0x75: goto _35;
case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_34:
    /* (329 from 315)  */
    ++(me->buffer._read_p);

    goto _136;


    __quex_assert_no_passage();
_35:
    /* (330 from 329)  */
    ++(me->buffer._read_p);

_138:
    input = *(me->buffer._read_p);


    __quex_debug_state(330);
switch( input ) {
case 0x0: goto _91;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: goto _18;
case 0x62: goto _36;
case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_90:
    /* (330 from RELOAD_FORWARD)  */
    goto _138;


    __quex_assert_no_passage();
_36:
    /* (331 from 330)  */
    ++(me->buffer._read_p);

_140:
    input = *(me->buffer._read_p);


    __quex_debug_state(331);
switch( input ) {
case 0x0: goto _93;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: goto _18;
case 0x6C: goto _37;
case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_92:
    /* (331 from RELOAD_FORWARD)  */
    goto _140;


    __quex_assert_no_passage();
_94:
    /* (332 from RELOAD_FORWARD)  */
_142:
    input = *(me->buffer._read_p);


    __quex_debug_state(332);
switch( input ) {
case 0x0: goto _95;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: goto _18;
case 0x65: goto _38;
case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_37:
    /* (332 from 331)  */
    ++(me->buffer._read_p);

    goto _142;


    __quex_assert_no_passage();
_38:
    /* (333 from 332)  */
    ++(me->buffer._read_p);

_144:
    input = *(me->buffer._read_p);


    __quex_debug_state(333);
switch( input ) {
case 0x0: goto _97;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _56;
}


    __quex_assert_no_passage();
_96:
    /* (333 from RELOAD_FORWARD)  */
    goto _144;


    __quex_assert_no_passage();
_98:
    /* (334 from RELOAD_FORWARD)  */
_146:
    input = *(me->buffer._read_p);


    __quex_debug_state(334);
switch( input ) {
case 0x0: goto _99;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: goto _18;
case 0x72: goto _43;
case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_39:
    /* (334 from 314)  */
    ++(me->buffer._read_p);

    goto _146;


    __quex_assert_no_passage();
_100:
    /* (335 from RELOAD_FORWARD)  */
_148:
    input = *(me->buffer._read_p);


    __quex_debug_state(335);
switch( input ) {
case 0x0: goto _101;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: goto _18;
case 0x6E: goto _41;
case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_40:
    /* (335 from 314)  */
    ++(me->buffer._read_p);

    goto _148;


    __quex_assert_no_passage();
_41:
    /* (336 from 335)  */
    ++(me->buffer._read_p);

_150:
    input = *(me->buffer._read_p);


    __quex_debug_state(336);
switch( input ) {
case 0x0: goto _103;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: goto _18;
case 0x64: goto _42;
case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_102:
    /* (336 from RELOAD_FORWARD)  */
    goto _150;


    __quex_assert_no_passage();
_104:
    /* (337 from RELOAD_FORWARD)  */
_152:
    input = *(me->buffer._read_p);


    __quex_debug_state(337);
switch( input ) {
case 0x0: goto _105;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _57;
}


    __quex_assert_no_passage();
_42:
    /* (337 from 336)  */
    ++(me->buffer._read_p);

    goto _152;


    __quex_assert_no_passage();
_43:
    /* (338 from 334)  */
    ++(me->buffer._read_p);

_154:
    input = *(me->buffer._read_p);


    __quex_debug_state(338);
switch( input ) {
case 0x0: goto _107;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: goto _18;
case 0x75: goto _44;
case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_106:
    /* (338 from RELOAD_FORWARD)  */
    goto _154;


    __quex_assert_no_passage();
_44:
    /* (339 from 338)  */
    ++(me->buffer._read_p);

_156:
    input = *(me->buffer._read_p);


    __quex_debug_state(339);
switch( input ) {
case 0x0: goto _109;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: goto _18;
case 0x63: goto _45;
case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_108:
    /* (339 from RELOAD_FORWARD)  */
    goto _156;


    __quex_assert_no_passage();
_110:
    /* (340 from RELOAD_FORWARD)  */
_158:
    input = *(me->buffer._read_p);


    __quex_debug_state(340);
switch( input ) {
case 0x0: goto _111;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _18;
case 0x74: goto _46;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_45:
    /* (340 from 339)  */
    ++(me->buffer._read_p);

    goto _158;


    __quex_assert_no_passage();
_46:
    /* (341 from 340)  */
    ++(me->buffer._read_p);

_160:
    input = *(me->buffer._read_p);


    __quex_debug_state(341);
switch( input ) {
case 0x0: goto _113;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _58;
}


    __quex_assert_no_passage();
_112:
    /* (341 from RELOAD_FORWARD)  */
    goto _160;


    __quex_assert_no_passage();
_17:
    /* (312 from 311)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(312);
goto _48;


    __quex_assert_no_passage();
_18:
    /* (313 from 315) (313 from 332) (313 from 321) (313 from 335) (313 from 316) (313 from 341) (313 from 330) (313 from 336) (313 from 325) (313 from 314) (313 from 339) (313 from 334) (313 from 323) (313 from 340) (313 from 329) (313 from 324) (313 from 313) (313 from 338) (313 from 327) (313 from 333) (313 from 322) (313 from 311) (313 from 328) (313 from 331) (313 from 337) (313 from 326)  */

    ++(me->buffer._read_p);

_164:
    input = *(me->buffer._read_p);


    __quex_debug_state(313);
switch( input ) {
case 0x0: goto _61;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_60:
    /* (313 from RELOAD_FORWARD)  */
    goto _164;


    __quex_assert_no_passage();
_62:
    /* (314 from RELOAD_FORWARD)  */
_166:
    input = *(me->buffer._read_p);


    __quex_debug_state(314);
switch( input ) {
case 0x0: goto _63;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: goto _18;
case 0x65: goto _40;
case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _18;
case 0x74: goto _39;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_19:
    /* (314 from 311)  */
    ++(me->buffer._read_p);

    goto _166;


    __quex_assert_no_passage();
_64:
    /* (315 from RELOAD_FORWARD)  */
_168:
    input = *(me->buffer._read_p);


    __quex_debug_state(315);
switch( input ) {
case 0x0: goto _65;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: goto _18;
case 0x6F: goto _34;
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_20:
    /* (315 from 311)  */
    ++(me->buffer._read_p);

    goto _168;


    __quex_assert_no_passage();
_66:
    /* (316 from RELOAD_FORWARD)  */
_170:
    input = *(me->buffer._read_p);


    __quex_debug_state(316);
switch( input ) {
case 0x0: goto _67;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: goto _18;
case 0x78: goto _29;
case 0x79: case 0x7A: goto _18;
default: goto _49;
}


    __quex_assert_no_passage();
_21:
    /* (316 from 311)  */
    ++(me->buffer._read_p);

    goto _170;


    __quex_assert_no_passage();
_22:
    /* (317 from 311)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(317);
goto _50;


    __quex_assert_no_passage();
_23:
    /* (318 from 311) (318 from 318)  */

    ++(me->buffer._read_p);

_174:
    input = *(me->buffer._read_p);


    __quex_debug_state(318);
switch( input ) {
case 0x0: goto _69;
case 0x9: case 0xA: 
case 0xD: 
case 0x20: goto _23;
default: goto _51;
}


    __quex_assert_no_passage();
_68:
    /* (318 from RELOAD_FORWARD)  */
    goto _174;


    __quex_assert_no_passage();
_24:
    /* (319 from 319) (319 from 311)  */

    ++(me->buffer._read_p);

_177:
    input = *(me->buffer._read_p);


    __quex_debug_state(319);
if     ( input >= 0x3A )  goto _52;
else if( input >= 0x30 )  goto _24;
else if( input >= 0x1 )   goto _52;
else                      goto _71;


    __quex_assert_no_passage();
_70:
    /* (319 from RELOAD_FORWARD)  */
    goto _177;

    /* (*) Terminal states _______________________________________________________
     *
     * States that implement actions of the 'winner patterns.                     */
_11:
    __quex_debug("* TERMINAL BAD_LEXATOM\n");
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme((quexProcessed*)me, LexemeBegin, LexemeEnd);

{
#define BadLexatom ((me->buffer._read_p > me->buffer._memory._front && me->buffer._read_p <= me->buffer.input.end_p) ? (me->buffer._read_p[-1]) : (quexProcessed_lexatom_t)-1)
self.error_code_set_if_first(E_Error_OnBadLexatom);
self.error_code_set_if_first(E_Error_NoHandler_OnBadLexatom);
self.send(QUEX_TKN_TERMINATION);
return;;
#undef BadLexatom

}
    /* Bad lexatom detection FORCES a return from the lexical analyzer, so that no
     * tokens can be filled after the termination token.
     */
return;
_12:
    __quex_debug("* TERMINAL LOAD_FAILURE\n");
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme((quexProcessed*)me, LexemeBegin, LexemeEnd);

{
self.error_code_set_if_first(E_Error_OnLoadFailure);
self.error_code_set_if_first(E_Error_NoHandler_OnLoadFailure);
self.send(QUEX_TKN_TERMINATION);
return;;

}
    /* Load failure FORCES a return from the lexical analyzer, so that no
     * tokens can be filled after the termination token.
     */
return;
_13:
    __quex_debug("* TERMINAL END_OF_STREAM\n");
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme((quexProcessed*)me, LexemeBegin, LexemeEnd);

{

#   line 7 "quexExample.qx"
self.send(QUEX_TKN_TERMINATION);
return;

#   line 1409 "quexProcessed/quexProcessed.cpp"

}
    /* End of Stream FORCES a return from the lexical analyzer, so that no
     * tokens can be filled after the termination token.
     */
return;
_14:
    __quex_debug("* TERMINAL FAILURE\n");
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme((quexProcessed*)me, LexemeBegin, LexemeEnd);

{
self.error_code_set_if_first(E_Error_NoHandler_OnFailure);
self.send(QUEX_TKN_TERMINATION);
return;;

}
return;
_15:
    __quex_debug("* TERMINAL SKIP_RANGE_OPEN\n");
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme((quexProcessed*)me, LexemeBegin, LexemeEnd);

{
#define Counter counter
self.error_code_set_if_first(E_Error_OnSkipRangeOpen);
self.error_code_set_if_first(E_Error_NoHandler_OnSkipRangeOpen);
self.send(QUEX_TKN_TERMINATION);
return;;

}
    /* End of Stream appeared, while scanning for end of skip-range.
     */
return;
_0:
    __quex_debug("* TERMINAL [ \\t\\r\\n]+\n");
quexProcessed_ONE_AND_ONLY_counter_on_arbitrary_lexeme((quexProcessed*)me, LexemeBegin, LexemeEnd);

{

#   line 9 "quexExample.qx"
 
#   line 1450 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_1:
    __quex_debug("* TERMINAL \"struct\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)6); __quex_debug_counter();

{

#   line 10 "quexExample.qx"
self.send(QUEX_TKN_STRUCT);
return;

#   line 1468 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_2:
    __quex_debug("* TERMINAL \"int\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)3); __quex_debug_counter();

{

#   line 11 "quexExample.qx"
self.send(QUEX_TKN_TYPE_INT);
return;

#   line 1486 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_3:
    __quex_debug("* TERMINAL \"double\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)6); __quex_debug_counter();

{

#   line 12 "quexExample.qx"
self.send(QUEX_TKN_TYPE_DOUBLE);
return;

#   line 1504 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_4:
    __quex_debug("* TERMINAL \"send\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)4); __quex_debug_counter();

{

#   line 13 "quexExample.qx"
self.send(QUEX_TKN_SEND);
return;

#   line 1522 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_5:
    __quex_debug("* TERMINAL \"expect\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)6); __quex_debug_counter();

{

#   line 14 "quexExample.qx"
self.send(QUEX_TKN_EXPECT);
return;

#   line 1540 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_6:
    __quex_debug("* TERMINAL \";\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 15 "quexExample.qx"
self.send(QUEX_TKN_SEMICOLON);
return;

#   line 1558 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_7:
    __quex_debug("* TERMINAL \"{\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 16 "quexExample.qx"
self.send(QUEX_TKN_BRACKET_OPEN);
return;

#   line 1576 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_8:
    __quex_debug("* TERMINAL \"}\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 17 "quexExample.qx"
self.send(QUEX_TKN_BRACKET_CLOSE);
return;

#   line 1594 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_9:
    __quex_debug("* TERMINAL [0-9]+\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)((size_t)(me->buffer._read_p - me->buffer._lexeme_start_p))); __quex_debug_counter();

QUEX_quexProcessed_LEXEME_TERMINATING_ZERO_SET(&me->buffer);
{

#   line 18 "quexExample.qx"
self.token_p()->number = atoi((char*)Lexeme);
self.send(QUEX_TKN_NUMBER);

return;

#   line 1615 "quexProcessed/quexProcessed.cpp"

}
RETURN;
_10:
    __quex_debug("* TERMINAL [_a-zA-Z]+\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)((size_t)(me->buffer._read_p - me->buffer._lexeme_start_p))); __quex_debug_counter();

{

#   line 19 "quexExample.qx"
self.send_text(QUEX_TKN_IDENTIFIER, me->buffer._lexeme_start_p, me->buffer._read_p);
return;

#   line 1633 "quexProcessed/quexProcessed.cpp"

}
RETURN;
if(0) {
    /* Avoid unreferenced labels. */
    goto _11;
    goto _12;
    goto _13;
    goto _14;
    goto _15;
    goto _0;
    goto _1;
    goto _2;
    goto _3;
    goto _4;
    goto _5;
    goto _6;
    goto _7;
    goto _8;
    goto _9;
    goto _10;
}
    __quex_assert_no_passage();
    goto _183; /* prevent unused label */
_183:
switch( target_state_index ) {
case 13: {
goto _13;}
case 16: {
goto _16;}
case 49: {
goto _49;}
case 51: {
goto _51;}
case 52: {
goto _52;}
case 54: {
goto _54;}
case 55: {
goto _55;}
case 56: {
goto _56;}
case 57: {
goto _57;}
case 58: {
goto _58;}
case 60: {
goto _60;}
case 62: {
goto _62;}
case 64: {
goto _64;}
case 66: {
goto _66;}
case 68: {
goto _68;}
case 70: {
goto _70;}
case 72: {
goto _72;}
case 74: {
goto _74;}
case 76: {
goto _76;}
case 78: {
goto _78;}
case 80: {
goto _80;}
case 82: {
goto _82;}
case 84: {
goto _84;}
case 86: {
goto _86;}
case 88: {
goto _88;}
case 90: {
goto _90;}
case 92: {
goto _92;}
case 94: {
goto _94;}
case 96: {
goto _96;}
case 98: {
goto _98;}
case 100: {
goto _100;}
case 102: {
goto _102;}
case 104: {
goto _104;}
case 106: {
goto _106;}
case 108: {
goto _108;}
case 110: {
goto _110;}
case 112: {
goto _112;}
default: {
goto _112;}
}


    __quex_assert_no_passage();
_63:
    /* (RELOAD_FORWARD from 314)  */
    target_state_index = 62; target_state_else_index = 49;

_178:

    __quex_debug3("RELOAD_FORWARD: success->%i; failure->%i", 
                  (int)target_state_index, (int)target_state_else_index);
    __quex_assert(*(me->buffer._read_p) == QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);
    
    __quex_debug_reload_before();                 
    /* Callbacks: 'on_buffer_before_change()' and 'on_buffer_overflow()'
     * are called during load process upon occurrence.                        */
    load_result = quexProcessed_Buffer_load_forward(&me->buffer, (quexProcessed_lexatom_t**)position, PositionRegisterN);
    __quex_debug_reload_after(load_result);

    switch( load_result ) {
    case E_LoadResult_DONE: {
        /* FallbackN must be maintained at any cost!                          */
        __quex_assert(   ! me->buffer.input.lexatom_index_begin
                      || ! me->buffer._lexeme_start_p
                      ||   me->buffer._lexeme_start_p - me->buffer.content_begin(&me->buffer) >= me->buffer._fallback_n);
        __quex_assert(   ! me->buffer.input.lexatom_index_begin
                      || ! me->buffer._read_p
                      ||   me->buffer._read_p        - me->buffer.content_begin(&me->buffer) >= me->buffer._fallback_n);
        { target_state_index = target_state_index; goto QUEX_LABEL_STATE_ROUTER; }      
    }
    case E_LoadResult_NO_MORE_DATA:   { target_state_index = target_state_else_index; goto QUEX_LABEL_STATE_ROUTER; } 
    case E_LoadResult_ENCODING_ERROR: goto _11;
    case E_LoadResult_OVERFLOW:       quexProcessed_MF_error_code_set_if_first(me, E_Error_Buffer_Overflow_LexemeTooLong); RETURN;
    default:                          __quex_assert(false);
    }


    __quex_assert_no_passage();
_59:
    /* (RELOAD_FORWARD from 311)  */
    target_state_index = 16; target_state_else_index = 13;

    goto _178;


    __quex_assert_no_passage();
_61:
    /* (RELOAD_FORWARD from 313)  */
    target_state_index = 60; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_65:
    /* (RELOAD_FORWARD from 315)  */
    target_state_index = 64; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_67:
    /* (RELOAD_FORWARD from 316)  */
    target_state_index = 66; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_69:
    /* (RELOAD_FORWARD from 318)  */
    target_state_index = 68; target_state_else_index = 51;

    goto _178;


    __quex_assert_no_passage();
_71:
    /* (RELOAD_FORWARD from 319)  */
    target_state_index = 70; target_state_else_index = 52;

    goto _178;


    __quex_assert_no_passage();
_73:
    /* (RELOAD_FORWARD from 321)  */
    target_state_index = 72; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_75:
    /* (RELOAD_FORWARD from 322)  */
    target_state_index = 74; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_77:
    /* (RELOAD_FORWARD from 323)  */
    target_state_index = 76; target_state_else_index = 54;

    goto _178;


    __quex_assert_no_passage();
_79:
    /* (RELOAD_FORWARD from 324)  */
    target_state_index = 78; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_81:
    /* (RELOAD_FORWARD from 325)  */
    target_state_index = 80; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_83:
    /* (RELOAD_FORWARD from 326)  */
    target_state_index = 82; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_85:
    /* (RELOAD_FORWARD from 327)  */
    target_state_index = 84; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_87:
    /* (RELOAD_FORWARD from 328)  */
    target_state_index = 86; target_state_else_index = 55;

    goto _178;


    __quex_assert_no_passage();
_89:
    /* (RELOAD_FORWARD from 329)  */
    target_state_index = 88; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_91:
    /* (RELOAD_FORWARD from 330)  */
    target_state_index = 90; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_93:
    /* (RELOAD_FORWARD from 331)  */
    target_state_index = 92; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_95:
    /* (RELOAD_FORWARD from 332)  */
    target_state_index = 94; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_97:
    /* (RELOAD_FORWARD from 333)  */
    target_state_index = 96; target_state_else_index = 56;

    goto _178;


    __quex_assert_no_passage();
_99:
    /* (RELOAD_FORWARD from 334)  */
    target_state_index = 98; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_101:
    /* (RELOAD_FORWARD from 335)  */
    target_state_index = 100; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_103:
    /* (RELOAD_FORWARD from 336)  */
    target_state_index = 102; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_105:
    /* (RELOAD_FORWARD from 337)  */
    target_state_index = 104; target_state_else_index = 57;

    goto _178;


    __quex_assert_no_passage();
_107:
    /* (RELOAD_FORWARD from 338)  */
    target_state_index = 106; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_109:
    /* (RELOAD_FORWARD from 339)  */
    target_state_index = 108; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_111:
    /* (RELOAD_FORWARD from 340)  */
    target_state_index = 110; target_state_else_index = 49;

    goto _178;


    __quex_assert_no_passage();
_113:
    /* (RELOAD_FORWARD from 341)  */
    target_state_index = 112; target_state_else_index = 58;

    goto _178;

_179:
/* RETURN -- after executing 'on_after_match' code. */
    return;


_180:
/* CONTINUE -- after executing 'on_after_match' code. */

_181:
/* CONTINUE -- without executing 'on_after_match' (e.g. on FAILURE). */


    /* Mode change = another function takes over the analysis.
     * => After mode change the analyzer function needs to be quit!
     * ASSERT: 'CONTINUE' after mode change is not allowed.                   */
    __quex_assert(   me->DEBUG_analyzer_function_at_entry 
                  == me->current_analyzer_function);


    if( quexProcessed_TokenQueue_is_full(&self._token_queue) ) {
        return;
    }


goto _182;

    __quex_assert_no_passage();

    /* Following labels are referenced in macros. It cannot be detected
     * whether the macros are applied in user code or not. To avoid compiler.
     * warnings of unused labels, they are referenced in unreachable code.   */
    goto _179; /* in RETURN                */
    goto _180; /* in CONTINUE              */
    goto _181; /* in CONTINUE and skippers */

    goto _183; /* in QUEX_GOTO_STATE       */


    /* Prevent compiler warning 'unused variable'.                           */
    (void)quexProcessed_LexemeNull;
    /* target_state_index and target_state_else_index appear when 
     * QUEX_GOTO_STATE is used without computed goto-s.                      */
    (void)target_state_index;
    (void)target_state_else_index;

#   undef Lexeme
#   undef LexemeBegin
#   undef LexemeEnd
#   undef LexemeNull
#   undef LexemeL
#   undef ONE_AND_ONLY
#   undef self
#   undef QUEX_LABEL_STATE_ROUTER
}


#include "quexProcessed/quexProcessed-token_ids"





bool
quexProcessed_user_constructor(quexProcessed* me)
{
    (void)me;

#define self  (*(quexProcessed*)me)
/* START: User's constructor extensions _______________________________________*/

/* END: _______________________________________________________________________*/
#undef self
    return true;
}

void
quexProcessed_user_destructor(quexProcessed* me)
{
    (void)me;

#define self  (*(quexProcessed*)me)
/* START: User's constructor extensions _______________________________________*/

/* END: _______________________________________________________________________*/
#undef self
}

bool
quexProcessed_user_reset(quexProcessed* me)
{
    (void)me;

#define self  (*(quexProcessed*)me)
/* START: User's 'reset' ______________________________________________________*/

/* END: _______________________________________________________________________*/
#undef self
    return true;
}

void
quexProcessed_user_print(quexProcessed* me)
{
    (void)me;

#define self  (*(quexProcessed*)me)
/* START: User's constructor extensions _______________________________________*/

/* END: _______________________________________________________________________*/
#undef self
}

bool
quexProcessed_user_memento_pack(quexProcessed* me, 
                             const char*         InputName, 
                             quexProcessed_Memento* memento) 
{
    (void)me; (void)memento; (void)InputName;

#define self  (*(quexProcessed*)me)
/* START: User's memento 'pack' _______________________________________________*/

/* END: _______________________________________________________________________*/
#undef self
    return true;
}

void
quexProcessed_user_memento_unpack(quexProcessed*  me, 
                               quexProcessed_Memento*  memento)
{
    (void)me; (void)memento;

#define self  (*(quexProcessed*)me)
/* START: User's memento 'unpack' _____________________________________________*/

/* END: _______________________________________________________________________*/
#undef self
}

const char*
quexProcessed_map_token_id_to_name(const quexProcessed_token_id_t TokenID)
/* NOTE: This function is not element of the token namespace, since the token
 *       identifiers are lied to the generated lexical analyzer. The token class
 *       may be used over multiple lexical analyzers.                         */
{
   switch( TokenID ) {
   default: {
       return "<NUMERIC VALUE OF TOKEN-ID UNDEFINED>";
   }

   case QUEX_TKN_TERMINATION:    return "<TERMINATION>";
   case QUEX_TKN_UNINITIALIZED:  return "<UNINITIALIZED>";

   case QUEX_TKN_BRACKET_CLOSE: return "BRACKET_CLOSE";
   case QUEX_TKN_BRACKET_OPEN:  return "BRACKET_OPEN";
   case QUEX_TKN_EXPECT:        return "EXPECT";
   case QUEX_TKN_IDENTIFIER:    return "IDENTIFIER";
   case QUEX_TKN_NUMBER:        return "NUMBER";
   case QUEX_TKN_SEMICOLON:     return "SEMICOLON";
   case QUEX_TKN_SEND:          return "SEND";
   case QUEX_TKN_STRUCT:        return "STRUCT";
   case QUEX_TKN_TYPE_DOUBLE:   return "TYPE_DOUBLE";
   case QUEX_TKN_TYPE_INT:      return "TYPE_INT";


   }
}





