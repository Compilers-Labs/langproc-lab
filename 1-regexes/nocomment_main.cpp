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
      
    } else if (type == EofAttr) {

      std::cout << yylval.attr_sequence;
      comments_removed += pending_attr_comments;
      break;

    } else if (type == EofEscId) {
      
      std::cout << yylval.escid_sequence;
      break;

    } else if (type == DumpEscId){
      
      std::cout << yylval.escid_sequence;

    } else if (type == DumpChar) {
      
      std::cout << yylval.character;

    } else if (type == AddCommentCount) {

      comments_removed++;

    } else if(type == EofAttrAndAdd){
      
      comments_removed++;
      break;

    } else if (type == Eof) {

      break;

    } else {
        
      assert(0); // Error out!
      return 1;
      
    }
  }

  std::cout << "Number of comments and attributes removed: " << comments_removed << ".\n";
    
  return 0;
}
