/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_STREAM_I
#define  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_STREAM_I
#ifdef __cplusplus

#include <fstream>
#include <sstream>
#include "lexical_analysis/lib/buffer/bytes/ByteLoader_stream"



template <class StreamType>  Calc_lexer_stream_position_t  Calc_lexer_ByteLoader_stream_tell(Calc_lexer_ByteLoader* me);
template <class StreamType>  void                       Calc_lexer_ByteLoader_stream_seek(Calc_lexer_ByteLoader* me, 
                                                                                          Calc_lexer_stream_position_t Pos);
template <class StreamType>  size_t                     Calc_lexer_ByteLoader_stream_load(Calc_lexer_ByteLoader* me, void* buffer, const size_t ByteN, bool*);
template <class StreamType>  void                       Calc_lexer_ByteLoader_stream_delete_self(Calc_lexer_ByteLoader* me);
template <class StreamType>  void                       Calc_lexer_ByteLoader_stream_print_this(Calc_lexer_ByteLoader* alter_ego);
template <class StreamType>  bool                       Calc_lexer_ByteLoader_stream_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                                                                                               const Calc_lexer_ByteLoader* alter_ego_B);

template <class StreamType>  Calc_lexer_ByteLoader*
Calc_lexer_ByteLoader_stream_new(StreamType* sh)
{
    Calc_lexer_ByteLoader_stream<StreamType>* me;

    if( ! sh ) return (Calc_lexer_ByteLoader*)0;

    me = (Calc_lexer_ByteLoader_stream<StreamType>*)quex_MemoryManager_allocate(sizeof(Calc_lexer_ByteLoader_stream<StreamType>),
                                                                        E_MemoryObjectType_BYTE_LOADER);

    if( ! me ) return (Calc_lexer_ByteLoader*)0;

    Calc_lexer_ByteLoader_stream_construct(me, sh);
    return &me->base;
}

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_stream_new_from_file_name(const char* FileName)
{
    std::ifstream*         sh = new std::ifstream(FileName, std::ios_base::binary | std::ios::in);
    Calc_lexer_ByteLoader* alter_ego;
    if( ! sh || ! *sh ) {
        return (Calc_lexer_ByteLoader*)0;
    }
    alter_ego = Calc_lexer_ByteLoader_stream_new<std::ifstream>(sh);
    if( ! alter_ego ) {
        return (Calc_lexer_ByteLoader*)0;
    }

    /* ByteLoader from file name *must* be owned by lexical analyzer, 
     * to ensure automatic closure and deletion.                              */
    alter_ego->handle_ownership = E_Ownership_LEXICAL_ANALYZER;
    return alter_ego;
}

template <class StreamType>  void
Calc_lexer_ByteLoader_stream_construct(Calc_lexer_ByteLoader_stream<StreamType>* me, 
                                       StreamType*                               sh)
{
    /* IMPORTANT: input_handle must be set BEFORE call to constructor!
     *            Constructor does call 'tell()'                             */
    me->input_handle = sh;

    Calc_lexer_ByteLoader_construct(&me->base,
                         Calc_lexer_ByteLoader_stream_tell<StreamType>,
                         Calc_lexer_ByteLoader_stream_seek<StreamType>,
                         Calc_lexer_ByteLoader_stream_load<StreamType>,
                         Calc_lexer_ByteLoader_stream_delete_self<StreamType>,
                         Calc_lexer_ByteLoader_stream_print_this<StreamType>,
                         Calc_lexer_ByteLoader_stream_compare_handle<StreamType>);
    me->base.element_size = sizeof(typename StreamType::char_type);
}

template <class StreamType>  void
Calc_lexer_ByteLoader_stream_delete_self(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_stream<StreamType>* me = (Calc_lexer_ByteLoader_stream<StreamType>*)alter_ego;

    if( me->input_handle && me->base.handle_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        delete me->input_handle;
    }
    quex_MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);
}

/* The 'char_type' of a stream determines the atomic size of elements which are
 * read from the stream. It is unrelated to Calc_lexer_lexatom_t which
 * determines the size of a buffer element.                                  */
template <class StreamType>  Calc_lexer_stream_position_t    
Calc_lexer_ByteLoader_stream_tell(Calc_lexer_ByteLoader* alter_ego)            
{ 
    Calc_lexer_ByteLoader_stream<StreamType>*       me = (Calc_lexer_ByteLoader_stream<StreamType>*)alter_ego;
    const Calc_lexer_stream_position_t      CharSize = \
         (Calc_lexer_stream_position_t)sizeof(typename StreamType::char_type);
    std::streampos                       Position = me->input_handle->tellg();

    return (Calc_lexer_stream_position_t)(Position * CharSize); 
}

template <class StreamType>  void    
Calc_lexer_ByteLoader_stream_seek(Calc_lexer_ByteLoader*    alter_ego, 
                                  Calc_lexer_stream_position_t Pos) 
{ 
    Calc_lexer_ByteLoader_stream<StreamType>*       me = (Calc_lexer_ByteLoader_stream<StreamType>*)alter_ego;
    const Calc_lexer_stream_position_t      CharSize = \
         (Calc_lexer_stream_position_t)sizeof(typename StreamType::char_type);
    std::streampos                       Target   = (std::streampos)(Pos / CharSize);

    me->input_handle->clear();                    /* Clear any iostate flag. */
    me->input_handle->seekg(Target); 
}

template <class StreamType>  size_t  
Calc_lexer_ByteLoader_stream_load(Calc_lexer_ByteLoader*  alter_ego, 
                                  void*        buffer, 
                                  const size_t ByteN, 
                                  bool*        end_of_stream_f) 
{ 
    Calc_lexer_ByteLoader_stream<StreamType>*    me = (Calc_lexer_ByteLoader_stream<StreamType>*)alter_ego;
    const Calc_lexer_stream_position_t   CharSize = \
         (Calc_lexer_stream_position_t)sizeof(typename StreamType::char_type);

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

template <class StreamType>  bool  
Calc_lexer_ByteLoader_stream_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                            const Calc_lexer_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same StreamType object.
 *          false -- else.                                                   */
{ 
    const Calc_lexer_ByteLoader_stream<StreamType>* A = (Calc_lexer_ByteLoader_stream<StreamType>*)(alter_ego_A);
    const Calc_lexer_ByteLoader_stream<StreamType>* B = (Calc_lexer_ByteLoader_stream<StreamType>*)(alter_ego_B);

    return A->input_handle == B->input_handle;
}

template <class StreamType> void
Calc_lexer_ByteLoader_stream_print_this(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_stream<StreamType>*    me = (Calc_lexer_ByteLoader_stream<StreamType>*)alter_ego;

    QUEX_DEBUG_PRINT("        type:             istream;\n");
    QUEX_DEBUG_PRINT1("        stream:           ((%p));\n", (const void*)me->input_handle);
    if( me->input_handle ) {
        QUEX_DEBUG_PRINT1("        end_of_stream:    %s;\n", E_Boolean_NAME(me->input_handle->eof()));
    }
}



#endif /* __cplusplus                                             */
#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_STREAM_I */

