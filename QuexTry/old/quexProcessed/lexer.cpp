#include<fstream>
#include<iostream>

#include "tiny_lexer"

int main(int argc, char** argv)
{
    quex::Token*       token_p = 0x0;
    quex::tiny_lexer   qlex("example.txt");

    do {
        qlex.receive(&token_p);       // --token-policy queue
        // token_id = qlex.receive(); // --token-policy single
        std::cout << token_p->type_id_name() << std::endl;

    } while( token_p->type_id() != QUEX_TKN_TERMINATION );

    return 0;
}
