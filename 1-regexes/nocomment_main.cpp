#include "nocomment.hpp"

#include <iostream>
#include <cassert>

// This is the yylval variable that the nocomment.hpp header file refers to.
TokenValue yylval;

int main () { 
  
  int comments_removed = 0;

  while (1) {

    // Lex the next character in the input stream.
    TokenType type = (TokenType) yylex();
    
    if (type == Eof) {
      
      break;
      
    } else if (type == LineComment) {
      comments_removed++;

    } else if (type == InlineComment) {
      
      comments_removed++;

    } else if (type == LongComment){

      comments_removed++; 

    } else if (type == SlashedSection) {
      
      std::cout << yylval.sequence;

    } else if (type == Other) {

      std::cout << yylval.character;

    } else {
        
      assert(0); // Error out!
      return 1;
      
    }
  }

  std::cout << "Number of comments and attributes removed: " << comments_removed << ".\n";
    
  return 0;
}
