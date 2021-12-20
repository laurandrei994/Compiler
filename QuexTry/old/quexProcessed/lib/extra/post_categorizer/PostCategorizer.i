/* -*- C++ -*- vim: set syntax=cpp: */
#ifndef QUEX_INCLUDE_GUARD_quexProcessed__EXTRA__POST_CATEGORIZER__POST_CATEGORIZER_I
#define QUEX_INCLUDE_GUARD_quexProcessed__EXTRA__POST_CATEGORIZER__POST_CATEGORIZER_I

#include "quexProcessed/lib/extra/post_categorizer/PostCategorizer"
#include "quexProcessed/lib/lexeme/basics"
#include "quexProcessed/lib/lexeme/converter-from-lexeme"
#include "quexProcessed/lib/quex/MemoryManager"
#include "quexProcessed/lib/quex/standard_functions"
#include "quexProcessed/lib/quex/debug_print"
#include "quexProcessed/lib/quex/asserts"




inline void
quexProcessed_PostCategorizer__enter(quexProcessed_Dictionary*    me, 
                                  const quexProcessed_lexatom_t*  EntryName, 
                                  quexProcessed_token_id_t        TokenID);
                          
inline void          
quexProcessed_PostCategorizer__insert(quexProcessed_Dictionary*    me, 
                                   const quexProcessed_lexatom_t*  EntryName, 
                                   quexProcessed_token_id_t        TokenID);
                          
inline quexProcessed_token_id_t 
quexProcessed_PostCategorizer__get_token_id(const quexProcessed_Dictionary*  me,
                                         const quexProcessed_lexatom_t*      Lexeme);

inline void          
quexProcessed_PostCategorizer__remove(quexProcessed_Dictionary*    me, 
                                   const quexProcessed_lexatom_t*  EntryName);
                          
inline void          
quexProcessed_PostCategorizer__clear(quexProcessed_Dictionary* me);
                          
inline void          
quexProcessed_PostCategorizer__clear_recursively(quexProcessed_Dictionary*      me, 
                                              quexProcessed_DictionaryNode*  branch);
inline int           
quexProcessed_PostCategorizer__compare(quexProcessed_DictionaryNode*  me, 
                                    quexProcessed_lexatom_t           FirstCharacter, 
                                    const quexProcessed_lexatom_t*    Remainder);

inline quexProcessed_DictionaryNode*  
quexProcessed_PostCategorizer__allocate_node(const quexProcessed_lexatom_t* Remainder);

inline void 
quexProcessed_PostCategorizer__free_node(quexProcessed_DictionaryNode* node);

inline quexProcessed_DictionaryNode*
quexProcessed_PostCategorizer__find(const quexProcessed_Dictionary* me, 
                                 const quexProcessed_lexatom_t*     EntryName);



inline  quexProcessed_DictionaryNode*  
quexProcessed_PostCategorizer__allocate_node(const quexProcessed_lexatom_t* Remainder)
{
    const size_t  RemainderL = quexProcessed_lexeme_length(Remainder);
    /* Allocate in one beat: base and remainder: 
     *
     *   [Base   |Remainder             ]
     *
     * Then bend the base->name_remainder to the Remainder part of the allocated
     * memory. Note, that this is not very efficient, since one should try to allocate
     * the small node objects and refer to the remainder only when necessary. This
     * would reduce cache misses.                                                      */
    const size_t   BaseSize      = sizeof(quexProcessed_DictionaryNode);
    /* Length + 1 == memory size (terminating zero) */
    const size_t   RemainderSize = sizeof(quexProcessed_lexatom_t) * (RemainderL + 1);
    uint8_t*       base          = 
                      (uint8_t*)
                      quex::MemoryManager_allocate(BaseSize + RemainderSize, 
                                                     E_MemoryObjectType_POST_CATEGORIZER_NODE);
    ((quexProcessed_DictionaryNode*)base)->name_remainder = (const quexProcessed_lexatom_t*)(base + BaseSize);
    return (quexProcessed_DictionaryNode*)base;
}

