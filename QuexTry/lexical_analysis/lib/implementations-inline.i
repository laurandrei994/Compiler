/* -*- C++ -*- vim:set syntax=cpp:
 * (C) 2005-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                      */
#ifndef QUEX_INCLUDE_GUARD_Calc_lexer__IMPLEMENTATIONS_INLINE_I
#define QUEX_INCLUDE_GUARD_Calc_lexer__IMPLEMENTATIONS_INLINE_I

#if defined(__cplusplus)

#include "lexical_analysis/lib/analyzer/asserts.i"
#include "lexical_analysis/lib/buffer/asserts.i"

#include "lexical_analysis/Calc_lexer-token.c"
#include "lexical_analysis/lib/token/TokenQueue.i"
#include "lexical_analysis/lib/token/receiving.i"

#include "lexical_analysis/lib/analyzer/member/mode-handling.i"
#include "lexical_analysis/lib/analyzer/member/misc.i"
#include "lexical_analysis/lib/analyzer/member/navigation.i"

#include "lexical_analysis/lib/analyzer/struct/constructor.i"
#include "lexical_analysis/lib/analyzer/struct/include-stack.i"
#include "lexical_analysis/lib/analyzer/struct/reset.i"

#include "lexical_analysis/lib/buffer/Buffer.i"
#include "lexical_analysis/lib/buffer/lexatoms/LexatomLoader.i"
#include "lexical_analysis/lib/buffer/bytes/ByteLoader.i"

#include "lexical_analysis/lib/analyzer/Mode.i"

#include "lexical_analysis/lib/lexeme/basics.i"
#include "lexical_analysis/lib/analyzer/Counter.i"

#endif

#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__ANALYZER__HEADERS_I */
