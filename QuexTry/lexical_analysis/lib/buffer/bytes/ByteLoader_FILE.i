/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_FILE_I
#define  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_FILE_I

#include "lexical_analysis/lib/quex/MemoryManager"



 void                       Calc_lexer_ByteLoader_FILE_construct(Calc_lexer_ByteLoader_FILE* me, __QUEX_STD_FILE* fh);
 Calc_lexer_stream_position_t  Calc_lexer_ByteLoader_FILE_tell(Calc_lexer_ByteLoader* me);
 void                       Calc_lexer_ByteLoader_FILE_seek(Calc_lexer_ByteLoader* me, Calc_lexer_stream_position_t Pos);
 size_t                     Calc_lexer_ByteLoader_FILE_load(Calc_lexer_ByteLoader* me, void* buffer, const size_t ByteN, bool*);
 void                       Calc_lexer_ByteLoader_FILE_delete_self(Calc_lexer_ByteLoader* me);
 void                       Calc_lexer_ByteLoader_FILE_print_this(Calc_lexer_ByteLoader* me);
 bool                       Calc_lexer_ByteLoader_FILE_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                                                                 const Calc_lexer_ByteLoader* alter_ego_B);

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_FILE_new(FILE* fh, bool BinaryModeF)
{
    Calc_lexer_ByteLoader_FILE* me;
   
    if( ! fh ) return (Calc_lexer_ByteLoader*)0;

    me = (Calc_lexer_ByteLoader_FILE*)quex_MemoryManager_allocate(sizeof(Calc_lexer_ByteLoader_FILE),
                                                                     E_MemoryObjectType_BYTE_LOADER);
    if( ! me ) return (Calc_lexer_ByteLoader*)0;

    Calc_lexer_ByteLoader_FILE_construct(me, fh);
    me->base.binary_mode_f = BinaryModeF;

    return &me->base;
}

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_FILE_new_from_file_name(const char* FileName)
{
    __QUEX_STD_FILE*        fh = fopen(FileName, "rb");
    Calc_lexer_ByteLoader*  alter_ego;

    if( ! fh ) {
        return (Calc_lexer_ByteLoader*)0;
    }
    alter_ego = Calc_lexer_ByteLoader_FILE_new(fh, true);
    if( ! alter_ego ) {
        __QUEX_STD_fclose(fh);
        return (Calc_lexer_ByteLoader*)0;
    }

    /* ByteLoader from file name *must* be owned by lexical analyzer, 
     * to ensure automatic closure and deletion.                              */
    alter_ego->handle_ownership = E_Ownership_LEXICAL_ANALYZER;
    return alter_ego;
}

 void
Calc_lexer_ByteLoader_FILE_construct(Calc_lexer_ByteLoader_FILE* me, __QUEX_STD_FILE* fh)
{
    /* IMPORTANT: input_handle must be set BEFORE call to base constructor!
     *            Constructor does call 'tell()'                             */
    me->input_handle = fh;

    Calc_lexer_ByteLoader_construct(&me->base,
                         Calc_lexer_ByteLoader_FILE_tell,
                         Calc_lexer_ByteLoader_FILE_seek,
                         Calc_lexer_ByteLoader_FILE_load,
                         Calc_lexer_ByteLoader_FILE_delete_self,
                         Calc_lexer_ByteLoader_FILE_print_this,
                         Calc_lexer_ByteLoader_FILE_compare_handle);
}

 void    
Calc_lexer_ByteLoader_FILE_delete_self(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_FILE* me = (Calc_lexer_ByteLoader_FILE*)(alter_ego);

    if( me->input_handle && me->base.handle_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        __QUEX_STD_fclose(me->input_handle);
    }
    quex_MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);
}

 Calc_lexer_stream_position_t    
Calc_lexer_ByteLoader_FILE_tell(Calc_lexer_ByteLoader* alter_ego)            
{ 
    Calc_lexer_ByteLoader_FILE* me = (Calc_lexer_ByteLoader_FILE*)(alter_ego);

    return (Calc_lexer_stream_position_t)ftell(me->input_handle); 
}

 void    
Calc_lexer_ByteLoader_FILE_seek(Calc_lexer_ByteLoader* alter_ego, Calc_lexer_stream_position_t Pos) 
{ 
    Calc_lexer_ByteLoader_FILE* me = (Calc_lexer_ByteLoader_FILE*)(alter_ego);
#   if 0
    printf("#seek from: %i to: %i;\n", (int)ftell(me->input_handle), (int)Pos);
#   endif
    fseek(me->input_handle, (long)Pos, SEEK_SET); 
}

 size_t  
Calc_lexer_ByteLoader_FILE_load(Calc_lexer_ByteLoader* alter_ego, 
                                void*                  buffer, 
                                const size_t           ByteN, 
                                bool*                  end_of_stream_f) 
{ 
    Calc_lexer_ByteLoader_FILE* me = (Calc_lexer_ByteLoader_FILE*)(alter_ego);
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

 bool  
Calc_lexer_ByteLoader_FILE_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                          const Calc_lexer_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same FILE object.
 *          false -- else.                                                   */
{ 
    const Calc_lexer_ByteLoader_FILE* A = (Calc_lexer_ByteLoader_FILE*)(alter_ego_A);
    const Calc_lexer_ByteLoader_FILE* B = (Calc_lexer_ByteLoader_FILE*)(alter_ego_B);

    return A->input_handle == B->input_handle;
}

 void                       
Calc_lexer_ByteLoader_FILE_print_this(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_FILE* me = (Calc_lexer_ByteLoader_FILE*)(alter_ego);

    QUEX_DEBUG_PRINT("        type:             FILE;\n");
    QUEX_DEBUG_PRINT1("        file_handle:      ((%p));\n", (const void*)me->input_handle);
    if( me->input_handle ) {
        QUEX_DEBUG_PRINT1("        end_of_stream:    %s;\n", E_Boolean_NAME(feof(me->input_handle)));
    }
}



#endif /*  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_FILE_I */
