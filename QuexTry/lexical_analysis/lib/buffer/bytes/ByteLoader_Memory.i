/* vim: set ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_MEMORY_I
#define  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_MEMORY_I

#include "lexical_analysis/lib/quex/MemoryManager"
#include "lexical_analysis/lib/buffer/bytes/ByteLoader_Memory"
#include <malloc.h> // DEBUG



 void                       Calc_lexer_ByteLoader_Memory_construct(Calc_lexer_ByteLoader_Memory* me,
                                                                              const uint8_t*                BeginP,
                                                                              const uint8_t*                EndP);
 Calc_lexer_stream_position_t  Calc_lexer_ByteLoader_Memory_tell(Calc_lexer_ByteLoader* me);
 void                       Calc_lexer_ByteLoader_Memory_seek(Calc_lexer_ByteLoader*    me, 
                                                                         Calc_lexer_stream_position_t Pos);
 size_t                     Calc_lexer_ByteLoader_Memory_load(Calc_lexer_ByteLoader* me, 
                                                                         void*                  buffer, 
                                                                         const size_t           ByteN, 
                                                                         bool*                  end_of_stream_f);
 void                       Calc_lexer_ByteLoader_Memory_delete_self(Calc_lexer_ByteLoader* me);
 void                       Calc_lexer_ByteLoader_Memory_print_this(Calc_lexer_ByteLoader* me);
 bool                       Calc_lexer_ByteLoader_Memory_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                                                                   const Calc_lexer_ByteLoader* alter_ego_B);

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_Memory_new(const uint8_t*  BeginP,
                                 const uint8_t*  EndP)
{
    Calc_lexer_ByteLoader_Memory* me;
   
    if( ! BeginP || ! EndP ) return (Calc_lexer_ByteLoader*)0;

    me = (Calc_lexer_ByteLoader_Memory*)quex_MemoryManager_allocate(sizeof(Calc_lexer_ByteLoader_Memory),
                                                                       E_MemoryObjectType_BYTE_LOADER);
    if( ! me ) return (Calc_lexer_ByteLoader*)0;

    Calc_lexer_ByteLoader_Memory_construct(me, BeginP, EndP);

    return &me->base;
}

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_Memory_new_from_file_name(const char* FileName)
{
    size_t                  size;
    uint8_t*                begin_p;
    Calc_lexer_ByteLoader*  me = (Calc_lexer_ByteLoader*)0;

    /* Determine size of file                                                */;
    FILE* fh = fopen(FileName, "rb"); 
    if( ! fh ) return me;
        
    if( fseek(fh, 0, SEEK_END) ) {
        fclose(fh);
        return me;
    }
    size = (size_t)ftell(fh);

    if( fseek(fh, 0, SEEK_SET) ) {
        fclose(fh);
        return me;
    }

    /* Load the file's content into some memory.                             */
    begin_p = (uint8_t*)quex_MemoryManager_allocate(size, E_MemoryObjectType_BUFFER_MEMORY);
    if( size != fread(begin_p, 1, size, fh) ) {
        quex_MemoryManager_free(begin_p, E_MemoryObjectType_BUFFER_MEMORY);
        return me;
    }

    /* Call the main new operator to allocate the byte loader.               */
    me = Calc_lexer_ByteLoader_Memory_new(begin_p, &begin_p[size]);
    if( ! me ) {
        quex_MemoryManager_free(begin_p, E_MemoryObjectType_BUFFER_MEMORY);
    }
    else {
        /* Mark memory ownership => destructor deletes it.                   */
        ((Calc_lexer_ByteLoader_Memory*)me)->memory_ownership = E_Ownership_LEXICAL_ANALYZER;
    }

    return me;
}

 void
Calc_lexer_ByteLoader_Memory_construct(Calc_lexer_ByteLoader_Memory* me, 
                                       const uint8_t*                BeginP,
                                       const uint8_t*                EndP)
{
    __quex_assert(EndP >= BeginP);
    me->byte_array.begin_p  = BeginP;
    me->byte_array.position = BeginP;
    me->byte_array.end_p    = EndP;
    Calc_lexer_ByteLoader_construct(&me->base,
                         Calc_lexer_ByteLoader_Memory_tell,
                         Calc_lexer_ByteLoader_Memory_seek,
                         Calc_lexer_ByteLoader_Memory_load,
                         Calc_lexer_ByteLoader_Memory_delete_self,
                         Calc_lexer_ByteLoader_Memory_print_this,
                         Calc_lexer_ByteLoader_Memory_compare_handle);
    me->base.binary_mode_f = true;
    me->memory_ownership   = E_Ownership_EXTERNAL; /* Default */
}

 void    
