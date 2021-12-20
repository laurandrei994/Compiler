/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_PROBE_I
#define  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_PROBE_I

#include "quexProcessed/lib/quex/MemoryManager"
#include "quex/code_base/buffer/bytes/ByteLoader_Probe"
#include <malloc.h> // DEBUG



inline void                       quexProcessed_ByteLoader_Probe_construct(quexProcessed_ByteLoader_Probe* me,
                                                                             quexProcessed_ByteLoader*       source,
                                                                             void*                        reference_object);
inline quexProcessed_stream_position_t  quexProcessed_ByteLoader_Probe_tell(quexProcessed_ByteLoader* me);
inline void                       quexProcessed_ByteLoader_Probe_seek(quexProcessed_ByteLoader*     me, 
                                                                        quexProcessed_stream_position_t  Pos);
inline size_t                     quexProcessed_ByteLoader_Probe_load(quexProcessed_ByteLoader* me, 
                                                                        void*                  buffer, 
                                                                        const size_t           ByteN, 
                                                                        bool*                  end_of_stream_f);
inline void                       quexProcessed_ByteLoader_Probe_delete_self(quexProcessed_ByteLoader* me);
inline void                       quexProcessed_ByteLoader_Probe_print_this(quexProcessed_ByteLoader* me);
inline bool                       quexProcessed_ByteLoader_Probe_compare_handle(const quexProcessed_ByteLoader* alter_ego_A, 
                                                                                  const quexProcessed_ByteLoader* alter_ego_B);

inline quexProcessed_ByteLoader*    
quexProcessed_ByteLoader_Probe_new(quexProcessed_ByteLoader* source,
                                void*                  reference_object)
    /* ByteLoader takes over ownership over 'source' */
{
    quexProcessed_ByteLoader_Probe* me;
   
    me = (quexProcessed_ByteLoader_Probe*)quex::MemoryManager_allocate(
                   sizeof(quexProcessed_ByteLoader_Probe),
                   E_MemoryObjectType_BYTE_LOADER);

    if( ! me ) return (quexProcessed_ByteLoader*)0;

    quexProcessed_ByteLoader_Probe_construct(me, source, reference_object);

    return &me->base;
}

inline void
quexProcessed_ByteLoader_Probe_construct(quexProcessed_ByteLoader_Probe* me, 
                                      quexProcessed_ByteLoader*       source,
                                      void*                        reference_object)
{
    me->source           = source;
    me->reference_object = reference_object;

    quexProcessed_ByteLoader_construct(&me->base,
                         quexProcessed_ByteLoader_Probe_tell,
                         quexProcessed_ByteLoader_Probe_seek,
                         quexProcessed_ByteLoader_Probe_load,
                         quexProcessed_ByteLoader_Probe_delete_self,
                         quexProcessed_ByteLoader_Probe_print_this,
                         quexProcessed_ByteLoader_Probe_compare_handle);
}

inline void    
quexProcessed_ByteLoader_Probe_delete_self(quexProcessed_ByteLoader* alter_ego)
{
    quexProcessed_ByteLoader_Probe* me = (quexProcessed_ByteLoader_Probe*)(alter_ego);

    if( me->on_delete_self ) {
        me->on_delete_self(me);
    }
    me->source->delete_self(me->source);

    quex::MemoryManager_free((void*)me->source, E_MemoryObjectType_BYTE_LOADER);
    quex::MemoryManager_free((void*)me, E_MemoryObjectType_BYTE_LOADER);

}

inline quexProcessed_stream_position_t    
quexProcessed_ByteLoader_Probe_tell(quexProcessed_ByteLoader* alter_ego)            
{ 
    quexProcessed_ByteLoader_Probe* me = (quexProcessed_ByteLoader_Probe*)(alter_ego);
    quexProcessed_stream_position_t    position;

    position = me->source->tell(me->source);

    ++(me->tell_n);
    me->position_last_tell = position;

    if( me->on_tell ) {
        return me->on_tell(me, position);
    }

    return position;
}

inline void    
quexProcessed_ByteLoader_Probe_seek(quexProcessed_ByteLoader* alter_ego, quexProcessed_stream_position_t Pos) 
{ 
    quexProcessed_ByteLoader_Probe* me = (quexProcessed_ByteLoader_Probe*)(alter_ego);
    quexProcessed_stream_position_t    position;

    if( me->on_seek ) {
        position = me->on_seek(me, Pos);
    }
    else {
        position = Pos;
    }

    me->source->seek(me->source, position);

    ++(me->seek_n);
    me->position_last_seek = position;
}

inline size_t  
quexProcessed_ByteLoader_Probe_load(quexProcessed_ByteLoader*   alter_ego, 
                                 void*                    buffer, 
                                 const size_t             ByteN, 
                                 bool*                    end_of_stream_f) 
{ 
    quexProcessed_ByteLoader_Probe* me = (quexProcessed_ByteLoader_Probe*)(alter_ego);
    size_t                       loaded_byte_n;
    size_t                       byte_n;

    if( me->on_before_load ) {
        byte_n = me->on_before_load(me, ByteN);
    }
    else {
        byte_n = ByteN;
    }

    loaded_byte_n = me->source->load(me->source, buffer, byte_n, end_of_stream_f);

    if( me->on_after_load ) {
        loaded_byte_n = me->on_after_load(me, buffer, loaded_byte_n, end_of_stream_f);
    }

    ++(me->load_n);
    me->loaded_byte_n += loaded_byte_n;

    return loaded_byte_n;
}

inline bool  
quexProcessed_ByteLoader_Probe_compare_handle(const quexProcessed_ByteLoader* alter_ego_A, 
                                                      const quexProcessed_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same Memory object.
 *          false -- else.                                                   */
{ 
    const quexProcessed_ByteLoader_Probe* me = (quexProcessed_ByteLoader_Probe*)(alter_ego_A);
    bool                                          result;

    result = me->source->compare_handle(me->source, alter_ego_B);

    return result;
}

inline void                       
quexProcessed_ByteLoader_Probe_print_this(quexProcessed_ByteLoader* alter_ego)
{
    quexProcessed_ByteLoader_Probe* me = (quexProcessed_ByteLoader_Probe*)(alter_ego);

    QUEX_DEBUG_PRINT("        remote_controlled: {\n");
    me->source->print_this(me->source);
    QUEX_DEBUG_PRINT("        }\n");
}



#endif /* QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_PROBE_I */