inline  void 
quexProcessed_PostCategorizer__free_node(quexProcessed_DictionaryNode* node)
{ 
    if( ! node ) return;
    
    quex::MemoryManager_free((void*)node, 
                               E_MemoryObjectType_POST_CATEGORIZER_NODE); 
}

inline quexProcessed_DictionaryNode* 
quexProcessed_DictionaryNode_new(quexProcessed_lexatom_t         FirstCharacter,
                              const quexProcessed_lexatom_t*  Remainder,
                              quexProcessed_token_id_t        TokenID)
{
    quexProcessed_DictionaryNode* me = quexProcessed_PostCategorizer__allocate_node(Remainder);

    me->name_first_character = FirstCharacter;
    me->name_remainder       = Remainder;
    me->token_id             = TokenID;
    me->lesser               = 0x0;
    me->greater              = 0x0;

    return me;
}

inline bool
quexProcessed_PostCategorizer_construct(quexProcessed_Dictionary* me)
{
    me->root = 0x0;

    return true;
}

inline void
quexProcessed_PostCategorizer_destruct(quexProcessed_Dictionary* me)
{
    quexProcessed_PostCategorizer__clear(me);
}

inline int
quexProcessed_PostCategorizer__compare(quexProcessed_DictionaryNode* me, 
                                    quexProcessed_lexatom_t          FirstCharacter, 
                                    const quexProcessed_lexatom_t*   Remainder)
    /* Returns: '0'   if both strings are the same
       '< 0' string 0 < string 1
       '> 0' string 0 > string 1           */
{
    const quexProcessed_lexatom_t* it0 = 0x0;
    const quexProcessed_lexatom_t* it1 = 0x0;

    if     ( FirstCharacter > me->name_first_character ) return 1;
    else if( FirstCharacter < me->name_first_character ) return -1;
    else {
        /* Implementation according to: P.J. Plauger, "The Standard C Library", 1992 */
        it0 = Remainder;
        it1 = me->name_remainder;
        for(; *it0 == *it1; ++it0, ++it1) {
            /* Both letters are the same and == 0?
             * => both reach terminall zero without being different. */
            if( *it0 == 0 ) return 0;
        }
        return (int)(*it0) - (int)(*it1);
    }
}

inline void
quexProcessed_PostCategorizer__enter(quexProcessed_Dictionary* me,
                                  const quexProcessed_lexatom_t*  EntryName, 
                                  const quexProcessed_token_id_t    TokenID)
{
    quexProcessed_lexatom_t           FirstCharacter = EntryName[0];
    const quexProcessed_lexatom_t*    Remainder = FirstCharacter == 0x0 ? 0x0 : EntryName + 1;
    quexProcessed_DictionaryNode*    node      = me->root;
    quexProcessed_DictionaryNode*    prev_node = 0x0;
    int                           result = 0;

    if( me->root == 0x0 ) {
        me->root = quexProcessed_DictionaryNode_new(FirstCharacter, Remainder, TokenID);
        return;
    }
    while( node != 0x0 ) {
        prev_node = node;
        result    = quexProcessed_PostCategorizer__compare(node, FirstCharacter, Remainder);
        if     ( result > 0 ) node = node->greater;
        else if( result < 0 ) node = node->lesser;
        else                  return; /* Node with that name already exists */
    }
    __quex_assert( prev_node != 0x0 );
    __quex_assert( result != 0 );

    if( result > 0 ) 
        prev_node->greater = quexProcessed_DictionaryNode_new(FirstCharacter, Remainder, TokenID);
    else 
        prev_node->lesser  = quexProcessed_DictionaryNode_new(FirstCharacter, Remainder, TokenID);
}

