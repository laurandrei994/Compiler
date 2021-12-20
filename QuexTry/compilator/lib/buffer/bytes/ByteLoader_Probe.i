/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_compilator__BUFFER__BYTES__BYTE_LOADER_PROBE_I
#define  QUEX_INCLUDE_GUARD_compilator__BUFFER__BYTES__BYTE_LOADER_PROBE_I

#include "compilator\lib\quex/MemoryManager"
#include "quex/code_base/buffer/bytes/ByteLoader_Probe"
#include <malloc.h> // DEBUG



inline void                       compilator_ByteLoader_Probe_construct(compilator_ByteLoader_Probe* me,
                                                                             compilator_ByteLoader*       source,
                                                                             void*                        reference_object);
inline compilator_stream_position_t  compilator_ByteLoader_Probe_tell(compilator_ByteLoader* me);
inline void                       compilator_ByteLoader_Probe_seek(compilator_ByteLoader*     me, 
                                                                        compilator_stream_position_t  Pos);
inline size_t                     compilator_ByteLoader_Probe_load(compilator_ByteLoader* me, 
                                                                        void*                  buffer, 
                                                                        const size_t           ByteN, 
                                                                        bool*                  end_of_stream_f);
inline void                       compilator_ByteLoader_Probe_delete_self(compilator_ByteLoader* me);
inline void                       compilator_ByteLoader_Probe_print_this(compilator_ByteLoader* me);
inline bool                       compilator_ByteLoader_Probe_compare_handle(const compilator_ByteLoader* alter_ego_A, 
                                                                                  const compilator_ByteLoader* alter_ego_B);

inline compilator_ByteLoader*    
compilator_ByteLoader_Probe_new(compilator_ByteLoader* source,
                                void*                  reference_object)
    /* ByteLoader takes over ownership over 'source' */
{
    compilator_ByteLoader_Probe* me;
   
    me = (compilator_ByteLoader_Probe*)quex::MemoryManager_allocate(
                   sizeof(compilator_ByteLoader_Probe),
                   E_MemoryObjectType_BYTE_LOADER);

    if( ! me ) return (compilator_ByteLoader*)0;

    compilator_ByteLoader_Probe_construct(me, source, reference_object);

    return &me->base;
}

inline void
compilator_ByteLoader_Probe_construct(compilator_ByteLoader_Probe* me, 
                                      compilator_ByteLoader*       source,
                                      void*                        reference_object)
{
    me->source           = source;
    me->reference_object = reference_object;

    compilator_ByteLoader_construct(&me->base,
                         compilator_ByteLoader_Probe_tell,
                         compilator_ByteLoader_Probe_seek,
                         compilator_ByteLoader_Probe_load,
                         compilator_ByteLoader_Probe_delete_self,
                         compilator_ByteLoader_Probe_print_this,
                         compilator_ByteLoader_Probe_compare_handle);
}

inline void    
compilator_ByteLoader_Probe_delete_self(compilator_ByteLoader* alter_ego)
{
    compilator_ByteLoader_Probe* me = (compilator_ByteLoader_Probe*)(alter_ego);

    if( me->on_delete_self ) {
        me->on_delete_self(me);
    }
    me->source->delete_self(me->source);

    quex::MemoryManager_free((void*)me->source, E_MemoryObjectType_BYTE_LOADER);
    quex::MemoryManager_free((void*)me, E_MemoryObjectType_BYTE_LOADER);

}

inline compilator_stream_position_t    
compilator_ByteLoader_Probe_tell(compilator_ByteLoader* alter_ego)            
{ 
    compilator_ByteLoader_Probe* me = (compilator_ByteLoader_Probe*)(alter_ego);
    compilator_stream_position_t    position;

    position = me->source->tell(me->source);

    ++(me->tell_n);
    me->position_last_tell = position;

    if( me->on_tell ) {
        return me->on_tell(me, position);
    }

    return position;
}

inline void    
compilator_ByteLoader_Probe_seek(compilator_ByteLoader* alter_ego, compilator_stream_position_t Pos) 
{ 
    compilator_ByteLoader_Probe* me = (compilator_ByteLoader_Probe*)(alter_ego);
    compilator_stream_position_t    position;

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
compilator_ByteLoader_Probe_load(compilator_ByteLoader*   alter_ego, 
                                 void*                    buffer, 
                                 const size_t             ByteN, 
                                 bool*                    end_of_stream_f) 
{ 
    compilator_ByteLoader_Probe* me = (compilator_ByteLoader_Probe*)(alter_ego);
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
compilator_ByteLoader_Probe_compare_handle(const compilator_ByteLoader* alter_ego_A, 
                                                      const compilator_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same Memory object.
 *          false -- else.                                                   */
{ 
    const compilator_ByteLoader_Probe* me = (compilator_ByteLoader_Probe*)(alter_ego_A);
    bool                                          result;

    result = me->source->compare_handle(me->source, alter_ego_B);

    return result;
}

inline void                       
compilator_ByteLoader_Probe_print_this(compilator_ByteLoader* alter_ego)
{
    compilator_ByteLoader_Probe* me = (compilator_ByteLoader_Probe*)(alter_ego);

    QUEX_DEBUG_PRINT("        remote_controlled: {\n");
    me->source->print_this(me->source);
    QUEX_DEBUG_PRINT("        }\n");
}



#endif /* QUEX_INCLUDE_GUARD_compilator__BUFFER__BYTES__BYTE_LOADER_PROBE_I */
