/* vim:set ft=c: -*- C++ -*- */
#ifndef QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_I
#define QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_I

#include "compilator\lib\buffer/asserts"
#include "compilator\lib\definitions"
#include "compilator\lib\buffer/Buffer"
#include "compilator\lib\buffer/Buffer_print.i"
#include "compilator\lib\buffer/lexatoms/LexatomLoader"
#include "compilator\lib\quex/asserts"
#include "compilator\lib\quex/MemoryManager"



inline void      compilator_Buffer_init_content(compilator_Buffer* me, 
                                                     compilator_lexatom_t* EndOfFileP);
inline void      compilator_Buffer_init_content_core(compilator_Buffer*        me, 
                                                          compilator_stream_position_t LI_Begin,
                                                          compilator_stream_position_t LI_EndOfStream,
                                                          compilator_lexatom_t*        EndOfFileP);
inline void      compilator_Buffer_init_analyzis(compilator_Buffer*   me);
inline void      compilator_Buffer_init_analyzis_core(compilator_Buffer*        me,
                                                           compilator_lexatom_t*        ReadP,
                                                           compilator_lexatom_t*        LexatomStartP,
                                                           compilator_lexatom_t         LexatomAtLexemeStart,
                                                           compilator_lexatom_t         LexatomBeforeLexemeStart,
                                                           compilator_stream_position_t BackupLexatomIndexOfReadP);

inline void      compilator_Buffer_on_overflow_DEFAULT(void*              aux, 
                                                            compilator_Buffer* buffer, 
                                                            bool               ForwardF);
inline void      compilator_Buffer_on_before_buffer_change_DEFAULT(void*  aux,
                                                                        const  compilator_lexatom_t*, 
                                                                        const  compilator_lexatom_t*);
inline void      compilator_Buffer_member_functions_assign(compilator_Buffer* me);

inline void
compilator_Buffer_construct(compilator_Buffer*        me, 
                            compilator_LexatomLoader* filler,
                            compilator_lexatom_t*        memory,
                            const size_t              MemorySize,
                            compilator_lexatom_t*        EndOfFileP,
                            const ptrdiff_t           FallbackN,
                            E_Ownership               Ownership,
                            compilator_Buffer*        IncludingBuffer)
{
    __quex_assert(QUEX_compilator_SETTING_BUFFER_SIZE_MIN <= QUEX_compilator_SETTING_BUFFER_SIZE);

    /* Ownership of InputMemory is passed to 'me->_memory'.                  */
    compilator_BufferMemory_construct(&me->_memory, memory, MemorySize, 
                                      Ownership, IncludingBuffer); 
    
    me->filler = filler;
    compilator_Buffer_member_functions_assign(me);

    /* Event handlers.                                                       */
    compilator_Buffer_callbacks_set(me, (void (*)(void*))0, (void (*)(void*))0, (void*)0);

    /* Initialize.                                                           */
    compilator_Buffer_init(me, EndOfFileP);
    me->_fallback_n = FallbackN;

    compilator_Buffer_assert_consistency(me);
}

inline void
compilator_Buffer_member_functions_assign(compilator_Buffer* me)
{
    me->fill                = compilator_Buffer_fill;
    me->fill_prepare        = compilator_Buffer_fill_prepare;
    me->fill_finish         = compilator_Buffer_fill_finish;

    me->begin               = compilator_Buffer_memory_begin;
    me->end                 = compilator_Buffer_memory_end;
    me->size                = compilator_Buffer_memory_size;

    me->content_space_end   = compilator_Buffer_memory_content_space_end;
    me->content_space_size  = compilator_Buffer_memory_content_space_size;

    me->content_begin       = compilator_Buffer_memory_content_begin;
    me->content_end         = compilator_Buffer_memory_content_end;
    me->content_size        = compilator_Buffer_memory_content_size;
}

inline compilator_lexatom_t*   compilator_Buffer_memory_begin(const compilator_Buffer* me) { return me->_memory._front; }
inline compilator_lexatom_t*   compilator_Buffer_memory_end(const compilator_Buffer* me)   { return &me->_memory._back[1]; }
inline ptrdiff_t            compilator_Buffer_memory_size(const compilator_Buffer* me)  { return &me->_memory._back[1] - me->_memory._front; }

inline compilator_lexatom_t*   compilator_Buffer_memory_content_space_end(const compilator_Buffer* me)   { return me->_memory._back; }
inline ptrdiff_t            compilator_Buffer_memory_content_space_size(const compilator_Buffer* me)  { return me->_memory._back - &me->_memory._front[1]; }

