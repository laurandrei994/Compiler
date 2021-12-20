/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_STREAM_I
#define  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_STREAM_I
#ifdef __cplusplus

#include <fstream>
#include <sstream>
#include "quexProcessed/lib/buffer/bytes/ByteLoader_stream"



template <class StreamType> inline quexProcessed_stream_position_t  quexProcessed_ByteLoader_stream_tell(quexProcessed_ByteLoader* me);
template <class StreamType> inline void                       quexProcessed_ByteLoader_stream_seek(quexProcessed_ByteLoader* me, 
                                                                                          quexProcessed_stream_position_t Pos);
template <class StreamType> inline size_t                     quexProcessed_ByteLoader_stream_load(quexProcessed_ByteLoader* me, void* buffer, const size_t ByteN, bool*);
template <class StreamType> inline void                       quexProcessed_ByteLoader_stream_delete_self(quexProcessed_ByteLoader* me);
template <class StreamType> inline void                       quexProcessed_ByteLoader_stream_print_this(quexProcessed_ByteLoader* alter_ego);
template <class StreamType> inline bool                       quexProcessed_ByteLoader_stream_compare_handle(const quexProcessed_ByteLoader* alter_ego_A, 
                                                                                                               const quexProcessed_ByteLoader* alter_ego_B);

template <class StreamType> inline quexProcessed_ByteLoader*
quexProcessed_ByteLoader_stream_new(StreamType* sh)
{
    quexProcessed_ByteLoader_stream<StreamType>* me;

    if( ! sh ) return (quexProcessed_ByteLoader*)0;

    me = (quexProcessed_ByteLoader_stream<StreamType>*)quex::MemoryManager_allocate(sizeof(quexProcessed_ByteLoader_stream<StreamType>),
                                                                        E_MemoryObjectType_BYTE_LOADER);

    if( ! me ) return (quexProcessed_ByteLoader*)0;

    quexProcessed_ByteLoader_stream_construct(me, sh);
    return &me->base;
}

inline quexProcessed_ByteLoader*    
quexProcessed_ByteLoader_stream_new_from_file_name(const char* FileName)
{
    std::ifstream*         sh = new std::ifstream(FileName, std::ios_base::binary | std::ios::in);
    quexProcessed_ByteLoader* alter_ego;
    if( ! sh || ! *sh ) {
        return (quexProcessed_ByteLoader*)0;
    }
    alter_ego = quexProcessed_ByteLoader_stream_new<std::ifstream>(sh);
    if( ! alter_ego ) {
        return (quexProcessed_ByteLoader*)0;
    }

    /* ByteLoader from file name *must* be owned by lexical analyzer, 
     * to ensure automatic closure and deletion.                              */
    alter_ego->handle_ownership = E_Ownership_LEXICAL_ANALYZER;
    return alter_ego;
}

template <class StreamType> inline void
quexProcessed_ByteLoader_stream_construct(quexProcessed_ByteLoader_stream<StreamType>* me, 
                                       StreamType*                               sh)
{
    /* IMPORTANT: input_handle must be set BEFORE call to constructor!
     *            Constructor does call 'tell()'                             */
    me->input_handle = sh;

    quexProcessed_ByteLoader_construct(&me->base,
                         quexProcessed_ByteLoader_stream_tell<StreamType>,
                         quexProcessed_ByteLoader_stream_seek<StreamType>,
                         quexProcessed_ByteLoader_stream_load<StreamType>,
                         quexProcessed_ByteLoader_stream_delete_self<StreamType>,
                         quexProcessed_ByteLoader_stream_print_this<StreamType>,
                         quexProcessed_ByteLoader_stream_compare_handle<StreamType>);
    me->base.element_size = sizeof(typename StreamType::char_type);
}

template <class StreamType> inline void
quexProcessed_ByteLoader_stream_delete_self(quexProcessed_ByteLoader* alter_ego)
{
    quexProcessed_ByteLoader_stream<StreamType>* me = (quexProcessed_ByteLoader_stream<StreamType>*)alter_ego;

    if( me->input_handle && me->base.handle_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        delete me->input_handle;
    }
    quex::MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);
}

