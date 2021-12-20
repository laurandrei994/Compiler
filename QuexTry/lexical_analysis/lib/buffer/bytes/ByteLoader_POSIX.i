/* vim: ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_POSIX_I
#define  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_POSIX_I

#include "lexical_analysis/lib/buffer/bytes/ByteLoader_POSIX"
#include "lexical_analysis/lib/quex/MemoryManager"
#include "lexical_analysis/lib/definitions"



 void                       Calc_lexer_ByteLoader_POSIX_construct(Calc_lexer_ByteLoader_POSIX* me, int fd);
 Calc_lexer_stream_position_t  Calc_lexer_ByteLoader_POSIX_tell(Calc_lexer_ByteLoader* me);
 void                       Calc_lexer_ByteLoader_POSIX_seek(Calc_lexer_ByteLoader* me, 
                                                                        Calc_lexer_stream_position_t Pos);
 size_t                     Calc_lexer_ByteLoader_POSIX_load(Calc_lexer_ByteLoader* me, 
                                                                        void* buffer, const size_t ByteN, 
                                                                        bool*);
 void                       Calc_lexer_ByteLoader_POSIX_delete_self(Calc_lexer_ByteLoader* me);
 void                       Calc_lexer_ByteLoader_POSIX_print_this(Calc_lexer_ByteLoader* me);
 bool                       Calc_lexer_ByteLoader_POSIX_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                                                       const Calc_lexer_ByteLoader* alter_ego_B);

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_POSIX_new(int fd)
{
    Calc_lexer_ByteLoader_POSIX* me;

    if( fd == -1 ) return (Calc_lexer_ByteLoader*)0;
    me = (Calc_lexer_ByteLoader_POSIX*)quex_MemoryManager_allocate(sizeof(Calc_lexer_ByteLoader_POSIX),
                                                           E_MemoryObjectType_BYTE_LOADER);
    if( ! me ) return (Calc_lexer_ByteLoader*)0;
    Calc_lexer_ByteLoader_POSIX_construct(me, fd);
    return &me->base;
}

 Calc_lexer_ByteLoader*    
Calc_lexer_ByteLoader_POSIX_new_from_file_name(const char* FileName)
{
    Calc_lexer_ByteLoader*  alter_ego;
    int                     fd = open(FileName, O_RDONLY);

    if( fd == -1 ) {
        return (Calc_lexer_ByteLoader*)0;
    }
    alter_ego = Calc_lexer_ByteLoader_POSIX_new(fd);
    if( ! alter_ego ) {
        return (Calc_lexer_ByteLoader*)0;
    }

    /* ByteLoader from file name *must* be owned by lexical analyzer, 
     * to ensure automatic closure and deletion.                              */
    alter_ego->handle_ownership = E_Ownership_LEXICAL_ANALYZER;
    return alter_ego;
}

 void
Calc_lexer_ByteLoader_POSIX_construct(Calc_lexer_ByteLoader_POSIX* me, int fd)
{
    /* IMPORTANT: fd must be set BEFORE call to constructor!
     *            Constructor does call 'tell()'                             */
    me->fd = fd;

    Calc_lexer_ByteLoader_construct(&me->base,
                                    Calc_lexer_ByteLoader_POSIX_tell,
                                    Calc_lexer_ByteLoader_POSIX_seek,
                                    Calc_lexer_ByteLoader_POSIX_load,
                                    Calc_lexer_ByteLoader_POSIX_delete_self,
                                    Calc_lexer_ByteLoader_POSIX_print_this,
                                    Calc_lexer_ByteLoader_POSIX_compare_handle);

    /* A POSIX file handle is always in binary mode.                         */
    me->base.binary_mode_f = true;
}

 void    
Calc_lexer_ByteLoader_POSIX_delete_self(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_POSIX* me = (Calc_lexer_ByteLoader_POSIX*)(alter_ego);

    if( me->fd && me->base.handle_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        close(me->fd);
    }
    quex_MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);
}

 Calc_lexer_stream_position_t    
Calc_lexer_ByteLoader_POSIX_tell(Calc_lexer_ByteLoader* alter_ego)            
{ 
    Calc_lexer_ByteLoader_POSIX* me = (Calc_lexer_ByteLoader_POSIX*)(alter_ego);
    /* Use 'lseek(current position + 0)' to get the current position.        */
    return (Calc_lexer_stream_position_t)lseek(me->fd, 0, SEEK_CUR); 
}

 void    
Calc_lexer_ByteLoader_POSIX_seek(Calc_lexer_ByteLoader*    alter_ego, 
                                 Calc_lexer_stream_position_t Pos) 
{ 
    Calc_lexer_ByteLoader_POSIX* me = (Calc_lexer_ByteLoader_POSIX*)(alter_ego);
    lseek(me->fd, (long)Pos, SEEK_SET); 
}

 size_t  
Calc_lexer_ByteLoader_POSIX_load(Calc_lexer_ByteLoader* alter_ego, 
                                 void*                  buffer, 
                                 const size_t           ByteN, 
                                 bool*                  end_of_stream_f) 
/* The POSIX interface does not allow to detect end of file upon reading.
 * The caller will realize end of stream by a return of zero bytes.          */
{ 
    Calc_lexer_ByteLoader_POSIX* me = (Calc_lexer_ByteLoader_POSIX*)(alter_ego);
    ssize_t                      n  = read(me->fd, buffer, ByteN); 
    /* Theoretically, a last 'terminating zero' might be send over socket 
     * connections. Make sure, that this does not appear in the stream.      */
    if( n && ((uint8_t*)buffer)[n-1] == 0x0 ) {
        --n;
    }
    *end_of_stream_f = false;
    return (size_t)n;
}

 bool  
Calc_lexer_ByteLoader_POSIX_compare_handle(const Calc_lexer_ByteLoader* alter_ego_A, 
                                           const Calc_lexer_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same POSIX object.
 *          false -- else.                                                   */
{ 
    const Calc_lexer_ByteLoader_POSIX* A = (Calc_lexer_ByteLoader_POSIX*)(alter_ego_A);
    const Calc_lexer_ByteLoader_POSIX* B = (Calc_lexer_ByteLoader_POSIX*)(alter_ego_B);

    return A->fd == B->fd;
}

 void                       
Calc_lexer_ByteLoader_POSIX_print_this(Calc_lexer_ByteLoader* alter_ego)
{
    Calc_lexer_ByteLoader_POSIX* me = (Calc_lexer_ByteLoader_POSIX*)(alter_ego);

    QUEX_DEBUG_PRINT("        type:             POSIX;\n");
    QUEX_DEBUG_PRINT1("        file_descriptor:  ((%i));\n", (int)me->fd);
    QUEX_DEBUG_PRINT("        end_of_stream_f:  <no means to detect>;\n");
}



#endif /*  QUEX_INCLUDE_GUARD_Calc_lexer__BUFFER__BYTES__BYTE_LOADER_POSIX_I */