inline compilator_lexatom_t*   compilator_Buffer_memory_content_begin(const compilator_Buffer* me) { return &me->_memory._front[1]; }
inline compilator_lexatom_t*   compilator_Buffer_memory_content_end(const compilator_Buffer* me)   { return me->input.end_p; }
inline ptrdiff_t            compilator_Buffer_memory_content_size(const compilator_Buffer* me)  { return me->input.end_p - &me->_memory._front[1]; }

inline void
compilator_Buffer_init(compilator_Buffer* me, compilator_lexatom_t* EndOfFileP)
{
    compilator_Buffer_init_content(me, EndOfFileP);
    compilator_Buffer_init_analyzis(me); 
}

inline void
compilator_Buffer_destruct(compilator_Buffer* me)
/* Destruct 'me' and mark all resources as absent.                            */
{
    if( compilator_Buffer_resources_absent(me) ) {
        return;
    }
    compilator_Buffer_callbacks_on_buffer_before_change(me);

    if( me->filler ) {
        me->filler->delete_self(me->filler); 
    }
    compilator_BufferMemory_destruct(&me->_memory);
    compilator_Buffer_resources_absent_mark(me);
}

inline void
compilator_Buffer_shallow_copy(compilator_Buffer* drain, const compilator_Buffer* source)
/*    ,.
 *   /  \   DANGER: Do not use this function, except that you totally 
 *  /    \                understand its implications!
 *  '----'
 * Copy indices and references *as is*. The purpose of this function is solely
 * to copy the setup of a buffer to a safe place and restore it. 
 *
 *           NOT TO BE USED AS A REPLACEMENT FOR COPYING/CLONING!
 *
 * At the time of this writing, the only propper application is when a backup 
 * is generated in a memento. When it is restored in the 'real' buffer object 
 * the pointers point to the right places and the ownership is handled propperly.
 *
 * The caller of this function MUST determine whether 'drain' or 'source'
 * maintains ownership.                                                       */
{
    compilator_Buffer_assert_consistency(source);
    *drain = *source;
}

inline bool 
compilator_Buffer_has_intersection(compilator_Buffer*       me,
                                   const compilator_lexatom_t* Begin,
                                   ptrdiff_t                Size)
/* RETURNS: 'true' if buffer's memory intersects with the region given
 *                 by 'Begin' and 'Size'.
 *          'false', else.                                                    */
{
    const compilator_lexatom_t* End      = &Begin[Size];
    compilator_Buffer*       root     = compilator_Buffer_nested_find_root(me);
    const compilator_lexatom_t* my_begin = root->begin(root);
    const compilator_lexatom_t* my_end   = me->end(me);

    /* No intersection in two cases:
     * (1) second interval lies completely before: 'End <= my_begin'.
     * (2) second interval lies completely after:  'Begin >= my_begin'.       */
    if( Begin >= my_end || End <= my_begin ) return false;
    else                                     return true;
}

inline void
compilator_Buffer_resources_absent_mark(compilator_Buffer* me)
/* This function is to be called in case that construction failed. It marks
 * all resources as absent, such that destruction can handle it safely. 
 * Nevertheless, the member functions are put in place to be be sure that the
 * object is functional.                                                      */
{
    compilator_Buffer_member_functions_assign(me);
    compilator_Buffer_callbacks_set(me, (void (*)(void*))0,
                                         (void (*)(void*))0, (void*)0);
    me->filler = (compilator_LexatomLoader*)0;
    compilator_BufferMemory_resources_absent_mark(&me->_memory);
    compilator_Buffer_member_functions_assert(me);
}

inline bool    
compilator_Buffer_resources_absent(compilator_Buffer* me)
/* RETURNS: 'true' if all resources of buffer are absent. Then, nothing needs
 *                 to be freed.
 *          'false' else.                                                     */ 
{
    return    me->filler == (compilator_LexatomLoader*)0 
           && compilator_BufferMemory_resources_absent(&me->_memory);
}

inline void     
compilator_Buffer_dysfunctional_set(compilator_Buffer*  me)
/* Set buffer into dysfunctional state, i.e. the buffer is inable to operarate.
 * Shall be applied only upon failure beyond repair.                          */
{
    compilator_Buffer_init_analyzis_core(me, 
    /* ReadP                          */ (compilator_lexatom_t*)0,
    /* LexatomStartP                  */ (compilator_lexatom_t*)0,
    /* LexatomAtLexemeStart           */ (compilator_lexatom_t)0,                                   
    /* LexatomBeforeLexemeStart       */ (compilator_lexatom_t)0,
    /* BackupLexatomIndexOfReadP      */ (compilator_stream_position_t)-1);
    compilator_Buffer_member_functions_assert(me);
}