/* The 'char_type' of a stream determines the atomic size of elements which are
 * read from the stream. It is unrelated to quexProcessed_lexatom_t which
 * determines the size of a buffer element.                                  */
template <class StreamType> inline quexProcessed_stream_position_t    
quexProcessed_ByteLoader_stream_tell(quexProcessed_ByteLoader* alter_ego)            
{ 
    quexProcessed_ByteLoader_stream<StreamType>*       me = (quexProcessed_ByteLoader_stream<StreamType>*)alter_ego;
    const quexProcessed_stream_position_t      CharSize = \
         (quexProcessed_stream_position_t)sizeof(typename StreamType::char_type);
    std::streampos                       Position = me->input_handle->tellg();

    return (quexProcessed_stream_position_t)(Position * CharSize); 
}

template <class StreamType> inline void    
quexProcessed_ByteLoader_stream_seek(quexProcessed_ByteLoader*    alter_ego, 
                                  quexProcessed_stream_position_t Pos) 
{ 
    quexProcessed_ByteLoader_stream<StreamType>*       me = (quexProcessed_ByteLoader_stream<StreamType>*)alter_ego;
    const quexProcessed_stream_position_t      CharSize = \
         (quexProcessed_stream_position_t)sizeof(typename StreamType::char_type);
    std::streampos                       Target   = (std::streampos)(Pos / CharSize);

    me->input_handle->clear();                    /* Clear any iostate flag. */
    me->input_handle->seekg(Target); 
}

template <class StreamType> inline size_t  
quexProcessed_ByteLoader_stream_load(quexProcessed_ByteLoader*  alter_ego, 
                                  void*        buffer, 
                                  const size_t ByteN, 
                                  bool*        end_of_stream_f) 
{ 
    quexProcessed_ByteLoader_stream<StreamType>*    me = (quexProcessed_ByteLoader_stream<StreamType>*)alter_ego;
    const quexProcessed_stream_position_t   CharSize = \
         (quexProcessed_stream_position_t)sizeof(typename StreamType::char_type);

    if( ! ByteN ) return (size_t)0;

    me->input_handle->read((typename StreamType::char_type*)buffer, 
                           (std::streamsize)(ByteN / CharSize)); 

    const size_t loaded_char_n = (size_t)(me->input_handle->gcount());

    *end_of_stream_f = me->input_handle->eof();

    if( (! *end_of_stream_f) && me->input_handle->fail() ) {
        throw std::runtime_error("Fatal error during stream reading.");
    }

    /* std::fprintf(stdout, "tell 1 = %i, loaded_char_n = %i\n", (long)(me->input_handle->tellg()), loaded_char_n);*/
    return (size_t)(loaded_char_n * CharSize);
}

template <class StreamType> inline bool  
quexProcessed_ByteLoader_stream_compare_handle(const quexProcessed_ByteLoader* alter_ego_A, 
                                            const quexProcessed_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same StreamType object.
 *          false -- else.                                                   */
{ 
    const quexProcessed_ByteLoader_stream<StreamType>* A = (quexProcessed_ByteLoader_stream<StreamType>*)(alter_ego_A);
    const quexProcessed_ByteLoader_stream<StreamType>* B = (quexProcessed_ByteLoader_stream<StreamType>*)(alter_ego_B);

    return A->input_handle == B->input_handle;
}

template <class StreamType> void
quexProcessed_ByteLoader_stream_print_this(quexProcessed_ByteLoader* alter_ego)
{
    quexProcessed_ByteLoader_stream<StreamType>*    me = (quexProcessed_ByteLoader_stream<StreamType>*)alter_ego;

    QUEX_DEBUG_PRINT("        type:             istream;\n");
    QUEX_DEBUG_PRINT1("        stream:           ((%p));\n", (const void*)me->input_handle);
    if( me->input_handle ) {
        QUEX_DEBUG_PRINT1("        end_of_stream:    %s;\n", E_Boolean_NAME(me->input_handle->eof()));
    }
}



#endif /* __cplusplus                                             */
#endif /* QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_STREAM_I */

