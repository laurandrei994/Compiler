/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_FILE_I
#define  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_FILE_I

#include "quexProcessed/lib/quex/MemoryManager"



inline void                       quexProcessed_ByteLoader_FILE_construct(quexProcessed_ByteLoader_FILE* me, __QUEX_STD_FILE* fh);
inline quexProcessed_stream_position_t  quexProcessed_ByteLoader_FILE_tell(quexProcessed_ByteLoader* me);
inline void                       quexProcessed_ByteLoader_FILE_seek(quexProcessed_ByteLoader* me, quexProcessed_stream_position_t Pos);
inline size_t                     quexProcessed_ByteLoader_FILE_load(quexProcessed_ByteLoader* me, void* buffer, const size_t ByteN, bool*);
inline void                       quexProcessed_ByteLoader_FILE_delete_self(quexProcessed_ByteLoader* me);
inline void                       quexProcessed_ByteLoader_FILE_print_this(quexProcessed_ByteLoader* me);
inline bool                       quexProcessed_ByteLoader_FILE_compare_handle(const quexProcessed_ByteLoader* alter_ego_A, 
                                                                                 const quexProcessed_ByteLoader* alter_ego_B);

inline quexProcessed_ByteLoader*    
quexProcessed_ByteLoader_FILE_new(FILE* fh, bool BinaryModeF)
{
    quexProcessed_ByteLoader_FILE* me;
   
    if( ! fh ) return (quexProcessed_ByteLoader*)0;

    me = (quexProcessed_ByteLoader_FILE*)quex::MemoryManager_allocate(sizeof(quexProcessed_ByteLoader_FILE),
                                                                     E_MemoryObjectType_BYTE_LOADER);
    if( ! me ) return (quexProcessed_ByteLoader*)0;

    quexProcessed_ByteLoader_FILE_construct(me, fh);
    me->base.binary_mode_f = BinaryModeF;

    return &me->base;
}

inline quexProcessed_ByteLoader*    
quexProcessed_ByteLoader_FILE_new_from_file_name(const char* FileName)
{
    __QUEX_STD_FILE*        fh = fopen(FileName, "rb");
    quexProcessed_ByteLoader*  alter_ego;

    if( ! fh ) {
        return (quexProcessed_ByteLoader*)0;
    }
    alter_ego = quexProcessed_ByteLoader_FILE_new(fh, true);
    if( ! alter_ego ) {
        __QUEX_STD_fclose(fh);
        return (quexProcessed_ByteLoader*)0;
    }

    /* ByteLoader from file name *must* be owned by lexical analyzer, 
     * to ensure automatic closure and deletion.                              */
    alter_ego->handle_ownership = E_Ownership_LEXICAL_ANALYZER;
    return alter_ego;
}

inline void
quexProcessed_ByteLoader_FILE_construct(quexProcessed_ByteLoader_FILE* me, __QUEX_STD_FILE* fh)
{
    /* IMPORTANT: input_handle must be set BEFORE call to base constructor!
     *            Constructor does call 'tell()'                             */
    me->input_handle = fh;

    quexProcessed_ByteLoader_construct(&me->base,
                         quexProcessed_ByteLoader_FILE_tell,
                         quexProcessed_ByteLoader_FILE_seek,
                         quexProcessed_ByteLoader_FILE_load,
                         quexProcessed_ByteLoader_FILE_delete_self,
                         quexProcessed_ByteLoader_FILE_print_this,
                         quexProcessed_ByteLoader_FILE_compare_handle);
}

inline void    
quexProcessed_ByteLoader_FILE_delete_self(quexProcessed_ByteLoader* alter_ego)
{
    quexProcessed_ByteLoader_FILE* me = (quexProcessed_ByteLoader_FILE*)(alter_ego);

    if( me->input_handle && me->base.handle_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        __QUEX_STD_fclose(me->input_handle);
    }
    quex::MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);
}

inline quexProcessed_stream_position_t    
quexProcessed_ByteLoader_FILE_tell(quexProcessed_ByteLoader* alter_ego)            
{ 
    quexProcessed_ByteLoader_FILE* me = (quexProcessed_ByteLoader_FILE*)(alter_ego);

    return (quexProcessed_stream_position_t)ftell(me->input_handle); 
}

inline void    
quexProcessed_ByteLoader_FILE_seek(quexProcessed_ByteLoader* alter_ego, quexProcessed_stream_position_t Pos) 
{ 
    quexProcessed_ByteLoader_FILE* me = (quexProcessed_ByteLoader_FILE*)(alter_ego);
#   if 0
    printf("#seek from: %i to: %i;\n", (int)ftell(me->input_handle), (int)Pos);
#   endif
    fseek(me->input_handle, (long)Pos, SEEK_SET); 
}

inline size_t  
quexProcessed_ByteLoader_FILE_load(quexProcessed_ByteLoader* alter_ego, 
                                void*                  buffer, 
                                const size_t           ByteN, 
                                bool*                  end_of_stream_f) 
{ 
    quexProcessed_ByteLoader_FILE* me = (quexProcessed_ByteLoader_FILE*)(alter_ego);
    size_t                      loaded_byte_n = fread(buffer, 1, ByteN, me->input_handle); 
#   if 0
    int    i;
    printf("#load @%i:         [", (int)ftell(me->input_handle));
    for(i=0; i<(int)loaded_byte_n; ++i) printf("%02X.", ((uint8_t*)buffer)[i]);
    printf("]\n");
#   endif
    *end_of_stream_f = feof(me->input_handle) ? true : false;
    return loaded_byte_n;
}

inline bool  
quexProcessed_ByteLoader_FILE_compare_handle(const quexProcessed_ByteLoader* alter_ego_A, 
                                          const quexProcessed_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same FILE object.
 *          false -- else.                                                   */
{ 
    const quexProcessed_ByteLoader_FILE* A = (quexProcessed_ByteLoader_FILE*)(alter_ego_A);
    const quexProcessed_ByteLoader_FILE* B = (quexProcessed_ByteLoader_FILE*)(alter_ego_B);

    return A->input_handle == B->input_handle;
}

inline void                       
quexProcessed_ByteLoader_FILE_print_this(quexProcessed_ByteLoader* alter_ego)
{
    quexProcessed_ByteLoader_FILE* me = (quexProcessed_ByteLoader_FILE*)(alter_ego);

    QUEX_DEBUG_PRINT("        type:             FILE;\n");
    QUEX_DEBUG_PRINT1("        file_handle:      ((%p));\n", (const void*)me->input_handle);
    if( me->input_handle ) {
        QUEX_DEBUG_PRINT1("        end_of_stream:    %s;\n", E_Boolean_NAME(feof(me->input_handle)));
    }
}



#endif /*  QUEX_INCLUDE_GUARD_quexProcessed__BUFFER__BYTES__BYTE_LOADER_FILE_I */
