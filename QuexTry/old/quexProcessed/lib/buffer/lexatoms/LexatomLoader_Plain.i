/*  -*- C++ -*-  vim: set syntax=cpp: */
/* (C) 2008 Frank-Rene Schaefer*/
#ifndef  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__LEXATOMS__LEXATOM_LOADER_PLAIN_I
#define  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__LEXATOMS__LEXATOM_LOADER_PLAIN_I
/**/


#include <iostream> 
#include <cerrno>
#include <stdexcept>

#include "quexProcessed/lib/definitions"
#include "quexProcessed/lib/buffer/Buffer"
#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader"
#include "quexProcessed/lib/quex/MemoryManager"



inline void
quexProcessed_LexatomLoader_Plain_construct(quexProcessed_LexatomLoader_Plain*, quexProcessed_ByteLoader* byte_loader);

inline ptrdiff_t 
quexProcessed_LexatomLoader_Plain_stomach_byte_n(quexProcessed_LexatomLoader* alter_ego);

inline void 
quexProcessed_LexatomLoader_Plain_stomach_clear(quexProcessed_LexatomLoader* alter_ego);

inline void   
quexProcessed_LexatomLoader_Plain_destruct_self(quexProcessed_LexatomLoader* alter_ego);

inline size_t 
quexProcessed_LexatomLoader_Plain_load_lexatoms(quexProcessed_LexatomLoader* alter_ego,
                                             quexProcessed_lexatom_t*     RegionBeginP, 
                                             const size_t           N,
                                             bool*                  end_of_stream_f,
                                             bool*                  encoding_error_f);

inline void 
quexProcessed_LexatomLoader_Plain_fill_prepare(quexProcessed_LexatomLoader*  alter_ego,
                                            quexProcessed_Buffer*         buffer,
                                            void**                     begin_p,
                                            const void**               end_p);

inline ptrdiff_t 
quexProcessed_LexatomLoader_Plain_fill_finish(quexProcessed_LexatomLoader*  alter_ego,
                                           quexProcessed_lexatom_t*         insertion_p,
                                           const quexProcessed_lexatom_t*   BufferEnd,
                                           const void*                ContentEnd);

inline void 
quexProcessed_LexatomLoader_Plain_get_fill_boundaries(quexProcessed_LexatomLoader* alter_ego,
                                                   quexProcessed_Buffer*        buffer,
                                                   void**                    begin_p, 
                                                   const void**              end_p);

inline void 
quexProcessed_LexatomLoader_Plain_print_this(quexProcessed_LexatomLoader* alter_ego);

inline quexProcessed_LexatomLoader*
quexProcessed_LexatomLoader_Plain_new(quexProcessed_ByteLoader* byte_loader)
{
    quexProcessed_LexatomLoader_Plain*  me = \
         (quexProcessed_LexatomLoader_Plain*) \
          quex::MemoryManager_allocate(sizeof(quexProcessed_LexatomLoader_Plain),
                                         E_MemoryObjectType_BUFFER_FILLER);
    if( ! me ) {
        return (quexProcessed_LexatomLoader*)0;
    }
    /* __quex_assert(byte_loader); not for manual filling. */

    quexProcessed_LexatomLoader_Plain_construct(me, byte_loader);

    return &me->base;
}

inline void
quexProcessed_LexatomLoader_Plain_construct(quexProcessed_LexatomLoader_Plain* me, 
                                         quexProcessed_ByteLoader*          byte_loader)
{
    /* A linear relationship between stream position and lexatom index 
     * requires that the input stream is in 'binary mode'. That is, the 
     * stream position is proportional to the number of bytes that lie 
     * behind.                                                               */
    ptrdiff_t   byte_n_per_lexatom = byte_loader && byte_loader->binary_mode_f ? 
                                       (ptrdiff_t)sizeof(quexProcessed_lexatom_t) : -1;
    quexProcessed_LexatomLoader_setup(&me->base,
                                   quexProcessed_LexatomLoader_Plain_load_lexatoms,
                                   quexProcessed_LexatomLoader_Plain_stomach_byte_n,
                                   quexProcessed_LexatomLoader_Plain_stomach_clear,
                                   quexProcessed_LexatomLoader_Plain_destruct_self, 
                                   quexProcessed_LexatomLoader_Plain_fill_prepare, 
                                   quexProcessed_LexatomLoader_Plain_fill_finish, 
                                   quexProcessed_LexatomLoader_Plain_get_fill_boundaries,
                                   quexProcessed_LexatomLoader_Plain_print_this,
                                   byte_loader,
                                   byte_n_per_lexatom);
}

inline ptrdiff_t 
quexProcessed_LexatomLoader_Plain_stomach_byte_n(quexProcessed_LexatomLoader* alter_ego) 
{
    (void)alter_ego;
    return (ptrdiff_t)0;
}