inline bool     
compilator_Buffer_dysfunctional(compilator_Buffer*  me)
/* RETURNS: 'true' if buffer is in dysfunctional state.
 *          'false', else.                                                    */
{
    return    me->_read_p                         == (compilator_lexatom_t*)0
           && me->_lexeme_start_p                 == (compilator_lexatom_t*)0
           && me->_lexatom_at_lexeme_start        == (compilator_lexatom_t)0                                   
           && me->_backup_lexatom_index_of_lexeme_start_p == (compilator_stream_position_t)-1
           ;
}

inline void
compilator_Buffer_init_analyzis(compilator_Buffer*   me) 
/* Initialize:  _read_p                          
 *              _lexeme_start_p                 
 *              _lexatom_at_lexeme_start     
 *              _lexatom_before_lexeme_start                                  */
{
    if( ! me->_memory._front ) {
        /* No memory => FSM is put into a non-functional state.               */
        compilator_Buffer_init_analyzis_core(me, 
        /* ReadP                          */ (compilator_lexatom_t*)0,
        /* LexatomStartP                  */ (compilator_lexatom_t*)0,
        /* LexatomAtLexemeStart           */ (compilator_lexatom_t)0,                                   
        /* LexatomBeforeLexemeStart       */ (compilator_lexatom_t)0,
        /* BackupLexatomIndexOfReadP      */ (compilator_stream_position_t)-1);
    }
    else {
        /* The first state in the state machine does not increment. 
         * => input pointer is set to the first position, not before.         */
        compilator_Buffer_init_analyzis_core(me, 
        /* ReadP                          */ me->content_begin(me),
        /* LexatomStartP                  */ me->content_begin(me),
        /* LexatomAtLexemeStart           */ (compilator_lexatom_t)0,
        /* LexatomBeforeLexemeStart       */ QUEX_compilator_SETTING_BUFFER_LEXATOM_NEWLINE,
        /* BackupLexatomIndexOfReadP      */ (compilator_stream_position_t)-1);
    }
}

inline void
compilator_Buffer_init_analyzis_core(compilator_Buffer*        me,
                                     compilator_lexatom_t*        ReadP,
                                     compilator_lexatom_t*        LexatomStartP,
                                     compilator_lexatom_t         LexatomAtLexemeStart,
                                     compilator_lexatom_t         LexatomBeforeLexemeStart,
                                     compilator_stream_position_t BackupLexatomIndexOfReadP) 
{
    (void)LexatomBeforeLexemeStart;

    me->_read_p                  = ReadP;
    me->_lexeme_start_p          = LexatomStartP;
    me->_lexatom_at_lexeme_start = LexatomAtLexemeStart;                                   
    me->_fallback_n              = 0; /* To be set upon mode entry */
    
    me->_backup_lexatom_index_of_lexeme_start_p = BackupLexatomIndexOfReadP;
}

inline void
compilator_Buffer_init_content(compilator_Buffer* me, compilator_lexatom_t* EndOfFileP)
/*  Initialize: input.lexatom_index_begin
 *              input.lexatom_index_end_of_stream                         
 *              input.end_p                                                   */
{
    compilator_lexatom_t*        EndP             = me->content_space_end(me);
    compilator_stream_position_t ci_begin         = (compilator_stream_position_t)0;
    compilator_stream_position_t ci_end_of_stream = (compilator_stream_position_t)-1;
    compilator_lexatom_t*        end_p            = (compilator_lexatom_t*)0;
    (void)EndP;

    if( ! me->_memory._front ) {
        ci_end_of_stream = (compilator_stream_position_t)-1;
        end_p            = (compilator_lexatom_t*)0;
        ci_begin         = (compilator_stream_position_t)-1;
    }
    else if( me->filler && me->filler->byte_loader ) {
        __quex_assert(0 == EndOfFileP);

        /* Setup condition to initiate immediate load when the state machine
         * is entered: 'read pointer hits buffer limit code'.                */
        ci_begin         = (compilator_stream_position_t)0;
        ci_end_of_stream = (compilator_stream_position_t)-1;
        end_p            = me->content_begin(me);
    } 
    else {
        __quex_assert(0 != me->_memory._front);           /* See first condition. */
        __quex_assert(! EndOfFileP || (EndOfFileP >= me->content_begin(me) && EndOfFileP <= EndP));

        if( EndOfFileP ) {
            ci_end_of_stream = EndOfFileP - me->content_begin(me);
            end_p            = EndOfFileP;   
        }
        else {
            ci_end_of_stream = (compilator_stream_position_t)-1;
            end_p            = me->content_begin(me);   
        }
    }

    compilator_Buffer_init_content_core(me, ci_begin, ci_end_of_stream, end_p);
}