Calc_lexer_ByteLoader_Memory_delete_self(Calc_lexer_ByteLoader* alter_ego)
{
    /* NOTE: The momory's ownership remains in the hand of the one who
     *       constructed this object.                                        */
    Calc_lexer_ByteLoader_Memory* me = (Calc_lexer_ByteLoader_Memory*)(alter_ego);

    if( me->memory_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        quex_MemoryManager_free((void*)&me->byte_array.begin_p[0], 
                                   E_MemoryObjectType_BUFFER_MEMORY);
    }

    quex_MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);

}

 Calc_lexer_stream_position_t    
Calc_lexer_ByteLoader_Memory_tell(Calc_lexer_ByteLoader* alter_ego)            
{ 
    const Calc_lexer_ByteLoader_Memory* me = (Calc_lexer_ByteLoader_Memory*)(alter_ego);

    return me->byte_array.position - me->byte_array.begin_p;
}

 void    
Calc_lexer_ByteLoader_Memory_seek(Calc_lexer_ByteLoader* alter_ego, Calc_lexer_stream_position_t Pos) 
{ 
    Calc_lexer_ByteLoader_Memory* me = (Calc_lexer_ByteLoader_Memory*)(alter_ego);

    if( Pos > me->byte_array.end_p -  me->byte_array.begin_p ) return;
    me->byte_array.position = &me->byte_array.begin_p[(ptrdiff_t)Pos];
}

 size_t  
Calc_lexer_ByteLoader_Memory_load(Calc_lexer_ByteLoader* alter_ego, 
                                void*                    buffer, 
                                const size_t             ByteN, 
                                bool*                    end_of_stream_f) 
{ 
    Calc_lexer_ByteLoader_Memory* me = (Calc_lexer_ByteLoader_Memory*)(alter_ego);
    const ptrdiff_t               Remaining = me->byte_array.end_p - me->byte_array.position;
    ptrdiff_t                     copy_n;

    if( (size_t)Remaining < ByteN ) { copy_n = Remaining; *end_of_stream_f = true; }
    else                            { copy_n = ByteN; } 

    __QUEX_STD_memcpy((void*)buffer, (void*)me->byte_array.position, copy_n);
    me->byte_array.position += copy_n;
    return copy_n;
}

 bool  
Calc_lexer_ByteLoader_Memory_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                            const Calc_lexer_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same Memory object.
 *          false -- else.                                                   */
{ 
    const Calc_lexer_ByteLoader_Memory* A = (Calc_lexer_ByteLoader_Memory*)(alter_ego_A);
    const Calc_lexer_ByteLoader_Memory* B = (Calc_lexer_ByteLoader_Memory*)(alter_ego_B);

    return    A->byte_array.begin_p  == B->byte_array.begin_p
           && A->byte_array.end_p    == B->byte_array.end_p
           && A->byte_array.position == B->byte_array.position;
}

 void                       
Calc_lexer_ByteLoader_Memory_print_this(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_Memory* me = (Calc_lexer_ByteLoader_Memory*)(alter_ego);

    QUEX_DEBUG_PRINT("        type:             memory;\n");
    QUEX_DEBUG_PRINT1("        memory_ownership: %s;\n", E_Ownership_NAME(me->memory_ownership));
    QUEX_DEBUG_PRINT3("        byte_array:       { begin: ((%p)) end: ((%p)) size: %i; }\n",
                      (const void*)me->byte_array.begin_p, 
                      (const void*)me->byte_array.end_p, 
                      (int)(me->byte_array.end_p - me->byte_array.begin_p));
    QUEX_DEBUG_PRINT("        input_position:   ");
    quex_print_relative_positions(me->byte_array.begin_p, me->byte_array.end_p, 1, 
                                     (void*)me->byte_array.position);
    QUEX_DEBUG_PRINT("\n");
}



#endif /* QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_MEMORY_I */