inline void
quexProcessed_PostCategorizer__remove(quexProcessed_Dictionary*  me,
                                   const quexProcessed_lexatom_t*   EntryName)
{
    int                         result = 0;
    quexProcessed_lexatom_t           FirstCharacter = EntryName[0];
    const quexProcessed_lexatom_t*    Remainder = FirstCharacter == 0x0 ? 0x0 : EntryName + 1;
    quexProcessed_DictionaryNode*  node   = 0x0;
    quexProcessed_DictionaryNode*  parent = 0x0;
    quexProcessed_DictionaryNode*  found  = me->root;

    __quex_assert( found != 0x0 );
    while( 1 + 1 == 2 ) {
        result = quexProcessed_PostCategorizer__compare(found, FirstCharacter, Remainder);

        /* result == 0: found's name == EntryName 
         * On 'break': If found == root then parent = 0x0 which triggers a special treatment. */
        if( result == 0 ) break;

        parent = found;

        if     ( result > 0 )  found = found->greater;
        else if( result < 0 ) found = found->lesser;

        if( found == 0x0 ) return; /* Not found name with that name */
    };
    /* Found a node with 'EntryName' */

    /* Remove node and re-order tree */
    if( ! parent ) {
        if( found->lesser ) {
            for(node = found->lesser; node->greater != 0x0; node = node->greater );
            node->greater = found->greater;
            me->root      = found->lesser;
        } else {
            me->root      = found->greater;
        }
    }
    else if( found == parent->lesser ) {
        /* (1) 'found' is the 'lesser' child of the parent:
         *
         *                 (parent's greater tree)
         *                /
         *        (parent)        (greater tree)
         *               \       /
         *                (found)
         *                       \
         *                        (lesser tree)
         *
         *     All subnodes of (greater tree) are greater than all subnodes in (lesser tree).
         *     => (i) mount (lesser tree) to the least node of (greater tree).                
         *     Anything in the subtree of 'found' is lesser than anything in 'parent's 
         *     greater tree.
         *     => (ii) mount (greater tree) to the least node of the (parent's greater tree). */
        /* parent != 0x0, see above */
        if( found->greater ) {
            for(node = found->greater; node->lesser != 0x0; node = node->lesser );
            node->lesser   = found->lesser;
            parent->lesser = found->greater;
        } else {
            parent->lesser = found->lesser;
        }

    } else {
        /* (2) 'found' is the 'greater' child of the parent:
         *
         *     (i)  mount (greater tree) to the greatest node of (greater tree).                  
         *     (ii) mount (lesser tree) to the greatest node of the (parent's lesser tree). */
        /* parent != 0x0, see above */
        if( found->lesser ) {
            for(node = found->lesser; node->greater != 0x0; node = node->greater );
            node->greater   = found->greater;
            parent->greater = found->lesser;
        } else {
            parent->greater = found->greater;
        }
    }
    quexProcessed_PostCategorizer__free_node(found);
}

inline quexProcessed_DictionaryNode*
quexProcessed_PostCategorizer__find(const quexProcessed_Dictionary*  me, 
                                 const quexProcessed_lexatom_t*      EntryName)
{
    quexProcessed_lexatom_t           FirstCharacter = EntryName[0];
    const quexProcessed_lexatom_t*    Remainder      = FirstCharacter == 0x0 ? 0x0 : EntryName + 1;
    quexProcessed_DictionaryNode*  node           = me->root;

    while( node != 0x0 ) {
        int result = quexProcessed_PostCategorizer__compare(node, FirstCharacter, Remainder);

        if     ( result > 0 ) node = node->greater;
        else if( result < 0 ) node = node->lesser;
        else                  return node;
    }
    return 0x0;
}

inline void
quexProcessed_PostCategorizer__clear_recursively(quexProcessed_Dictionary*      me, 
                                             quexProcessed_DictionaryNode*  branch)
{
    __quex_assert(branch);

    if( branch->lesser )  quexProcessed_PostCategorizer__clear_recursively(me, branch->lesser);
    if( branch->greater ) quexProcessed_PostCategorizer__clear_recursively(me, branch->greater);
    quexProcessed_PostCategorizer__free_node(branch);
}

inline quexProcessed_token_id_t 
quexProcessed_PostCategorizer__get_token_id(const quexProcessed_Dictionary*  me,
                                         const quexProcessed_lexatom_t*      Lexeme)
{
    quexProcessed_DictionaryNode* found = quexProcessed_PostCategorizer__find(me, Lexeme);
    if( ! found ) return  QUEX_TKN_TERMINATION;
    return found->token_id;
}

inline void
quexProcessed_PostCategorizer__clear(quexProcessed_Dictionary* me)
{
    if( ! me->root ) return;
    quexProcessed_PostCategorizer__clear_recursively(me, me->root);
    me->root = (quexProcessed_DictionaryNode*)0;
}

