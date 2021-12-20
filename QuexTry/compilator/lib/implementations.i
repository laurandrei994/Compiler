/* -*- C++ -*- vim:set syntax=cpp:
 * (C) 2005-2010 Frank-Rene Schaefer
 * ABSOLUTELY NO WARRANTY                      */
#ifndef QUEX_INCLUDE_GUARD_compilator__IMPLEMENTATIONS_I
#define QUEX_INCLUDE_GUARD_compilator__IMPLEMENTATIONS_I

#if ! defined(__cplusplus)

#include "compilator\lib\analyzer/asserts.i"
#include "compilator\lib\buffer/asserts.i"

#include "compilator\compilator-token.i"
#include "compilator\lib\token/TokenQueue.i"
#include "compilator\lib\token/receiving.i"

#include "compilator\lib\analyzer/member/mode-handling.i"
#include "compilator\lib\analyzer/member/misc.i"
#include "compilator\lib\analyzer/member/navigation.i"

#include "compilator\lib\analyzer/struct/constructor.i"
#include "compilator\lib\analyzer/struct/include-stack.i"
#include "compilator\lib\analyzer/struct/reset.i"

#include "compilator\lib\buffer/Buffer.i"
#include "compilator\lib\buffer/lexatoms/LexatomLoader.i"
#include "compilator\lib\buffer/bytes/ByteLoader.i"

#include "compilator\lib\analyzer/Mode.i"

#include "compilator\lib\lexeme/basics.i"
#include "compilator\lib\analyzer/Counter.i"

#endif

#include "compilator\lib\quex/MemoryManager.i"
#include "compilator\lib\lexeme/converter-from-lexeme.i"



compilator_lexatom_t   compilator_LexemeNull = (compilator_lexatom_t)0;




#endif /* QUEX_INCLUDE_GUARD_compilator__IMPLEMENTATIONS_I */