inline void 
quexProcessed_LexatomLoader_Plain_stomach_clear(quexProcessed_LexatomLoader* alter_ego) 
{
    (void)alter_ego;
}

inline void 
quexProcessed_LexatomLoader_Plain_destruct_self(quexProcessed_LexatomLoader* alter_ego) 
/* destruct_self: Free resources occupied by 'me' BUT NOT 'myself'.
 * delete_self:   Free resources occupied by 'me' AND 'myself'.              */
{
    (void)alter_ego;
    /* There is nothing allocated by a LexatomLoader_Plain. 
     * Nothing to do.                                                        */
}

inline size_t   
quexProcessed_LexatomLoader_Plain_load_lexatoms(quexProcessed_LexatomLoader*  alter_ego,
                                             quexProcessed_lexatom_t*         RegionBeginP, 
                                             const size_t               N,
                                             bool*                      end_of_stream_f,  
                                             bool*                      encoding_error_f)
/* Loads content into a region of memory. Does NOT effect any of the buffer's
 * variables. 
 *
 * RETURNS: Number of loaded lexatoms into the given region.               */
{ 
    quexProcessed_LexatomLoader_Plain* me = (quexProcessed_LexatomLoader_Plain*)alter_ego;
    size_t                          loaded_byte_n = (size_t)-1;
    size_t                          loaded_n;
    (void)encoding_error_f;

    __quex_assert(0 != alter_ego); 
    __quex_assert(0 != RegionBeginP); 
    __quex_assert(0 != me->base.byte_loader); 
    /* NOT: QUEX_IF_ASSERTS_poison(RegionBeginP, &RegionBeginP[N]);
     * The buffer must remain intact, in case that not all is loaded.        */
    loaded_byte_n = me->base.byte_loader->load(me->base.byte_loader, 
                                               RegionBeginP, 
                                               N * sizeof(quexProcessed_lexatom_t),
                                               end_of_stream_f);

    if( loaded_byte_n % sizeof(quexProcessed_lexatom_t) ) {
        QUEX_DEBUG_PRINT("Error: End of file cuts in the middle of a multi-byte character.");
    }
    loaded_n = loaded_byte_n / sizeof(quexProcessed_lexatom_t);

    return loaded_n;
}

inline void 
quexProcessed_LexatomLoader_Plain_fill_prepare(quexProcessed_LexatomLoader* alter_ego,
                                            quexProcessed_Buffer*        buffer,
                                            void**                    begin_p,
                                            const void**              end_p)
{
    /* Move-away of passed content in engine's buffer is done by caller. */
    alter_ego->derived.get_fill_boundaries(alter_ego, buffer, begin_p, end_p);
}

inline void 
quexProcessed_LexatomLoader_Plain_get_fill_boundaries(quexProcessed_LexatomLoader* alter_ego,
                                                   quexProcessed_Buffer*        buffer,
                                                   void**                    begin_p, 
                                                   const void**              end_p)
{
    (void)alter_ego;

    *begin_p = (void*)buffer->content_end(buffer);
    *end_p   = (void*)buffer->content_space_end(buffer);
}

inline ptrdiff_t 
quexProcessed_LexatomLoader_Plain_fill_finish(quexProcessed_LexatomLoader*  alter_ego,
                                           quexProcessed_lexatom_t*         insertion_p,
                                           const quexProcessed_lexatom_t*   BufferEnd,
                                           const void*                FilledEndP_raw)
{
    const quexProcessed_lexatom_t*  FilledEndP = (const quexProcessed_lexatom_t*)FilledEndP_raw;
    (void)alter_ego;
    (void)BufferEnd;

    __quex_assert(FilledEndP >= insertion_p);
    __quex_assert(FilledEndP <= BufferEnd);
    /* Assert triggers => FilledEndP points WRONGLY BEHIND terminating zero. 
     * (FilledEndP, may point to it, at max.)                                */
    __quex_assert(   FilledEndP     <= insertion_p 
                  || FilledEndP[-1] != QUEX_quexProcessed_SETTING_BUFFER_LEXATOM_BUFFER_BORDER);

    /* Copying of content is done, already, by caller.                       */
    /* Inserted number of lexatoms = End - Begin.                            */
    return (ptrdiff_t)(FilledEndP - insertion_p);
}

inline void 
quexProcessed_LexatomLoader_Plain_print_this(quexProcessed_LexatomLoader* alter_ego)
{
    (void)alter_ego;
    QUEX_DEBUG_PRINT("      type:                           plain;\n");
}



#include "quexProcessed/lib/buffer/lexatoms/LexatomLoader.i"

#endif /* __INCLUDE_GUARD__QUEX_BUFFER_INPUT_STRATEGY_PLAIN_I__ */
