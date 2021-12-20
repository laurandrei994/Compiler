/* -*- C++ -*-   vim: set syntax=cpp:
 *
 * (C) 2005-2017 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                                                     */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__CONFIGURATION
#define QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__CONFIGURATION

/*______________________________________________________________________________
 * TYPE DEFINITIONS                                                 -- ADAPTABLE
 *                                                                            */
typedef uint8_t Calc_lexer_lexatom_t;
typedef uint32_t Calc_lexer_token_id_t;
typedef size_t Calc_lexer_token_line_n_t;
typedef size_t Calc_lexer_token_column_n_t;
typedef int Calc_lexer_acceptance_id_t;
typedef intmax_t Calc_lexer_stream_position_t;
typedef int32_t Calc_lexer_goto_label_t;


/*______________________________________________________________________________
 * CONFIGURATION PARAMETERS (I)                                     -- ADAPTABLE 
 *                                                                            */
#define QUEX_Calc_lexer_SETTING_BUFFER_SIZE 131072
#define QUEX_Calc_lexer_SETTING_BUFFER_FALLBACK_N 0
#define QUEX_Calc_lexer_SETTING_BUFFER_SIZE_MIN QUEX_Calc_lexer_SETTING_BUFFER_SIZE
#define QUEX_Calc_lexer_SETTING_INDENTATION_STACK_SIZE 64
#define QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_LOADER_CONVERTER_BUFFER_SIZE (size_t)65536
#define QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_LOADER_SEEK_BUFFER_SIZE 512
#define QUEX_Calc_lexer_SETTING_MODE_STACK_SIZE (size_t)64
#define QUEX_Calc_lexer_SETTING_TOKEN_QUEUE_SIZE (size_t)64

/*______________________________________________________________________________
 * CONFIGURATION PARAMETERS (II)                                    -- IMMUTABLE 
 *                                                                            */
#define QUEX_Calc_lexer_SETTING_VERSION "0.70.0"
#define QUEX_Calc_lexer_SETTING_ANALYZER_VERSION "0.0.0-pre-release"
#define QUEX_Calc_lexer_SETTING_BUILD_DATE "Fri Dec 18 12:32:44 2020"
#define QUEX_Calc_lexer_SETTING_MODE_INITIAL_P &Calc_lexer_ONE_AND_ONLY
#define QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER 0x0
#define QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_NEWLINE 10
#define QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_PATH_TERMINATION 0x1
#define QUEX_Calc_lexer_SETTING_BUFFER_FALLBACK_N 0
#define QUEX_Calc_lexer_SETTING_FALLBACK_MANDATORY false

/*______________________________________________________________________________
 * DERIVED SETTINGS                                                 -- IMMUTABLE
 *                                                                            */
#if    defined(QUEX_SETTING_BUFFER_SIZE_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_SIZE_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_FALLBACK_N_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_FALLBACK_N_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_SIZE_MIN_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_SIZE_MIN_EXT) \
   ||  defined(QUEX_SETTING_INDENTATION_STACK_SIZE_EXT) || defined(QUEX_Calc_lexer_SETTING_INDENTATION_STACK_SIZE_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_LEXATOM_LOADER_CONVERTER_BUFFER_SIZE_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_LOADER_CONVERTER_BUFFER_SIZE_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_LEXATOM_LOADER_SEEK_BUFFER_SIZE_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_LOADER_SEEK_BUFFER_SIZE_EXT) \
   ||  defined(QUEX_SETTING_MODE_STACK_SIZE_EXT) || defined(QUEX_Calc_lexer_SETTING_MODE_STACK_SIZE_EXT) \
   ||  defined(QUEX_SETTING_TOKEN_QUEUE_SIZE_EXT) || defined(QUEX_Calc_lexer_SETTING_TOKEN_QUEUE_SIZE_EXT) \
   ||  defined(QUEX_SETTING_VERSION_EXT) || defined(QUEX_Calc_lexer_SETTING_VERSION_EXT) \
   ||  defined(QUEX_SETTING_ANALYZER_VERSION_EXT) || defined(QUEX_Calc_lexer_SETTING_ANALYZER_VERSION_EXT) \
   ||  defined(QUEX_SETTING_BUILD_DATE_EXT) || defined(QUEX_Calc_lexer_SETTING_BUILD_DATE_EXT) \
   ||  defined(QUEX_SETTING_MODE_INITIAL_P_EXT) || defined(QUEX_Calc_lexer_SETTING_MODE_INITIAL_P_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_LEXATOM_BUFFER_BORDER_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_BUFFER_BORDER_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_LEXATOM_NEWLINE_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_NEWLINE_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_LEXATOM_PATH_TERMINATION_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_LEXATOM_PATH_TERMINATION_EXT) \
   ||  defined(QUEX_SETTING_BUFFER_FALLBACK_N_EXT) || defined(QUEX_Calc_lexer_SETTING_BUFFER_FALLBACK_N_EXT) \
   ||  defined(QUEX_SETTING_FALLBACK_MANDATORY_EXT) || defined(QUEX_Calc_lexer_SETTING_FALLBACK_MANDATORY_EXT)
#   error "*_EXT macro detected but code not generated with '--config-by-macro'"
#endif

/* Asserts are enabled by default. The lexer emits a warning message and tells
 * how to deactivate them. Asserts can be DEACTIVATED as follows.
 *
 *  'NDEBUG' (from Standard 'assert.h') => avoid surprises.
 *  'QUEX_OPTION_ASSERTS_DISABLED_EXT'  => solely prevent Quex's asserts.     
 *                                                                            */
#if defined(NDEBUG) 
#   ifdef     QUEX_OPTION_ASSERTS
#      warning "undef 'QUEX_OPTION_ASSERTS' by 'NDEBUG'"
#      undef  QUEX_OPTION_ASSERTS
#   endif
#elif defined(QUEX_OPTION_ASSERTS_DISABLED_EXT)
#   ifdef     QUEX_OPTION_ASSERTS
#      warning "undef 'QUEX_OPTION_ASSERTS' by 'QUEX_OPTION_ASSERTS_DISABLED_EXT'"
#      undef  QUEX_OPTION_ASSERTS
#   endif
#elif ! defined(QUEX_OPTION_ASSERTS)
#   define QUEX_OPTION_ASSERTS
#endif

/* Special Case MinGW: At the time of this writing (2009y09m23d) it does 
 * not support 'wchart_t'.                                                    */
#if (defined (__GLIBCPP__) || defined(__GLIBCXX__)) && ! defined  (_GLIBCXX_USE_WCHAR_T)
#   define  QUEX_OPTION_WCHAR_T_DISABLED_EXT
#endif

/* No external definition of QUEX_Calc_lexer_SETTING_USER_CLASS_DECLARATION_EPILOG_EXT
 * => define as empty.                                                        */
#ifndef   QUEX_Calc_lexer_SETTING_USER_CLASS_DECLARATION_EPILOG_EXT
#  define QUEX_Calc_lexer_SETTING_USER_CLASS_DECLARATION_EPILOG_EXT
#endif

#define QUEX_INDICATE_CONFIGURATION_FILE_PASSED
#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__CONFIGURATION */