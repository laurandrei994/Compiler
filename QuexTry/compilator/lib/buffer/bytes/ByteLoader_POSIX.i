/* vim: ft=c:
 * (C) Frank-Rene Schaefer */
#ifndef  QUEX_INCLUDE_GUARD_compilator__BUFFER__BYTES__BYTE_LOADER_POSIX_I
#define  QUEX_INCLUDE_GUARD_compilator__BUFFER__BYTES__BYTE_LOADER_POSIX_I

#include "compilator\lib\buffer/bytes/ByteLoader_POSIX"
#include "compilator\lib\quex/MemoryManager"
#include "compilator\lib\definitions"



inline void                       compilator_ByteLoader_POSIX_construct(compilator_ByteLoader_POSIX* me, int fd);
inline compilator_stream_position_t  compilator_ByteLoader_POSIX_tell(compilator_ByteLoader* me);
inline void                       compilator_ByteLoader_POSIX_seek(compilator_ByteLoader* me, 
                                                                        compilator_stream_position_t Pos);
inline size_t                     compilator_ByteLoader_POSIX_load(compilator_ByteLoader* me, 
                                                                        void* buffer, const size_t ByteN, 
                                                                        bool*);
inline void                       compilator_ByteLoader_POSIX_delete_self(compilator_ByteLoader* me);
inline void                       compilator_ByteLoader_POSIX_print_this(compilator_ByteLoader* me);
inline bool                       compilator_ByteLoader_POSIX_compare_handle(const compilator_ByteLoader* alter_ego_A, 
                                                                       const compilator_ByteLoader* alter_ego_B);

inline compilator_ByteLoader*    
compilator_ByteLoader_POSIX_new(int fd)
{
    compilator_ByteLoader_POSIX* me;

    if( fd == -1 ) return (compilator_ByteLoader*)0;
    me = (compilator_ByteLoader_POSIX*)quex::MemoryManager_allocate(sizeof(compilator_ByteLoader_POSIX),
                                                           E_MemoryObjectType_BYTE_LOADER);
    if( ! me ) return (compilator_ByteLoader*)0;
    compilator_ByteLoader_POSIX_construct(me, fd);
    return &me->base;
}

inline compilator_ByteLoader*    
compilator_ByteLoader_POSIX_new_from_file_name(const char* FileName)
{
    compilator_ByteLoader*  alter_ego;
    int                     fd = open(FileName, O_RDONLY);

    if( fd == -1 ) {
        return (compilator_ByteLoader*)0;
    }
    alter_ego = compilator_ByteLoader_POSIX_new(fd);
    if( ! alter_ego ) {
        return (compilator_ByteLoader*)0;
    }

    /* ByteLoader from file name *must* be owned by lexical analyzer, 
     * to ensure automatic closure and deletion.                              */
    alter_ego->handle_ownership = E_Ownership_LEXICAL_ANALYZER;
    return alter_ego;
}

inline void
compilator_ByteLoader_POSIX_construct(compilator_ByteLoader_POSIX* me, int fd)
{
    /* IMPORTANT: fd must be set BEFORE call to constructor!
     *            Constructor does call 'tell()'                             */
    me->fd = fd;

    compilator_ByteLoader_construct(&me->base,
                                    compilator_ByteLoader_POSIX_tell,
                                    compilator_ByteLoader_POSIX_seek,
                                    compilator_ByteLoader_POSIX_load,
                                    compilator_ByteLoader_POSIX_delete_self,
                                    compilator_ByteLoader_POSIX_print_this,
                                    compilator_ByteLoader_POSIX_compare_handle);

    /* A POSIX file handle is always in binary mode.                         */
    me->base.binary_mode_f = true;
}

inline void    
compilator_ByteLoader_POSIX_delete_self(compilator_ByteLoader* alter_ego)
{
    compilator_ByteLoader_POSIX* me = (compilator_ByteLoader_POSIX*)(alter_ego);

    if( me->fd && me->base.handle_ownership == E_Ownership_LEXICAL_ANALYZER ) {
        close(me->fd);
    }
    quex::MemoryManager_free(me, E_MemoryObjectType_BYTE_LOADER);
}

inline compilator_stream_position_t    
compilator_ByteLoader_POSIX_tell(compilator_ByteLoader* alter_ego)            
{ 
    compilator_ByteLoader_POSIX* me = (compilator_ByteLoader_POSIX*)(alter_ego);
    /* Use 'lseek(current position + 0)' to get the current position.        */
    return (compilator_stream_position_t)lseek(me->fd, 0, SEEK_CUR); 
}

inline void    
compilator_ByteLoader_POSIX_seek(compilator_ByteLoader*    alter_ego, 
                                 compilator_stream_position_t Pos) 
{ 
    compilator_ByteLoader_POSIX* me = (compilator_ByteLoader_POSIX*)(alter_ego);
    lseek(me->fd, (long)Pos, SEEK_SET); 
}

inline size_t  
compilator_ByteLoader_POSIX_load(compilator_ByteLoader* alter_ego, 
                                 void*                  buffer, 
                                 const size_t           ByteN, 
                                 bool*                  end_of_stream_f) 
/* The POSIX interface does not allow to detect end of file upon reading.
 * The caller will realize end of stream by a return of zero bytes.          */
{ 
    compilator_ByteLoader_POSIX* me = (compilator_ByteLoader_POSIX*)(alter_ego);
    ssize_t                      n  = read(me->fd, buffer, ByteN); 
    /* Theoretically, a last 'terminating zero' might be send over socket 
     * connections. Make sure, that this does not appear in the stream.      */
    if( n && ((uint8_t*)buffer)[n-1] == 0x0 ) {
        --n;
    }
    *end_of_stream_f = false;
    return (size_t)n;
}

inline bool  
compilator_ByteLoader_POSIX_compare_handle(const compilator_ByteLoader* alter_ego_A, 
                                           const compilator_ByteLoader* alter_ego_B) 
/* RETURNS: true  -- if A and B point to the same POSIX object.
 *          false -- else.                                                   */
{ 
    const compilator_ByteLoader_POSIX* A = (compilator_ByteLoader_POSIX*)(alter_ego_A);
    const compilator_ByteLoader_POSIX* B = (compilator_ByteLoader_POSIX*)(alter_ego_B);

    return A->fd == B->fd;
}

inline void                       
compilator_ByteLoader_POSIX_print_this(compilator_ByteLoader* alter_ego)
{
    compilator_ByteLoader_POSIX* me = (compilator_ByteLoader_POSIX*)(alter_ego);

    QUEX_DEBUG_PRINT("        type:             POSIX;\n");
    QUEX_DEBUG_PRINT1("        file_descriptor:  ((%i));\n", (int)me->fd);
    QUEX_DEBUG_PRINT("        end_of_stream_f:  <no means to detect>;\n");
}



#endif /*  QUEX_INCLUDE_GUARD_compilator__BUFFER__BYTES__BYTE_LOADER_POSIX_I */

