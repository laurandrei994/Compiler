/* -*- C++ -*-   vim: set syntax=cpp:
 * CONTENT: 
 *
 * (1) Includes for required standard headers.
 * (2) Definitions of options and settings for the particular application.
 * (3) #include "lexical_analysis/lib/definitions"
 * (4) Lexical FSM class Calc_lexer and its memento class.
 * (5) Constructor and init core of Calc_lexer.
 * (6) Memento pack and unpack functions.
 *
 * File content generated by Quex 0.70.0.
 *
 * (C) 2005-2012 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                                                      */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__GENERATED
#define QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__GENERATED

#include <stddef.h>
#include "lexical_analysis/lib/quex/compatibility/stdint.h"
#include "lexical_analysis/Calc_lexer-configuration.h"

#include "lexical_analysis/lib/definitions"

 
struct Calc_lexer_Engine_tag;
struct Calc_lexer_Memento_tag;
struct Calc_lexer_tag;    /* Calc_lexer */
typedef void  (*Calc_lexer_AnalyzerFunctionP)(struct Calc_lexer_tag*);

/* Token Class Declaration must preceed the user's header, so that the user
 * can refer to it at ease.                                                    */

struct Calc_lexer_Token_tag;


/* START: User defined header content ___________________________________________
 *        Must come before token class definition, since the token class 
 *        might rely on contents of the header.                                */


/* END: _______________________________________________________________________*/

#include "lexical_analysis/lib/declarations"

#include "Calc_token-ids.h"
 
extern const char* Calc_lexer_map_token_id_to_name(const Calc_lexer_token_id_t TokenID);
 
#include "lexical_analysis/Calc_lexer-token.h"

 

extern Calc_lexer_Mode  Calc_lexer_ONE_AND_ONLY;


extern  void Calc_lexer_ONE_AND_ONLY_analyzer_function(struct Calc_lexer_tag* me);
#ifdef QUEX_OPTION_ASSERTS
extern  bool Calc_lexer_ONE_AND_ONLY_has_base(const Calc_lexer_Mode* mode);
#endif
#ifdef QUEX_OPTION_ASSERTS
extern  bool Calc_lexer_ONE_AND_ONLY_has_entry_from(const Calc_lexer_Mode* mode);
#endif
#ifdef QUEX_OPTION_ASSERTS
extern  bool Calc_lexer_ONE_AND_ONLY_has_exit_to(const Calc_lexer_Mode* mode);
#endif
extern  void Calc_lexer_ONE_AND_ONLY_on_buffer_before_change(void* aux);
extern  void Calc_lexer_ONE_AND_ONLY_on_buffer_overflow(void* aux);
extern  void Calc_lexer_ONE_AND_ONLY_on_entry(struct Calc_lexer_tag* me, const Calc_lexer_Mode* mode);
extern  void Calc_lexer_ONE_AND_ONLY_on_exit(struct Calc_lexer_tag* me, const Calc_lexer_Mode* mode);



typedef bool (*Calc_lexer_callback_on_token_type)(struct Calc_lexer_Token_tag*);

typedef struct QUEX_Calc_lexer_SETTING_USER_CLASS_DECLARATION_EPILOG_EXT Calc_lexer_Memento_tag {
    /* In contrary to C++ implementation, constructors and destructors 
     * are called explicitly.                                                 */

    char*                               __input_name;
    Calc_lexer_Buffer                   buffer;

    const struct Calc_lexer_Mode_tag*   __current_mode_p; 
    Calc_lexer_AnalyzerFunctionP        current_analyzer_function;
#   if defined(QUEX_OPTION_ASSERTS)
    Calc_lexer_AnalyzerFunctionP        DEBUG_analyzer_function_at_entry;
#   endif
           Calc_lexer_Counter  counter;
    
    struct Calc_lexer_Memento_tag*      _parent_memento;

/* START: User's memento extentions __________________________________________*/

/* END: ______________________________________________________________________*/
} Calc_lexer_Memento;

