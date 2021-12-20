#ifndef QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__STATISTICS_I
#define QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__STATISTICS_I

#include "quexProcessed/lib/analyzer/Statistics"

inline void
quexProcessed_statistics_state_count(const quexProcessed_statistics_state* S, quexProcessed_lexatom_t C)
{
    const quexProcessed_lexatom_t*  BeginP   = S->interval_list.boundary;
    const quexProcessed_lexatom_t*  EndP     = BeginP + S->interval_list.boundary_n;
    const quexProcessed_lexatom_t*  low      = BeginP;
    const quexProcessed_lexatom_t*  up       = EndP;
    const quexProcessed_lexatom_t*  iterator = (const quexProcessed_lexatom_t*)0x0; 

    /* Binary Search for the interval where 'C' belongs:
     * Find iterator so that: *(iterator-1) <= C < *(iterator) */
    while( up != low ) {
        iterator = low + ((up - low) >> 1);
        if( C < *iterator ) {
            if( iterator == BeginP )        break;
            else if( *(iterator - 1) <= C ) break; 
            up  = iterator;
        }
        else if( C >= *iterator ) { 
            if( iterator == EndP - 1 )      { iterator = EndP; break; }
            low = iterator;
        }
    }
    S->interval_list.counter[iterator - BeginP] += 1;
}

inline void
quexProcessed_statistics_save(const char* Filename)
{
    const quexProcessed_statistics_state*  BeginP = (const quexProcessed_statistics_state*)quexProcessed_statistics_state_list;
    const quexProcessed_statistics_state*  EndP   = quexProcessed_statistics_state_list_end;
    const quexProcessed_statistics_state*  s      = (const quexProcessed_statistics_state*)0x0;
    FILE*                               fh     = __QUEX_STD_fopen(Filename, "w");
    size_t                              i      = 0;

    if( fh == NULL ) return;

    for(s = BeginP; s != EndP; ++s) {
        __QUEX_STD_fprintf(fh, "{\nmode: %s;\nstate: %i; {\n", (const char*)s->mode_name, (int)s->state_index);
        for(i = 0; i != s->interval_list.boundary_n; ++i) {
            __QUEX_STD_fprintf(fh, "%i ", (int)s->interval_list.boundary[i]);
        }
        __QUEX_STD_fprintf(fh, ";\n");
        for(i = 0; i != s->interval_list.boundary_n + 1; ++i) {
            __QUEX_STD_fprintf(fh, "%i ", (int)s->interval_list.counter[i]);
        }
        __QUEX_STD_fprintf(fh, ";\n}\n");
    }

    __QUEX_STD_fclose(fh);
}

#endif /* QUEX_INCLUDE_GUARD_quexProcessed__ANALYZER__STATISTICS_I */