inline void
compilator_Buffer_init_content_core(compilator_Buffer* me, 
                                    compilator_stream_position_t LI_Begin,
                                    compilator_stream_position_t LI_EndOfStream,
                                    compilator_lexatom_t*        EndOfFileP)
{
    me->input.lexatom_index_begin         = LI_Begin;
    me->input.lexatom_index_end_of_stream = LI_EndOfStream;
    if( EndOfFileP ) {
        me->input.end_p    = EndOfFileP;
        me->input.end_p[0] = QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
        QUEX_IF_ASSERTS_poison(&me->content_end(me)[1], me->content_space_end(me));
    }
    else {
        me->input.end_p    = (compilator_lexatom_t*)0;
    }
}

inline void
compilator_Buffer_register_content(compilator_Buffer*        me,
                                   compilator_lexatom_t*        EndOfInputP,
                                   compilator_stream_position_t CharacterIndexBegin)
/* Registers information about the stream that fills the buffer and its
 * relation to the buffer. 
 *  
 *  EndOfInputP --> Position behind the last lexatom in the buffer that has
 *                  been streamed.
 *          '0' --> No change.
 *  
 *  CharacterIndexBegin --> Character index of the first lexatom in the 
 *                          buffer.
 *                 '-1' --> No change.                                       */
{
    if( EndOfInputP ) {
        __quex_assert(EndOfInputP <= me->content_space_end(me));
        __quex_assert(EndOfInputP >= me->content_begin(me));

        me->input.end_p    = EndOfInputP;
        me->input.end_p[0] = QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;
    }

    if( CharacterIndexBegin != (compilator_stream_position_t)-1 ) {
        me->input.lexatom_index_begin = CharacterIndexBegin;
    }

    QUEX_IF_ASSERTS_poison(&me->content_end(me)[1], me->content_space_end(me));
    /* NOT: assert(compilator_Buffer_input_lexatom_index_begin(me) >= 0);
     * This function may be called before content is setup/loaded propperly. */ 
}

inline void       
compilator_Buffer_register_eos(compilator_Buffer*        me,
                               compilator_stream_position_t CharacterIndexEndOfStream)
{
    me->input.lexatom_index_end_of_stream = CharacterIndexEndOfStream;
}

inline bool
compilator_Buffer_is_empty(compilator_Buffer* me)
/* RETURNS: true, if buffer does not contain anything.
 *          false, else.                                                     */
{ 
    return    me->content_end(me) == me->content_begin(me) 
           && me->input.lexatom_index_begin == 0; 
}

inline compilator_stream_position_t  
compilator_Buffer_input_lexatom_index_end(compilator_Buffer* me)
/* RETURNS: Character index of the lexatom to which '.input.end_p' points.
 *                                                                           */
{
    __quex_assert(me->input.lexatom_index_begin >= 0);
    compilator_Buffer_assert_pointers_in_range(me);

    return me->input.lexatom_index_begin + me->content_size(me);
}

inline bool 
compilator_Buffer_is_end_of_stream_inside(compilator_Buffer* me)
{ 
    const ptrdiff_t ContentSpaceSize = me->content_space_size(me);

    if( me->input.lexatom_index_end_of_stream == (compilator_stream_position_t)-1 ) {
        return false;
    }
    else if( me->input.lexatom_index_end_of_stream < me->input.lexatom_index_begin ) {
        return false;
    }
    else {
        return me->input.lexatom_index_end_of_stream - me->input.lexatom_index_begin < ContentSpaceSize;
    }
}

inline bool 
compilator_Buffer_is_end_of_stream(compilator_Buffer* me)
{ 
    compilator_Buffer_assert_consistency(me);
    if( me->input.lexatom_index_end_of_stream == (compilator_stream_position_t)-1 ) {
        return false;
    }
    else if( me->_read_p != me->content_end(me) ) {
        return false;
    }

    return    compilator_Buffer_input_lexatom_index_end(me) 
           == me->input.lexatom_index_end_of_stream;
}

inline bool                  
compilator_Buffer_is_begin_of_stream(compilator_Buffer* buffer)
{ 
    compilator_Buffer_assert_consistency(buffer);
    if     ( buffer->_lexeme_start_p != buffer->content_begin(buffer) ) return false;
    else if( compilator_Buffer_input_lexatom_index_begin(buffer) )      return false;
    else                                                                return true;
}