inline void
quexProcessed_PostCategorizer_resources_absent_mark(quexProcessed_Dictionary* me)
{ 
    me->root = (quexProcessed_DictionaryNode*)0;
}

inline bool
quexProcessed_PostCategorizer_resources_absent(quexProcessed_Dictionary* me)
{ 
    return me->root == (quexProcessed_DictionaryNode*)0;
}

inline void
quexProcessed_PostCategorizer__print_tree(quexProcessed_DictionaryNode* node, int Depth)
{
    int i = 0;
    if( ! node ) {
        for(i=0; i<Depth; ++i) QUEX_DEBUG_PRINT("        ");
        QUEX_DEBUG_PRINT("[EMPTY]\n");
        return;
    }

    quexProcessed_PostCategorizer__print_tree(node->greater, Depth + 1);

    for(i=0; i < Depth + 1; ++i) QUEX_DEBUG_PRINT("        ");
    QUEX_DEBUG_PRINT("/\n");

    for(i=0; i<Depth; ++i) QUEX_DEBUG_PRINT("        ");
    {
        uint8_t                  drain[256];
        uint8_t*                 drain_p     = &drain[0];
        uint8_t*                 remainder_p = (uint8_t*)0; 
        const quexProcessed_lexatom_t* source_p     = (quexProcessed_lexatom_t*)&node->name_first_character;
        const quexProcessed_lexatom_t* source_end_p = &source_p[1];

        /* Convert the first character                                       */
        quexProcessed_lexeme_nnzt_to_utf8(&source_p, source_end_p, &drain_p, &drain[256]);

        *drain_p++   = '\0';
        remainder_p  = drain_p;
        source_p     = (quexProcessed_lexatom_t*)node->name_remainder;
        source_end_p = &source_p[quexProcessed_lexeme_length((quexProcessed_lexatom_t*)source_p) + 1];

        /* Convert the remainder                                             */
        quexProcessed_lexeme_nnzt_to_utf8(&source_p, source_end_p, &drain_p, &drain[256]);

        QUEX_DEBUG_PRINT3("[%s]%s: %i\n", &drain[0], remainder_p, 
                          (int)node->token_id);
    }

    for(i=0; i<Depth + 1; ++i) QUEX_DEBUG_PRINT("        ");
    QUEX_DEBUG_PRINT("\\\n");

    quexProcessed_PostCategorizer__print_tree(node->lesser, Depth + 1);
}

inline void
quexProcessed_PostCategorizer_print_this(quexProcessed_Dictionary* me)
{
    quexProcessed_PostCategorizer__print_tree(me->root, 0);
}



inline 
quexProcessed_Dictionary::quexProcessed_Dictionary()
{ /* C/C++ Compability: Constructors/Destructors do nothing. */ }

inline
quexProcessed_Dictionary::~quexProcessed_Dictionary()
{ /* C/C++ Compability: Constructors/Destructors do nothing. */ }

inline void
quexProcessed_Dictionary::clear()
{ quexProcessed_PostCategorizer__clear(this); }

inline quexProcessed_token_id_t 
quexProcessed_Dictionary::get_token_id(const quexProcessed_lexatom_t* Lexeme) const
{ return quexProcessed_PostCategorizer__get_token_id(this, Lexeme); }

inline void
quexProcessed_Dictionary::remove(const quexProcessed_lexatom_t* EntryName)
{ quexProcessed_PostCategorizer__remove(this, EntryName); }

inline void
quexProcessed_Dictionary::enter(const quexProcessed_lexatom_t*  EntryName, 
                             const quexProcessed_token_id_t    TokenID)
{ quexProcessed_PostCategorizer__enter(this, EntryName, TokenID); }

inline void
quexProcessed_Dictionary::print_this()
{ quexProcessed_PostCategorizer_print_this(this); }





#include "quexProcessed/lib/lexeme/basics.i"

#endif /* QUEX_INCLUDE_GUARD_quexProcessed__EXTRA__POST_CATEGORIZER__POST_CATEGORIZER_I */