typedef struct QUEX_Calc_lexer_SETTING_USER_CLASS_DECLARATION_EPILOG_EXT Calc_lexer_tag {
    /* __( Data Members )_______________________________________________________
     *                                                                        */
    Calc_lexer_Buffer               buffer;
    Calc_lexer_TokenQueue           _token_queue;  
    Calc_lexer_ModeStack            _mode_stack;

    E_Error                         error_code;
    char*                           __input_name;

    const Calc_lexer_Mode*          __current_mode_p; 
    /* Shortcut to current mode's analyzer function.                          */
    Calc_lexer_AnalyzerFunctionP    current_analyzer_function;
#   if defined(QUEX_OPTION_ASSERTS)
    /* Backup of analyzer's function pointer => mode change detection.        */
    Calc_lexer_AnalyzerFunctionP    DEBUG_analyzer_function_at_entry;
#   endif
           Calc_lexer_Counter counter;
    
    Calc_lexer_Memento*                _parent_memento;
    /*__( Reset )_______________________________________________________________
     *                                                                        */
    bool (*reset)(struct Calc_lexer_tag* me);
    bool (*reset_file_name)(struct Calc_lexer_tag* me, const char* FileName, Calc_lexer_Converter* Converter);
    bool (*reset_ByteLoader)(struct Calc_lexer_tag* me, Calc_lexer_ByteLoader* byte_loader, Calc_lexer_Converter* Converter);
    bool (*reset_memory)(struct Calc_lexer_tag* me, Calc_lexer_lexatom_t* BufferMemoryBegin, size_t BufferMemorySize, Calc_lexer_lexatom_t* BufferEndOfContentP);

    /*__( Include From and To Substream )_______________________________________
     *                                                                        */
    bool (*include_push_file_name)(struct Calc_lexer_tag* me, const char* FileName, Calc_lexer_Converter* Converter);
    bool (*include_push_ByteLoader)(struct Calc_lexer_tag* me, const char* InputName, Calc_lexer_ByteLoader* byte_loader, Calc_lexer_Converter* Converter);
    bool (*include_push_memory)(struct Calc_lexer_tag* me, const char* InputName, Calc_lexer_lexatom_t* BufferMemoryBegin, size_t BufferMemorySize, Calc_lexer_lexatom_t* BufferEndOfContentP);
    bool (*include_pop)(struct Calc_lexer_tag* me);
    void (*include_stack_delete)(struct Calc_lexer_tag* me);
    bool (*include_detect_recursion)(struct Calc_lexer_tag* me, const char* InputName);

    /*__( Receiving Tokens -- from outside lexer )_____________________________
     *                                                                       */
    bool (*run)(struct Calc_lexer_tag* me, Calc_lexer_callback_on_token_type on_token, bool ErrorPrintF);
    void (*receive)(struct Calc_lexer_tag* me, struct Calc_lexer_Token_tag** token_pp);

    /*__( Sending Tokens -- from inside lexer )________________________________
     *                                                                       */
    struct Calc_lexer_Token_tag* (*token_p)(struct Calc_lexer_tag* me);

    void (*send)(struct Calc_lexer_tag* me, Calc_lexer_token_id_t Id);
    void (*send_n)(struct Calc_lexer_tag* me, Calc_lexer_token_id_t Id, size_t RepetitionN);
    bool (*send_text)(struct Calc_lexer_tag* me, Calc_lexer_token_id_t Id, Calc_lexer_lexatom_t* BeginP, Calc_lexer_lexatom_t* EndP);
    bool (*send_string)(struct Calc_lexer_tag* me, Calc_lexer_token_id_t Id, Calc_lexer_lexatom_t* ZeroTerminatedString);

    /*__( Mode Handling )______________________________________________________
     *                                                                       */
    const Calc_lexer_Mode* (*mode)(struct Calc_lexer_tag* me);
    void (*set_mode_brutally)(struct Calc_lexer_tag* me, const Calc_lexer_Mode* Mode);
    void (*enter_mode)(struct Calc_lexer_tag* me, const Calc_lexer_Mode* TargetMode);

    void (*pop_mode)(struct Calc_lexer_tag* me);
    void (*pop_drop_mode)(struct Calc_lexer_tag* me);
    void (*push_mode)(struct Calc_lexer_tag* me, Calc_lexer_Mode* new_mode);

    /*__( Line/Column Counter )________________________________________________
     *                                                                       */
    size_t (*line_number)(const struct Calc_lexer_tag* me);
    size_t (*line_number_at_begin)(const struct Calc_lexer_tag* me);
    size_t (*line_number_at_end)(const struct Calc_lexer_tag* me);
    void (*line_number_set)(struct Calc_lexer_tag* me, size_t Y);

    size_t (*column_number)(const struct Calc_lexer_tag* me);
    size_t (*column_number_at_begin)(const struct Calc_lexer_tag* me);
    size_t (*column_number_at_end)(const struct Calc_lexer_tag* me);
    void (*column_number_set)(struct Calc_lexer_tag* me, size_t X);

    /*__( Indentation )________________________________________________________
     *                                                                       */
    

    /*__( General Information )________________________________________________
     *                                                                       */
    const char* (*version)(struct Calc_lexer_tag* me);
    void (*print_this)(struct Calc_lexer_tag* me);
    const char* (*input_name)(struct Calc_lexer_tag* me);
    bool (*input_name_set)(struct Calc_lexer_tag* me, const char* InputName);

    /*__( Navigation: Tell/Seek )______________________________________________
     *                                                                       */
    size_t (*tell)(struct Calc_lexer_tag* me);
    void (*seek)(struct Calc_lexer_tag* me, const size_t CharacterIndex);
    void (*seek_forward)(struct Calc_lexer_tag* me, const size_t CharacterN);
    void (*seek_backward)(struct Calc_lexer_tag* me, const size_t CharacterN);
                
    void (*undo)(struct Calc_lexer_tag* me);
    void (*undo_n)(struct Calc_lexer_tag* me, size_t DeltaN_Backward);

    /*__( Byte Order Reversion Activation / Deactivation )_____________________
     *                                                                       */
    bool (*byte_order_reversion)(struct Calc_lexer_tag* me);
    void (*byte_order_reversion_set)(struct Calc_lexer_tag* me, bool Value);

    /*__( Error Codes )________________________________________________________
     *                                                                       */
    void (*error_code_clear)(struct Calc_lexer_tag* me);
    bool (*error_code_is_void)(struct Calc_lexer_tag* me);
    void (*error_code_set_void)(struct Calc_lexer_tag* me);
    void (*error_code_set_if_first)(struct Calc_lexer_tag* me, E_Error ErrorCode);

    /*__( Deep Resources )_____________________________________________________
     *                                                                       */
    void (*collect_user_memory)(struct Calc_lexer_tag* me, Calc_lexer_lexatom_t** user_memory_p);
    void (*resources_absent_mark)(struct Calc_lexer_tag* me);
    bool (*resources_absent)(struct Calc_lexer_tag* me);

#define self  (*(struct Calc_lexer_tag*)this)
/* START: User's class body extensions _______________________________________*/

/* END: ______________________________________________________________________*/
#undef  self

} Calc_lexer;

  void Calc_lexer_member_functions_assign(struct Calc_lexer_tag* me);



#include "lexical_analysis/lib/implementations-inline.i"

#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__GENERATED */