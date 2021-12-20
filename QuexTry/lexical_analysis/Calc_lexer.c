
#include "lexical_analysis/Calc_lexer.h"
#include "lexical_analysis/lib/analyzer/C-adaptions.h"
#include "lexical_analysis/lib/implementations.i"



Calc_lexer_Mode Calc_lexer_ONE_AND_ONLY = {
    /* name              */ "ONE_AND_ONLY",

    /* on_entry          */ Calc_lexer_Mode_on_entry_exit_null_function,
    /* on_exit           */ Calc_lexer_Mode_on_entry_exit_null_function,
#   if      defined(QUEX_OPTION_ASSERTS)
    /* has_base          */ Calc_lexer_ONE_AND_ONLY_has_base,
    /* has_entry_from    */ Calc_lexer_ONE_AND_ONLY_has_entry_from,
    /* has_exit_to       */ Calc_lexer_ONE_AND_ONLY_has_exit_to,
#   endif
    {
    /* on_buffer_before_change */ Calc_lexer_ONE_AND_ONLY_on_buffer_before_change,
    /* on_buffer_overflow      */ Calc_lexer_ONE_AND_ONLY_on_buffer_overflow,
    /* aux                     */ (void*)0,
    },

    /* analyzer_function */ Calc_lexer_ONE_AND_ONLY_analyzer_function
};

#   ifdef     self
#       undef self
#   endif
#   define self (*((struct Calc_lexer_tag*)me))
#define LexemeNull  (&Calc_lexer_LexemeNull)
#define RETURN      return

void
Calc_lexer_ONE_AND_ONLY_on_entry(struct Calc_lexer_tag* me, const Calc_lexer_Mode* FromMode) {
    (void)me;
    (void)FromMode;
#   ifdef QUEX_OPTION_ASSERTS
    Calc_lexer_ONE_AND_ONLY.has_entry_from(FromMode);
#   endif

}

void
Calc_lexer_ONE_AND_ONLY_on_exit(struct Calc_lexer_tag* me, const Calc_lexer_Mode* ToMode)  {
    (void)me;
    (void)ToMode;
#   ifdef QUEX_OPTION_ASSERTS
    Calc_lexer_ONE_AND_ONLY.has_exit_to(ToMode);
#   endif

}



#ifdef QUEX_OPTION_ASSERTS
bool
Calc_lexer_ONE_AND_ONLY_has_base(const Calc_lexer_Mode* Mode) {
    (void)Mode;
    return false;
}

bool
Calc_lexer_ONE_AND_ONLY_has_entry_from(const Calc_lexer_Mode* Mode) {
    (void)Mode;
return false;
}

bool
Calc_lexer_ONE_AND_ONLY_has_exit_to(const Calc_lexer_Mode* Mode) {
    (void)Mode;
return false;
}
#endif    

void
Calc_lexer_ONE_AND_ONLY_on_buffer_before_change(void* me /* 'aux' -> 'self' via 'me' */)
{
    const Calc_lexer_lexatom_t* BufferBegin = self.buffer.begin(&self.buffer);
    const Calc_lexer_lexatom_t* BufferEnd   = self.buffer.end(&self.buffer);
    (void)me; (void)BufferBegin; (void)BufferEnd;

}

 void
Calc_lexer_Buffer_print_overflow_message(Calc_lexer_Buffer* buffer); 

void
Calc_lexer_ONE_AND_ONLY_on_buffer_overflow(void*  me /* 'aux' -> 'self' via 'me' */)
{
    const Calc_lexer_lexatom_t* LexemeBegin = self.buffer._lexeme_start_p;
    const Calc_lexer_lexatom_t* LexemeEnd   = self.buffer._read_p;
    const size_t             BufferSize  = (size_t)(self.buffer.size(&self.buffer)); 


    /* Try to double the size of the buffer, by default.                      */
    if( ! Calc_lexer_Buffer_nested_negotiate_extend(&self.buffer, 2.0) ) {
        Calc_lexer_MF_error_code_set_if_first(&self, E_Error_Buffer_Overflow_LexemeTooLong);
        Calc_lexer_Buffer_print_overflow_message(&self.buffer);
    }

    (void)me; (void)LexemeBegin; (void)LexemeEnd; (void)BufferSize;
}
#undef self
#undef LexemeNull
#undef RETURN

