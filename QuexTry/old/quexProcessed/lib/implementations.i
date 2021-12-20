/* -*- C++ -*- vim:set syntax=cpp:
 * (C) 2005-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                      */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__IMPLEMENTATIONS_I
#define QUEX_INCLUDE_GUARD_quexProcessed__IMPLEMENTATIONS_I

#if ! defined(__cplusplus)

#include "quexProcessed/lib/analyzer/asserts.i"
#include "quexProcessed/lib/buffer/asserts.i"

#include "quexProcessed/quexProcessed-token.i"
#include "quexProcessed/lib/token/TokenQueue.i"
#include "quexProcessed/lib/token/receiving.i"

#include "quexProcessed/lib/analyzer/member/mode-handling.i"
#include "quexProcessed/lib/analyzer/member/misc.i"
#include "quexProcessed/lib/analyzer/member/navigation.i"

#include "quexProcessed/lib/analyzer/struct/constructor.i"
#include "quexProcessed/lib/analyzer/struct/include-stack.i"
#include "quexProcessed/lib/analyzer/struct/reset.i"

#include "quexProcessed/lib/buffer/Buffer.i"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader.i"
#include "quexProcessed/lib/buffer/bytes/ByteLoader.i"

#include "quexProcessed/lib/analyzer/Mode.i"

#include "quexProcessed/lib/lexeme/basics.i"
#include "quexProcessed/lib/analyzer/Counter.i"

#endif

#include "quexProcessed/lib/quex/MemoryManager.i"
#include "quexProcessed/lib/lexeme/converter-from-lexeme.i"



quexProcessed_lexatom_t   quexProcessed_LexemeNull = (quexProcessed_lexatom_t)0;




#endif /* QUEX_INCLUDE_GUARD_quexProcessed__IMPLEMENTATIONS_I */
