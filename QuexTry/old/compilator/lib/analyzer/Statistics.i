#ifndef QUEX_INCLUDE_GUARD_compilator__ANALYZER__STATISTICS_I
#define QUEX_INCLUDE_GUARD_compilator__ANALYZER__STATISTICS_I

#include "compilator\lib\analyzer/Statistics"

inline void
compilator_statistics_state_count(const compilator_statistics_state* S, compilator_lexatom_t C)
{
    const compilator_lexatom_t*  BeginP   = S->interval_list.boundary;
    const compilator_lexatom_t*  EndP     = BeginP + S->interval_list.boundary_n;
    const compilator_lexatom_t*  low      = BeginP;
    const compilator_lexatom_t*  up       = EndP;
    const compilator_lexatom_t*  iterator = (const compilator_lexatom_t*)0x0; 

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
compilator_statistics_save(const char* Filename)
{
    const compilator_statistics_state*  BeginP = (const compilator_statistics_state*)compilator_statistics_state_list;
    const compilator_statistics_state*  EndP   = compilator_statistics_state_list_end;
    const compilator_statistics_state*  s      = (const compilator_statistics_state*)0x0;
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

#endif /* QUEX_INCLUDE_GUARD_compilator__ANALYZER__STATISTICS_I */