static void
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme(struct Calc_lexer_tag* me, Calc_lexer_lexatom_t* LexemeBegin, Calc_lexer_lexatom_t* LexemeEnd)
{
#   define self (*me)
/*  'QUEX_GOTO_STATE' requires 'QUEX_LABEL_STATE_ROUTER' */
#   define QUEX_LABEL_STATE_ROUTER _18
    Calc_lexer_lexatom_t    input                   = (Calc_lexer_lexatom_t)(0x00);
    Calc_lexer_goto_label_t target_state_else_index = (Calc_lexer_goto_label_t)-1;
    Calc_lexer_goto_label_t target_state_index      = (Calc_lexer_goto_label_t)-1;
    Calc_lexer_lexatom_t*   count_reference_p       = (Calc_lexer_lexatom_t*)0x0;
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

    /* (379 from BEFORE_ENTRY)  */
     count_reference_p = (me->buffer._read_p);

 count_reference_p = (me->buffer._read_p);

    input = *(me->buffer._read_p);

_13:
    __quex_debug_init_state("Counter:ONE_AND_ONLY", 379);
if     ( input >= 0xB )  goto _4;
else if( input == 0xA )  goto _2;
else if( input == 0x9 )  goto _3;
else                     goto _4;


    __quex_assert_no_passage();
_8:
    /* (379 from 384)  */
    goto _13;


    __quex_assert_no_passage();
_5:
    /* (DROP_OUT from 380)  */
goto _9;

    __quex_debug("%s" " Drop-Out Catcher\n");


    __quex_assert_no_passage();
_6:
    /* (DROP_OUT from 381)  */
goto _10;


    __quex_assert_no_passage();
_7:
    /* (DROP_OUT from 382)  */
goto _11;


    __quex_assert_no_passage();
_2:
    /* (380 from 379)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(380);
goto _5;


    __quex_assert_no_passage();
_3:
    /* (381 from 379)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(381);
goto _6;


    __quex_assert_no_passage();
_4:
    /* (382 from 379)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(382);
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
    __quex_debug("* TERMINAL <LOOP TERMINAL 103>\n");
me->counter._line_number_at_end += ((size_t)1); __quex_debug_counter();

     (me->counter._column_number_at_end) = (size_t)1;

 count_reference_p = (me->buffer._read_p);

if( me->buffer._read_p != LexemeEnd ) goto _8;

goto _0;

_10:
    __quex_debug("* TERMINAL <LOOP TERMINAL 104>\n");
me->counter._column_number_at_end += ((size_t)(((me->buffer._read_p) - count_reference_p - 1))); __quex_debug_counter();


self.counter._column_number_at_end -= 1;
self.counter._column_number_at_end &= ~ ((size_t)0x3);
self.counter._column_number_at_end += 4 + 1;


 count_reference_p = (me->buffer._read_p);

if( me->buffer._read_p != LexemeEnd ) goto _8;

goto _0;

_11:
    __quex_debug("* TERMINAL <LOOP TERMINAL 105>\n");
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

#include "lexical_analysis/lib/buffer/Buffer"
#include "lexical_analysis/lib/token/TokenQueue"

#ifdef    CONTINUE
#   undef CONTINUE
#endif
#define   CONTINUE do { goto _257; } while(0)

#ifdef    RETURN
#   undef RETURN
#endif
#define   RETURN   do { goto _256; } while(0)

void  
Calc_lexer_ONE_AND_ONLY_analyzer_function(struct Calc_lexer_tag* me) 
{
    /* NOTE: Different modes correspond to different analyzer functions. The 
     *       analyzer functions are all located inside the main class as static
     *       functions. That means, they are something like 'globals'. They 
     *       receive a pointer to the lexical analyzer, since static members do
     *       not have access to the 'this' pointer.                          */
#   ifdef     self
#       undef self
#   endif
#   define self (*((struct Calc_lexer_tag*)me))
#   define ONE_AND_ONLY    (&Calc_lexer_ONE_AND_ONLY)
/*  'QUEX_GOTO_STATE' requires 'QUEX_LABEL_STATE_ROUTER' */
#   define QUEX_LABEL_STATE_ROUTER _260

    /* Lexeme setup: 
     *
     * There is a temporary zero stored at the end of each lexeme, if the action 
     * references to the 'Lexeme'. 'LexemeNull' provides a reference to an empty
     * zero terminated string.                                                    */
#if defined(QUEX_OPTION_ASSERTS)
#   define Lexeme       Calc_lexer_access_Lexeme((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#   define LexemeBegin  Calc_lexer_access_LexemeBegin((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#   define LexemeL      Calc_lexer_access_LexemeL((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#   define LexemeEnd    Calc_lexer_access_LexemeEnd((const char*)__FILE__, (size_t)__LINE__, &me->buffer)
#else
#   define Lexeme       (me->buffer._lexeme_start_p)
#   define LexemeBegin  Lexeme
#   define LexemeL      ((size_t)(me->buffer._read_p - me->buffer._lexeme_start_p))
#   define LexemeEnd    me->buffer._read_p
#endif

#define LexemeNull      (&Calc_lexer_LexemeNull)
    E_LoadResult         load_result             = E_LoadResult_VOID;
    Calc_lexer_lexatom_t**  position                = 0x0;
    Calc_lexer_goto_label_t target_state_else_index = (Calc_lexer_goto_label_t)-1;
    const size_t         PositionRegisterN       = (size_t)0;
    Calc_lexer_lexatom_t    input                   = (Calc_lexer_lexatom_t)(0x00);
    Calc_lexer_goto_label_t target_state_index      = (Calc_lexer_goto_label_t)-1;

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
_259:
    me->buffer._lexeme_start_p = me->buffer._read_p;
    QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_UNDO(&me->buffer);
_27:
    /* (489 from RELOAD_FORWARD) (489 from BEFORE_ENTRY)  */

    input = *(me->buffer._read_p);


    __quex_debug_init_state("Core:ONE_AND_ONLY", 489);
switch( input ) {
case 0x0: goto _98;
case 0x9: goto _29;
case 0xA: goto _32;
case 0x20: goto _29;
case 0x27: goto _40;
case 0x28: goto _35;
case 0x29: goto _39;
case 0x2A: goto _34;
case 0x2B: goto _47;
case 0x2D: goto _30;
case 0x2F: goto _38;
case 0x30: case 0x31: case 0x32: case 0x33: case 0x34: case 0x35: case 0x36: case 0x37: 
case 0x38: case 0x39: goto _33;
case 0x3B: goto _42;
case 0x3D: goto _43;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: goto _45;
case 0x5E: goto _31;
case 0x5F: 
case 0x61: case 0x62: case 0x63: goto _45;
case 0x64: goto _44;
case 0x65: goto _41;
case 0x66: case 0x67: case 0x68: goto _45;
case 0x69: goto _46;
case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: goto _45;
case 0x70: goto _36;
case 0x71: case 0x72: goto _45;
case 0x73: goto _28;
case 0x74: case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
case 0x7B: goto _37;
case 0x7D: goto _48;
default: goto _75;
}


    __quex_assert_no_passage();
_76:
    /* (DROP_OUT from 526) (DROP_OUT from 533) (DROP_OUT from 508) (DROP_OUT from 530) (DROP_OUT from 520) (DROP_OUT from 514) (DROP_OUT from 527) (DROP_OUT from 503) (DROP_OUT from 531) (DROP_OUT from 506) (DROP_OUT from 518) (DROP_OUT from 521) (DROP_OUT from 515) (DROP_OUT from 490) (DROP_OUT from 535) (DROP_OUT from 525) (DROP_OUT from 532) (DROP_OUT from 507) (DROP_OUT from 519) (DROP_OUT from 522) (DROP_OUT from 529) (DROP_OUT from 516) (DROP_OUT from 498) (DROP_OUT from 513) (DROP_OUT from 511)  */

goto _11;
_169:
    __quex_debug("%s" " Drop-Out Catcher\n");


    __quex_assert_no_passage();
_77:
    /* (DROP_OUT from 491)  */
goto _12;


    __quex_assert_no_passage();
_78:
    /* (DROP_OUT from 492)  */
goto _15;


    __quex_assert_no_passage();
_79:
    /* (DROP_OUT from 493)  */
goto _18;


    __quex_assert_no_passage();
_80:
    /* (DROP_OUT from 502) (DROP_OUT from 494)  */
goto _13;


    __quex_assert_no_passage();
_81:
    /* (DROP_OUT from 495)  */
goto _0;


    __quex_assert_no_passage();
_82:
    /* (DROP_OUT from 496)  */
goto _16;


    __quex_assert_no_passage();
_83:
    /* (DROP_OUT from 497)  */
goto _19;


    __quex_assert_no_passage();
_84:
    /* (DROP_OUT from 499)  */
goto _7;


    __quex_assert_no_passage();
_85:
    /* (DROP_OUT from 500)  */
goto _17;


    __quex_assert_no_passage();
_86:
    /* (DROP_OUT from 501)  */
goto _20;


    __quex_assert_no_passage();
_87:
    /* (DROP_OUT from 504)  */
goto _6;


    __quex_assert_no_passage();
_88:
    /* (DROP_OUT from 505)  */
goto _21;


    __quex_assert_no_passage();
_89:
    /* (DROP_OUT from 509)  */
goto _14;


    __quex_assert_no_passage();
_90:
    /* (DROP_OUT from 510)  */
goto _8;


    __quex_assert_no_passage();
_91:
    /* (DROP_OUT from 512)  */
goto _2;


    __quex_assert_no_passage();
_92:
    /* (DROP_OUT from 517)  */
goto _3;


    __quex_assert_no_passage();
_93:
    /* (DROP_OUT from 523)  */
goto _5;


    __quex_assert_no_passage();
_94:
    /* (DROP_OUT from 524)  */
goto _10;


    __quex_assert_no_passage();
_95:
    /* (DROP_OUT from 528)  */
goto _9;


    __quex_assert_no_passage();
_96:
    /* (DROP_OUT from 534)  */
goto _1;


    __quex_assert_no_passage();
_97:
    /* (DROP_OUT from 536)  */
goto _4;


    __quex_assert_no_passage();
_75:
    /* (DROP_OUT from 489)  */
    me->buffer._read_p = me->buffer._lexeme_start_p + 1;
goto _25;
    goto _169;


    __quex_assert_no_passage();
_117:
    /* (512 from RELOAD_FORWARD)  */
_172:
    input = *(me->buffer._read_p);


    __quex_debug_state(512);
switch( input ) {
case 0x0: goto _118;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _91;
}


    __quex_assert_no_passage();
_50:
    /* (512 from 511)  */
    ++(me->buffer._read_p);

    goto _172;


    __quex_assert_no_passage();
_51:
    /* (513 from 506)  */
    ++(me->buffer._read_p);

_174:
    input = *(me->buffer._read_p);


    __quex_debug_state(513);
switch( input ) {
case 0x0: goto _120;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: goto _45;
case 0x75: goto _52;
case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_119:
    /* (513 from RELOAD_FORWARD)  */
    goto _174;


    __quex_assert_no_passage();
_52:
    /* (514 from 513)  */
    ++(me->buffer._read_p);

_176:
    input = *(me->buffer._read_p);


    __quex_debug_state(514);
switch( input ) {
case 0x0: goto _122;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: goto _45;
case 0x62: goto _53;
case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_121:
    /* (514 from RELOAD_FORWARD)  */
    goto _176;


    __quex_assert_no_passage();
_53:
    /* (515 from 514)  */
    ++(me->buffer._read_p);

_178:
    input = *(me->buffer._read_p);


    __quex_debug_state(515);
switch( input ) {
case 0x0: goto _124;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: goto _45;
case 0x6C: goto _54;
case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_123:
    /* (515 from RELOAD_FORWARD)  */
    goto _178;


    __quex_assert_no_passage();
_125:
    /* (516 from RELOAD_FORWARD)  */
_180:
    input = *(me->buffer._read_p);


    __quex_debug_state(516);
switch( input ) {
case 0x0: goto _126;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: goto _45;
case 0x65: goto _55;
case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_54:
    /* (516 from 515)  */
    ++(me->buffer._read_p);

    goto _180;


    __quex_assert_no_passage();
_127:
    /* (517 from RELOAD_FORWARD)  */
_182:
    input = *(me->buffer._read_p);


    __quex_debug_state(517);
switch( input ) {
case 0x0: goto _128;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _92;
}


    __quex_assert_no_passage();
_55:
    /* (517 from 516)  */
    ++(me->buffer._read_p);

    goto _182;


    __quex_assert_no_passage();
_56:
    /* (518 from 503)  */
    ++(me->buffer._read_p);

_184:
    input = *(me->buffer._read_p);


    __quex_debug_state(518);
switch( input ) {
case 0x0: goto _130;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: case 0x68: goto _45;
case 0x69: goto _57;
case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: goto _45;
case 0x70: goto _58;
case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_129:
    /* (518 from RELOAD_FORWARD)  */
    goto _184;


    __quex_assert_no_passage();
_131:
    /* (519 from RELOAD_FORWARD)  */
_186:
    input = *(me->buffer._read_p);


    __quex_debug_state(519);
switch( input ) {
case 0x0: goto _132;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _45;
case 0x74: goto _62;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_57:
    /* (519 from 518)  */
    ++(me->buffer._read_p);

    goto _186;


    __quex_assert_no_passage();
_133:
    /* (520 from RELOAD_FORWARD)  */
_188:
    input = *(me->buffer._read_p);


    __quex_debug_state(520);
switch( input ) {
case 0x0: goto _134;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: goto _45;
case 0x65: goto _59;
case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_58:
    /* (520 from 518)  */
    ++(me->buffer._read_p);

    goto _188;


    __quex_assert_no_passage();
_59:
    /* (521 from 520)  */
    ++(me->buffer._read_p);

_190:
    input = *(me->buffer._read_p);


    __quex_debug_state(521);
switch( input ) {
case 0x0: goto _136;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: goto _45;
case 0x63: goto _60;
case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_135:
    /* (521 from RELOAD_FORWARD)  */
    goto _190;


    __quex_assert_no_passage();
_60:
    /* (522 from 521)  */
    ++(me->buffer._read_p);

_192:
    input = *(me->buffer._read_p);


    __quex_debug_state(522);
switch( input ) {
case 0x0: goto _138;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _45;
case 0x74: goto _61;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_137:
    /* (522 from RELOAD_FORWARD)  */
    goto _192;


    __quex_assert_no_passage();
_61:
    /* (523 from 522)  */
    ++(me->buffer._read_p);

_194:
    input = *(me->buffer._read_p);


    __quex_debug_state(523);
switch( input ) {
case 0x0: goto _140;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _93;
}


    __quex_assert_no_passage();
_139:
    /* (523 from RELOAD_FORWARD)  */
    goto _194;


    __quex_assert_no_passage();
_141:
    /* (524 from RELOAD_FORWARD)  */
_196:
    input = *(me->buffer._read_p);


    __quex_debug_state(524);
switch( input ) {
case 0x0: goto _142;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _94;
}


    __quex_assert_no_passage();
_62:
    /* (524 from 519)  */
    ++(me->buffer._read_p);

    goto _196;


    __quex_assert_no_passage();
_143:
    /* (525 from RELOAD_FORWARD)  */
_198:
    input = *(me->buffer._read_p);


    __quex_debug_state(525);
switch( input ) {
case 0x0: goto _144;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: case 0x68: goto _45;
case 0x69: goto _64;
case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_63:
    /* (525 from 498)  */
    ++(me->buffer._read_p);

    goto _198;


    __quex_assert_no_passage();
_64:
    /* (526 from 525)  */
    ++(me->buffer._read_p);

_200:
    input = *(me->buffer._read_p);


    __quex_debug_state(526);
switch( input ) {
case 0x0: goto _146;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: goto _45;
case 0x6E: goto _65;
case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_145:
    /* (526 from RELOAD_FORWARD)  */
    goto _200;


    __quex_assert_no_passage();
_147:
    /* (527 from RELOAD_FORWARD)  */
_202:
    input = *(me->buffer._read_p);


    __quex_debug_state(527);
switch( input ) {
case 0x0: goto _148;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _45;
case 0x74: goto _66;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_65:
    /* (527 from 526)  */
    ++(me->buffer._read_p);

    goto _202;


    __quex_assert_no_passage();
_149:
    /* (528 from RELOAD_FORWARD)  */
_204:
    input = *(me->buffer._read_p);


    __quex_debug_state(528);
switch( input ) {
case 0x0: goto _150;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _95;
}


    __quex_assert_no_passage();
_66:
    /* (528 from 527)  */
    ++(me->buffer._read_p);

    goto _204;


    __quex_assert_no_passage();
_67:
    /* (529 from 490)  */
    ++(me->buffer._read_p);

_206:
    input = *(me->buffer._read_p);


    __quex_debug_state(529);
switch( input ) {
case 0x0: goto _152;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: goto _45;
case 0x6E: goto _73;
case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_151:
    /* (529 from RELOAD_FORWARD)  */
    goto _206;


    __quex_assert_no_passage();
_68:
    /* (530 from 490)  */
    ++(me->buffer._read_p);

_208:
    input = *(me->buffer._read_p);


    __quex_debug_state(530);
switch( input ) {
case 0x0: goto _154;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: goto _45;
case 0x72: goto _69;
case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_153:
    /* (530 from RELOAD_FORWARD)  */
    goto _208;


    __quex_assert_no_passage();
_69:
    /* (531 from 530)  */
    ++(me->buffer._read_p);

_210:
    input = *(me->buffer._read_p);


    __quex_debug_state(531);
switch( input ) {
case 0x0: goto _156;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: goto _45;
case 0x75: goto _70;
case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_155:
    /* (531 from RELOAD_FORWARD)  */
    goto _210;


    __quex_assert_no_passage();
_157:
    /* (532 from RELOAD_FORWARD)  */
_212:
    input = *(me->buffer._read_p);


    __quex_debug_state(532);
switch( input ) {
case 0x0: goto _158;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: goto _45;
case 0x63: goto _71;
case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_70:
    /* (532 from 531)  */
    ++(me->buffer._read_p);

    goto _212;


    __quex_assert_no_passage();
_159:
    /* (533 from RELOAD_FORWARD)  */
_214:
    input = *(me->buffer._read_p);


    __quex_debug_state(533);
switch( input ) {
case 0x0: goto _160;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _45;
case 0x74: goto _72;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_71:
    /* (533 from 532)  */
    ++(me->buffer._read_p);

    goto _214;


    __quex_assert_no_passage();
_72:
    /* (534 from 533)  */
    ++(me->buffer._read_p);

_216:
    input = *(me->buffer._read_p);


    __quex_debug_state(534);
switch( input ) {
case 0x0: goto _162;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _96;
}


    __quex_assert_no_passage();
_161:
    /* (534 from RELOAD_FORWARD)  */
    goto _216;


    __quex_assert_no_passage();
_163:
    /* (535 from RELOAD_FORWARD)  */
_218:
    input = *(me->buffer._read_p);


    __quex_debug_state(535);
switch( input ) {
case 0x0: goto _164;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: goto _45;
case 0x64: goto _74;
case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_73:
    /* (535 from 529)  */
    ++(me->buffer._read_p);

    goto _218;


    __quex_assert_no_passage();
_165:
    /* (536 from RELOAD_FORWARD)  */
_220:
    input = *(me->buffer._read_p);


    __quex_debug_state(536);
switch( input ) {
case 0x0: goto _166;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _97;
}


    __quex_assert_no_passage();
_74:
    /* (536 from 535)  */
    ++(me->buffer._read_p);

    goto _220;


    __quex_assert_no_passage();
_28:
    /* (490 from 489)  */
    ++(me->buffer._read_p);

_222:
    input = *(me->buffer._read_p);


    __quex_debug_state(490);
switch( input ) {
case 0x0: goto _100;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: goto _45;
case 0x65: goto _67;
case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _45;
case 0x74: goto _68;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_99:
    /* (490 from RELOAD_FORWARD)  */
    goto _222;


    __quex_assert_no_passage();
_29:
    /* (491 from 491) (491 from 489)  */

    ++(me->buffer._read_p);

_225:
    input = *(me->buffer._read_p);


    __quex_debug_state(491);
switch( input ) {
case 0x0: goto _102;
case 0x9: 
case 0x20: goto _29;
default: goto _77;
}


    __quex_assert_no_passage();
_101:
    /* (491 from RELOAD_FORWARD)  */
    goto _225;


    __quex_assert_no_passage();
_30:
    /* (492 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(492);
goto _78;


    __quex_assert_no_passage();
_31:
    /* (493 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(493);
goto _79;


    __quex_assert_no_passage();
_32:
    /* (494 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(494);
goto _80;


    __quex_assert_no_passage();
_33:
    /* (495 from 495) (495 from 489)  */

    ++(me->buffer._read_p);

_231:
    input = *(me->buffer._read_p);


    __quex_debug_state(495);
if     ( input >= 0x3A )  goto _81;
else if( input >= 0x30 )  goto _33;
else if( input >= 0x1 )   goto _81;
else                      goto _104;


    __quex_assert_no_passage();
_103:
    /* (495 from RELOAD_FORWARD)  */
    goto _231;


    __quex_assert_no_passage();
_34:
    /* (496 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(496);
goto _82;


    __quex_assert_no_passage();
_35:
    /* (497 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(497);
goto _83;


    __quex_assert_no_passage();
_36:
    /* (498 from 489)  */
    ++(me->buffer._read_p);

_235:
    input = *(me->buffer._read_p);


    __quex_debug_state(498);
switch( input ) {
case 0x0: goto _106;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: goto _45;
case 0x72: goto _63;
case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_105:
    /* (498 from RELOAD_FORWARD)  */
    goto _235;


    __quex_assert_no_passage();
_37:
    /* (499 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(499);
goto _84;


    __quex_assert_no_passage();
_38:
    /* (500 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(500);
goto _85;


    __quex_assert_no_passage();
_39:
    /* (501 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(501);
goto _86;


    __quex_assert_no_passage();
_40:
    /* (502 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(502);
goto _80;


    __quex_assert_no_passage();
_107:
    /* (503 from RELOAD_FORWARD)  */
_241:
    input = *(me->buffer._read_p);


    __quex_debug_state(503);
switch( input ) {
case 0x0: goto _108;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: goto _45;
case 0x78: goto _56;
case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_41:
    /* (503 from 489)  */
    ++(me->buffer._read_p);

    goto _241;


    __quex_assert_no_passage();
_42:
    /* (504 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(504);
goto _87;


    __quex_assert_no_passage();
_43:
    /* (505 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(505);
goto _88;


    __quex_assert_no_passage();
_44:
    /* (506 from 489)  */
    ++(me->buffer._read_p);

_245:
    input = *(me->buffer._read_p);


    __quex_debug_state(506);
switch( input ) {
case 0x0: goto _110;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: goto _45;
case 0x6F: goto _51;
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_109:
    /* (506 from RELOAD_FORWARD)  */
    goto _245;


    __quex_assert_no_passage();
_45:
    /* (507 from 518) (507 from 523) (507 from 528) (507 from 508) (507 from 517) (507 from 507) (507 from 512) (507 from 527) (507 from 532) (507 from 522) (507 from 531) (507 from 511) (507 from 516) (507 from 521) (507 from 506) (507 from 515) (507 from 526) (507 from 535) (507 from 490) (507 from 536) (507 from 525) (507 from 530) (507 from 489) (507 from 519) (507 from 520) (507 from 529) (507 from 514) (507 from 503) (507 from 513) (507 from 534) (507 from 498) (507 from 524) (507 from 533)  */

    ++(me->buffer._read_p);

_248:
    input = *(me->buffer._read_p);


    __quex_debug_state(507);
switch( input ) {
case 0x0: goto _112;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_111:
    /* (507 from RELOAD_FORWARD)  */
    goto _248;


    __quex_assert_no_passage();
_113:
    /* (508 from RELOAD_FORWARD)  */
_250:
    input = *(me->buffer._read_p);


    __quex_debug_state(508);
switch( input ) {
case 0x0: goto _114;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: goto _45;
case 0x6E: goto _49;
case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: case 0x74: case 0x75: case 0x76: case 0x77: 
case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_46:
    /* (508 from 489)  */
    ++(me->buffer._read_p);

    goto _250;


    __quex_assert_no_passage();
_47:
    /* (509 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(509);
goto _89;


    __quex_assert_no_passage();
_48:
    /* (510 from 489)  */
    ++(me->buffer._read_p);

    input = *(me->buffer._read_p);


    __quex_debug_state(510);
goto _90;


    __quex_assert_no_passage();
_115:
    /* (511 from RELOAD_FORWARD)  */
_254:
    input = *(me->buffer._read_p);


    __quex_debug_state(511);
switch( input ) {
case 0x0: goto _116;
case 0x41: case 0x42: case 0x43: case 0x44: case 0x45: case 0x46: case 0x47: 
case 0x48: case 0x49: case 0x4A: case 0x4B: case 0x4C: case 0x4D: case 0x4E: case 0x4F: 
case 0x50: case 0x51: case 0x52: case 0x53: case 0x54: case 0x55: case 0x56: case 0x57: 
case 0x58: case 0x59: case 0x5A: 
case 0x5F: 
case 0x61: case 0x62: case 0x63: case 0x64: case 0x65: case 0x66: case 0x67: 
case 0x68: case 0x69: case 0x6A: case 0x6B: case 0x6C: case 0x6D: case 0x6E: case 0x6F: 
case 0x70: case 0x71: case 0x72: case 0x73: goto _45;
case 0x74: goto _50;
case 0x75: case 0x76: case 0x77: case 0x78: case 0x79: case 0x7A: goto _45;
default: goto _76;
}


    __quex_assert_no_passage();
_49:
    /* (511 from 508)  */
    ++(me->buffer._read_p);

    goto _254;

    /* (*) Terminal states _______________________________________________________
     *
     * States that implement actions of the 'winner patterns.                     */
_22:
    __quex_debug("* TERMINAL BAD_LEXATOM\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{
#define BadLexatom ((me->buffer._read_p > me->buffer._memory._front && me->buffer._read_p <= me->buffer.input.end_p) ? (me->buffer._read_p[-1]) : (Calc_lexer_lexatom_t)-1)
self.error_code_set_if_first(&self, E_Error_OnBadLexatom);
self.error_code_set_if_first(&self, E_Error_NoHandler_OnBadLexatom);
self.send(&self, TKN_TERMINATION);
return;;
#undef BadLexatom

}
    /* Bad lexatom detection FORCES a return from the lexical analyzer, so that no
     * tokens can be filled after the termination token.
     */
return;
_23:
    __quex_debug("* TERMINAL LOAD_FAILURE\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{
self.error_code_set_if_first(&self, E_Error_OnLoadFailure);
self.error_code_set_if_first(&self, E_Error_NoHandler_OnLoadFailure);
self.send(&self, TKN_TERMINATION);
return;;

}
    /* Load failure FORCES a return from the lexical analyzer, so that no
     * tokens can be filled after the termination token.
     */
return;
_24:
    __quex_debug("* TERMINAL END_OF_STREAM\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{

#   line 14 "Calc_lexer.qx"
self.send(&self, TKN_TERMINATION);
return;

#   line 1828 "lexical_analysis/Calc_lexer.c"

}
    /* End of Stream FORCES a return from the lexical analyzer, so that no
     * tokens can be filled after the termination token.
     */
return;
_25:
    __quex_debug("* TERMINAL FAILURE\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{
self.error_code_set_if_first(&self, E_Error_NoHandler_OnFailure);
self.send(&self, TKN_TERMINATION);
return;;

}
return;
_26:
    __quex_debug("* TERMINAL SKIP_RANGE_OPEN\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{
#define Counter counter
self.error_code_set_if_first(&self, E_Error_OnSkipRangeOpen);
self.error_code_set_if_first(&self, E_Error_NoHandler_OnSkipRangeOpen);
self.send(&self, TKN_TERMINATION);
return;;

}
    /* End of Stream appeared, while scanning for end of skip-range.
     */
return;
_0:
    __quex_debug("* TERMINAL [0-9]+\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)((size_t)(me->buffer._read_p - me->buffer._lexeme_start_p))); __quex_debug_counter();

QUEX_Calc_lexer_LEXEME_TERMINATING_ZERO_SET(&me->buffer);
{

#   line 15 "Calc_lexer.qx"
self.token_p(&self)->number = atoi((char*)Lexeme);
self.send(&self, TKN_NUM);

return;

#   line 1878 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_1:
    __quex_debug("* TERMINAL \"struct\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)6); __quex_debug_counter();

{

#   line 16 "Calc_lexer.qx"
self.send(&self, TKN_STRUCT);
return;

#   line 1896 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_2:
    __quex_debug("* TERMINAL \"int\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)3); __quex_debug_counter();

{

#   line 17 "Calc_lexer.qx"
self.send(&self, TKN_TYPE_INT);
return;

#   line 1914 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_3:
    __quex_debug("* TERMINAL \"double\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)6); __quex_debug_counter();

{

#   line 18 "Calc_lexer.qx"
self.send(&self, TKN_TYPE_DOUBLE);
return;

#   line 1932 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_4:
    __quex_debug("* TERMINAL \"send\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)4); __quex_debug_counter();

{

#   line 19 "Calc_lexer.qx"
self.send(&self, TKN_SEND);
return;

#   line 1950 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_5:
    __quex_debug("* TERMINAL \"expect\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)6); __quex_debug_counter();

{

#   line 20 "Calc_lexer.qx"
self.send(&self, TKN_EXPECT);
return;

#   line 1968 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_6:
    __quex_debug("* TERMINAL \";\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 21 "Calc_lexer.qx"
self.send(&self, TKN_SEMICOLON);
return;

#   line 1986 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_7:
    __quex_debug("* TERMINAL \"{\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 22 "Calc_lexer.qx"
self.send(&self, TKN_BRACKET_OPEN);
return;

#   line 2004 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_8:
    __quex_debug("* TERMINAL \"}\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 23 "Calc_lexer.qx"
self.send(&self, TKN_BRACKET_CLOSE);
return;

#   line 2022 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_9:
    __quex_debug("* TERMINAL \"print\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)5); __quex_debug_counter();

{

#   line 24 "Calc_lexer.qx"
self.send(&self, TKN_PRINT);
return;

#   line 2040 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_10:
    __quex_debug("* TERMINAL \"exit\"\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)4); __quex_debug_counter();

{

#   line 25 "Calc_lexer.qx"
self.send(&self, TKN_EXIT);
return;

#   line 2058 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_11:
    __quex_debug("* TERMINAL [_a-zA-Z]+\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)((size_t)(me->buffer._read_p - me->buffer._lexeme_start_p))); __quex_debug_counter();

{

#   line 26 "Calc_lexer.qx"
self.send_text(&self, TKN_IDENTIFIER, me->buffer._lexeme_start_p, me->buffer._read_p);
return;

#   line 2076 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_12:
    __quex_debug("* TERMINAL [ \\t]+\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{

#   line 27 "Calc_lexer.qx"

#   line 2088 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_13:
    __quex_debug("* TERMINAL ['\\n']\n");
Calc_lexer_ONE_AND_ONLY_counter_on_arbitrary_lexeme((struct Calc_lexer_tag*)me, LexemeBegin, LexemeEnd);

{

#   line 28 "Calc_lexer.qx"

#   line 2100 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_14:
    __quex_debug("* TERMINAL ['+']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 29 "Calc_lexer.qx"
self.send(&self, 0x00002B);

return;

#   line 2119 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_15:
    __quex_debug("* TERMINAL ['\\-']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 30 "Calc_lexer.qx"
self.send(&self, 0x00002D);

return;

#   line 2138 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_16:
    __quex_debug("* TERMINAL ['*']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 31 "Calc_lexer.qx"
self.send(&self, 0x00002A);

return;

#   line 2157 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_17:
    __quex_debug("* TERMINAL ['/']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 32 "Calc_lexer.qx"
self.send(&self, 0x00002F);

return;

#   line 2176 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_18:
    __quex_debug("* TERMINAL ['^']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 33 "Calc_lexer.qx"
self.send(&self, 0x00005E);

return;

#   line 2195 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_19:
    __quex_debug("* TERMINAL ['(']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 34 "Calc_lexer.qx"
self.send(&self, 0x000028);

return;

#   line 2214 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_20:
    __quex_debug("* TERMINAL [')']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 35 "Calc_lexer.qx"
self.send(&self, 0x000029);

return;

#   line 2233 "lexical_analysis/Calc_lexer.c"

}
RETURN;
_21:
    __quex_debug("* TERMINAL ['=']\n");
    me->counter._column_number_at_begin = me->counter._column_number_at_end;

    me->counter._line_number_at_begin = me->counter._line_number_at_end;

me->counter._column_number_at_end += ((size_t)1); __quex_debug_counter();

{

#   line 36 "Calc_lexer.qx"
self.send(&self, 0x00003D);

return;

#   line 2252 "lexical_analysis/Calc_lexer.c"

}
RETURN;
if(0) {
    /* Avoid unreferenced labels. */
    goto _22;
    goto _23;
    goto _24;
    goto _25;
    goto _26;
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
    goto _11;
    goto _12;
    goto _13;
    goto _14;
    goto _15;
    goto _16;
    goto _17;
    goto _18;
    goto _19;
    goto _20;
    goto _21;
}
    __quex_assert_no_passage();
    goto _260; /* prevent unused label */
_260:
switch( target_state_index ) {
case 24: {
goto _24;}
case 27: {
goto _27;}
case 76: {
goto _76;}
case 77: {
goto _77;}
case 81: {
goto _81;}
case 91: {
goto _91;}
case 92: {
goto _92;}
case 93: {
goto _93;}
case 94: {
goto _94;}
case 95: {
goto _95;}
case 96: {
goto _96;}
case 97: {
goto _97;}
case 99: {
goto _99;}
case 101: {
goto _101;}
case 103: {
goto _103;}
case 105: {
goto _105;}
case 107: {
goto _107;}
case 109: {
goto _109;}
case 111: {
goto _111;}
case 113: {
goto _113;}
case 115: {
goto _115;}
case 117: {
goto _117;}
case 119: {
goto _119;}
case 121: {
goto _121;}
case 123: {
goto _123;}
case 125: {
goto _125;}
case 127: {
goto _127;}
case 129: {
goto _129;}
case 131: {
goto _131;}
case 133: {
goto _133;}
case 135: {
goto _135;}
case 137: {
goto _137;}
case 139: {
goto _139;}
case 141: {
goto _141;}
case 143: {
goto _143;}
case 145: {
goto _145;}
case 147: {
goto _147;}
case 149: {
goto _149;}
case 151: {
goto _151;}
case 153: {
goto _153;}
case 155: {
goto _155;}
case 157: {
goto _157;}
case 159: {
goto _159;}
case 161: {
goto _161;}
case 163: {
goto _163;}
case 165: {
goto _165;}
default: {
goto _165;}
}


    __quex_assert_no_passage();
_142:
    /* (RELOAD_FORWARD from 524)  */
    target_state_index = 141; target_state_else_index = 94;

_255:

    __quex_debug3("RELOAD_FORWARD: success->%i; failure->%i", 
                  (int)target_state_index, (int)target_state_else_index);
    __quex_assert(*(me->buffer._read_p) == QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);
    
    __quex_debug_reload_before();                 
    /* Callbacks: 'on_buffer_before_change()' and 'on_buffer_overflow()'
     * are called during load process upon occurrence.                        */
    load_result = Calc_lexer_Buffer_load_forward(&me->buffer, (Calc_lexer_lexatom_t**)position, PositionRegisterN);
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
    case E_LoadResult_ENCODING_ERROR: goto _22;
    case E_LoadResult_OVERFLOW:       Calc_lexer_MF_error_code_set_if_first(me, E_Error_Buffer_Overflow_LexemeTooLong); RETURN;
    default:                          __quex_assert(false);
    }


    __quex_assert_no_passage();
_98:
    /* (RELOAD_FORWARD from 489)  */
    target_state_index = 27; target_state_else_index = 24;

    goto _255;


    __quex_assert_no_passage();
_100:
    /* (RELOAD_FORWARD from 490)  */
    target_state_index = 99; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_102:
    /* (RELOAD_FORWARD from 491)  */
    target_state_index = 101; target_state_else_index = 77;

    goto _255;


    __quex_assert_no_passage();
_104:
    /* (RELOAD_FORWARD from 495)  */
    target_state_index = 103; target_state_else_index = 81;

    goto _255;


    __quex_assert_no_passage();
_106:
    /* (RELOAD_FORWARD from 498)  */
    target_state_index = 105; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_108:
    /* (RELOAD_FORWARD from 503)  */
    target_state_index = 107; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_110:
    /* (RELOAD_FORWARD from 506)  */
    target_state_index = 109; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_112:
    /* (RELOAD_FORWARD from 507)  */
    target_state_index = 111; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_114:
    /* (RELOAD_FORWARD from 508)  */
    target_state_index = 113; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_116:
    /* (RELOAD_FORWARD from 511)  */
    target_state_index = 115; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_118:
    /* (RELOAD_FORWARD from 512)  */
    target_state_index = 117; target_state_else_index = 91;

    goto _255;


    __quex_assert_no_passage();
_120:
    /* (RELOAD_FORWARD from 513)  */
    target_state_index = 119; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_122:
    /* (RELOAD_FORWARD from 514)  */
    target_state_index = 121; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_124:
    /* (RELOAD_FORWARD from 515)  */
    target_state_index = 123; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_126:
    /* (RELOAD_FORWARD from 516)  */
    target_state_index = 125; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_128:
    /* (RELOAD_FORWARD from 517)  */
    target_state_index = 127; target_state_else_index = 92;

    goto _255;


    __quex_assert_no_passage();
_130:
    /* (RELOAD_FORWARD from 518)  */
    target_state_index = 129; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_132:
    /* (RELOAD_FORWARD from 519)  */
    target_state_index = 131; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_134:
    /* (RELOAD_FORWARD from 520)  */
    target_state_index = 133; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_136:
    /* (RELOAD_FORWARD from 521)  */
    target_state_index = 135; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_138:
    /* (RELOAD_FORWARD from 522)  */
    target_state_index = 137; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_140:
    /* (RELOAD_FORWARD from 523)  */
    target_state_index = 139; target_state_else_index = 93;

    goto _255;


    __quex_assert_no_passage();
_144:
    /* (RELOAD_FORWARD from 525)  */
    target_state_index = 143; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_146:
    /* (RELOAD_FORWARD from 526)  */
    target_state_index = 145; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_148:
    /* (RELOAD_FORWARD from 527)  */
    target_state_index = 147; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_150:
    /* (RELOAD_FORWARD from 528)  */
    target_state_index = 149; target_state_else_index = 95;

    goto _255;


    __quex_assert_no_passage();
_152:
    /* (RELOAD_FORWARD from 529)  */
    target_state_index = 151; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_154:
    /* (RELOAD_FORWARD from 530)  */
    target_state_index = 153; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_156:
    /* (RELOAD_FORWARD from 531)  */
    target_state_index = 155; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_158:
    /* (RELOAD_FORWARD from 532)  */
    target_state_index = 157; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_160:
    /* (RELOAD_FORWARD from 533)  */
    target_state_index = 159; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_162:
    /* (RELOAD_FORWARD from 534)  */
    target_state_index = 161; target_state_else_index = 96;

    goto _255;


    __quex_assert_no_passage();
_164:
    /* (RELOAD_FORWARD from 535)  */
    target_state_index = 163; target_state_else_index = 76;

    goto _255;


    __quex_assert_no_passage();
_166:
    /* (RELOAD_FORWARD from 536)  */
    target_state_index = 165; target_state_else_index = 97;

    goto _255;

_256:
/* RETURN -- after executing 'on_after_match' code. */
    return;


_257:
/* CONTINUE -- after executing 'on_after_match' code. */

_258:
/* CONTINUE -- without executing 'on_after_match' (e.g. on FAILURE). */


    /* Mode change = another function takes over the analysis.
     * => After mode change the analyzer function needs to be quit!
     * ASSERT: 'CONTINUE' after mode change is not allowed.                   */
    __quex_assert(   me->DEBUG_analyzer_function_at_entry 
                  == me->current_analyzer_function);


    if( Calc_lexer_TokenQueue_is_full(&self._token_queue) ) {
        return;
    }


goto _259;

    __quex_assert_no_passage();

    /* Following labels are referenced in macros. It cannot be detected
     * whether the macros are applied in user code or not. To avoid compiler.
     * warnings of unused labels, they are referenced in unreachable code.   */
    goto _256; /* in RETURN                */
    goto _257; /* in CONTINUE              */
    goto _258; /* in CONTINUE and skippers */

    goto _260; /* in QUEX_GOTO_STATE       */


    /* Prevent compiler warning 'unused variable'.                           */
    (void)Calc_lexer_LexemeNull;
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


#include "Calc_token-ids.h"




void
Calc_lexer_member_functions_assign(struct Calc_lexer_tag* me)
{
    me->reset = Calc_lexer_MF_reset;
    me->reset_file_name = Calc_lexer_MF_reset_file_name;
    me->reset_ByteLoader = Calc_lexer_MF_reset_ByteLoader;
    me->reset_memory = Calc_lexer_MF_reset_memory;
    me->include_push_file_name = Calc_lexer_MF_include_push_file_name;
    me->include_push_ByteLoader = Calc_lexer_MF_include_push_ByteLoader;
    me->include_push_memory = Calc_lexer_MF_include_push_memory;
    me->include_pop = Calc_lexer_MF_include_pop;
    me->include_stack_delete = Calc_lexer_MF_include_stack_delete;
    me->include_detect_recursion = Calc_lexer_MF_include_detect_recursion;
    me->run = Calc_lexer_MF_run;
    me->receive = Calc_lexer_MF_receive;
    me->token_p = Calc_lexer_MF_token_p;
    me->send = Calc_lexer_MF_send;
    me->send_n = Calc_lexer_MF_send_n;
    me->send_text = Calc_lexer_MF_send_text;
    me->send_string = Calc_lexer_MF_send_string;
    me->mode = Calc_lexer_MF_mode;
    me->set_mode_brutally = Calc_lexer_MF_set_mode_brutally;
    me->enter_mode = Calc_lexer_MF_enter_mode;
    me->pop_mode = Calc_lexer_MF_pop_mode;
    me->pop_drop_mode = Calc_lexer_MF_pop_drop_mode;
    me->push_mode = Calc_lexer_MF_push_mode;
    me->line_number = Calc_lexer_MF_line_number;
    me->line_number_at_begin = Calc_lexer_MF_line_number_at_begin;
    me->line_number_at_end = Calc_lexer_MF_line_number_at_end;
    me->line_number_set = Calc_lexer_MF_line_number_set;
    me->column_number = Calc_lexer_MF_column_number;
    me->column_number_at_begin = Calc_lexer_MF_column_number_at_begin;
    me->column_number_at_end = Calc_lexer_MF_column_number_at_end;
    me->column_number_set = Calc_lexer_MF_column_number_set;
    me->version = Calc_lexer_MF_version;
    me->print_this = Calc_lexer_MF_print_this;
    me->input_name = Calc_lexer_MF_input_name;
    me->input_name_set = Calc_lexer_MF_input_name_set;
    me->tell = Calc_lexer_MF_tell;
    me->seek = Calc_lexer_MF_seek;
    me->seek_forward = Calc_lexer_MF_seek_forward;
    me->seek_backward = Calc_lexer_MF_seek_backward;
    me->undo = Calc_lexer_MF_undo;
    me->undo_n = Calc_lexer_MF_undo_n;
    me->byte_order_reversion = Calc_lexer_MF_byte_order_reversion;
    me->byte_order_reversion_set = Calc_lexer_MF_byte_order_reversion_set;
    me->error_code_clear = Calc_lexer_MF_error_code_clear;
    me->error_code_is_void = Calc_lexer_MF_error_code_is_void;
    me->error_code_set_void = Calc_lexer_MF_error_code_set_void;
    me->error_code_set_if_first = Calc_lexer_MF_error_code_set_if_first;
    me->collect_user_memory = Calc_lexer_MF_collect_user_memory;
    me->resources_absent_mark = Calc_lexer_MF_resources_absent_mark;
    me->resources_absent = Calc_lexer_MF_resources_absent;
}


bool
Calc_lexer_user_constructor(struct Calc_lexer_tag* me)
{
    (void)me;

#define self  (*(struct Calc_lexer_tag*)me)
/* START: User's constructor extensions _______________________________________*/

/* END: _______________________________________________________________________*/
#undef self
    return true;
}

void
Calc_lexer_user_destructor(struct Calc_lexer_tag* me)
{
    (void)me;

#define self  (*(struct Calc_lexer_tag*)me)
/* START: User's constructor extensions _______________________________________*/

/* END: _______________________________________________________________________*/
#undef self
}

bool
Calc_lexer_user_reset(struct Calc_lexer_tag* me)
{
    (void)me;

#define self  (*(struct Calc_lexer_tag*)me)
/* START: User's 'reset' ______________________________________________________*/

/* END: _______________________________________________________________________*/
#undef self
    return true;
}

void
Calc_lexer_user_print(struct Calc_lexer_tag* me)
{
    (void)me;

#define self  (*(struct Calc_lexer_tag*)me)
/* START: User's constructor extensions _______________________________________*/

/* END: _______________________________________________________________________*/
#undef self
}

bool
Calc_lexer_user_memento_pack(struct Calc_lexer_tag* me, 
                             const char*         InputName, 
                             Calc_lexer_Memento* memento) 
{
    (void)me; (void)memento; (void)InputName;

#define self  (*(struct Calc_lexer_tag*)me)
/* START: User's memento 'pack' _______________________________________________*/

/* END: _______________________________________________________________________*/
#undef self
    return true;
}

void
Calc_lexer_user_memento_unpack(struct Calc_lexer_tag*  me, 
                               Calc_lexer_Memento*  memento)
{
    (void)me; (void)memento;

#define self  (*(struct Calc_lexer_tag*)me)
/* START: User's memento 'unpack' _____________________________________________*/

/* END: _______________________________________________________________________*/
#undef self
}

const char*
Calc_lexer_map_token_id_to_name(const Calc_lexer_token_id_t TokenID)
/* NOTE: This function is not element of the token namespace, since the token
 *       identifiers are lied to the generated lexical analyzer. The token class
 *       may be used over multiple lexical analyzers.                         */
{
   switch( TokenID ) {
   default: {
       return "<NUMERIC VALUE OF TOKEN-ID UNDEFINED>";
   }

   case TKN_TERMINATION:    return "<TERMINATION>";
   case TKN_UNINITIALIZED:  return "<UNINITIALIZED>";

   case 0x000028: return "UCS_0x000028";
   case 0x000029: return "UCS_0x000029";
   case 0x00002A: return "UCS_0x00002A";
   case 0x00002B: return "UCS_0x00002B";
   case 0x00002D: return "UCS_0x00002D";
   case 0x00002F: return "UCS_0x00002F";
   case 0x00003D: return "UCS_0x00003D";
   case 0x00005E: return "UCS_0x00005E";
   case TKN_BRACKET_CLOSE:  return "BRACKET_CLOSE";
   case TKN_BRACKET_OPEN:   return "BRACKET_OPEN";
   case TKN_DUMMY:          return "DUMMY";
   case TKN_EXIT:           return "EXIT";
   case TKN_EXIT_COMMAND:   return "EXIT_COMMAND";
   case TKN_EXPECT:         return "EXPECT";
   case TKN_IDENTIFIER:     return "IDENTIFIER";
   case TKN_NEG:            return "NEG";
   case TKN_NEWLINE:        return "NEWLINE";
   case TKN_NUM:            return "NUM";
   case TKN_PRINT:          return "PRINT";
   case TKN_SEMICOLON:      return "SEMICOLON";
   case TKN_SEND:           return "SEND";
   case TKN_STRUCT:         return "STRUCT";
   case TKN_TYPE_DOUBLE:    return "TYPE_DOUBLE";
   case TKN_TYPE_INT:       return "TYPE_INT";


   }
}