inline void
compilator_Buffer_pointers_add_offset(compilator_Buffer*  me,
                                      ptrdiff_t           offset,
                                      compilator_lexatom_t** position_register,
                                      const size_t        PositionRegisterN)
/* Modify all buffer related pointers and lexatom indices by an offset. It is
 * assumed, that buffer content has been moved by 'offset' and that pointers
 * and offsets still related to the content before the move. 
 *
 * EXAMPLE: (lexatom index at buffer begin, read_p)
 *
 *                       0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 
 * Stream:               [a][b][c][d][e][f][g][h][j][i][k][l][m][n][o][p]
 *
 * Buffer before move:           |[d][e][f][g][h]|
 *                                |        |
 *     lexatom_index_begin = 3 ---'        |
 *     read_p -----------------------------'
 *
 * Buffer after move, then ADD:  |[f][g][h][j][i]|
 *                                |   |
 *     lexatom_index_begin = 5 ---'   |
 *     read_p ------------------------'
 *
 * ADAPTS: _read_p, _lexeme_start_p, position registers, end_p, 
 *         input.end_lexatom_index                                            */
{ 
#   define QUEX_BUFFER_POINTER_ADD(P, BORDER, OFFSET)                \
           ((P) = (  ((P) == (compilator_lexatom_t*)0) ? (P)            \
                   : ((BORDER) - (P) < OFFSET)     ? (BORDER)        \
                   : (P) + (OFFSET)))
#   define QUEX_BUFFER_POINTER_SUBTRACT(P, BORDER, NEGATIVE_OFFSET)  \
           ((P) = (  ((P) == (compilator_lexatom_t*)0)     ? (P)        \
                   : ((BORDER) - (P) > NEGATIVE_OFFSET) ? (BORDER)   \
                   : (P) + (NEGATIVE_OFFSET)))
    compilator_lexatom_t*  border = (compilator_lexatom_t*)0;
    compilator_lexatom_t** pit    = (compilator_lexatom_t**)0x0;
    compilator_lexatom_t** pEnd   = &position_register[PositionRegisterN];

    compilator_Buffer_assert_pointers_in_range(me);

    if( offset > 0 ) {
        border = me->content_space_end(me);
        QUEX_BUFFER_POINTER_ADD(me->_read_p,         border, offset);
        QUEX_BUFFER_POINTER_ADD(me->_lexeme_start_p, border, offset);
        QUEX_BUFFER_POINTER_ADD(me->input.end_p,     border, offset);

        for(pit = position_register; pit != pEnd; ++pit) {
            QUEX_BUFFER_POINTER_ADD(*pit, border, offset); 
        }
    }
    else if( offset < 0 ) {
        border = me->content_begin(me);
        QUEX_BUFFER_POINTER_SUBTRACT(me->_read_p,         border, offset);
        QUEX_BUFFER_POINTER_SUBTRACT(me->_lexeme_start_p, border, offset);
        QUEX_BUFFER_POINTER_SUBTRACT(me->input.end_p,     border, offset);

        for(pit = position_register; pit != pEnd; ++pit) {
            QUEX_BUFFER_POINTER_SUBTRACT(*pit, border, offset); 
        }
    }
    else {
        return;
    }

    *(me->content_end(me)) = (compilator_lexatom_t)QUEX_compilator_SETTING_BUFFER_LEXATOM_BUFFER_BORDER;

    me->input.lexatom_index_begin -= offset;

    compilator_Buffer_assert_pointers_in_range(me);

#   undef QUEX_BUFFER_POINTER_ADD
#   undef QUEX_BUFFER_POINTER_SUBTRACT
}



#include "compilator\lib\buffer/lexatoms/LexatomLoader.i"
#include "compilator\lib\buffer/Buffer_print.i"
#include "compilator\lib\buffer/Buffer_navigation.i"
#include "compilator\lib\buffer/Buffer_fill.i"
#include "compilator\lib\buffer/Buffer_load.i"
#include "compilator\lib\buffer/Buffer_nested.i"
#include "compilator\lib\buffer/Buffer_callbacks.i"
#include "compilator\lib\buffer/Buffer_invariance.i"
#include "compilator\lib\buffer/Buffer_move.i"
#include "compilator\lib\buffer/BufferMemory.i"

#endif /* QUEX_INCLUDE_GUARD_compilator__BUFFER__BUFFER_I */
