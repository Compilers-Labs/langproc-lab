%option noyywrap

%{

#include "nocomment.hpp"

// The following line avoids an annoying warning in Flex
// See: https://stackoverflow.com/questions/46213840/
extern "C" int fileno(FILE *stream);

%}

%x ESCID
%x ATTR 

%%

<INITIAL>[\n][ ]"//"[^(\n)]*[\n] {
    return LineComment;
}

<INITIAL>"//"[^\n]*[\n] {
  return InlineComment;
}


<ATTR>[\n][ ]"//"[^(\n)]*[\n] {}

<ATTR>"//"[^\n]*[\n] {}


"(*" {
    BEGIN(ATTR);
}

<ATTR>. {}
<ATTR>\n {}

<ATTR>"*)" {
    BEGIN(INITIAL);
    return LongComment;
}

<INITIAL>"\\" {
  yylval.sequence = yytext[0];
  yylval.in_comment_flag = false;
  BEGIN(ESCID);
}


<ATTR>"\\" {
  yylval.sequence = yytext[0];
  yylval.in_comment_flag = true;
  BEGIN(ESCID);
}

<ESCID>" "  {
  yylval.sequence += yytext[0];

  if (yylval.in_comment_flag){
    BEGIN(ATTR);
  } else {
      BEGIN(INITIAL);
      return SlashedSection;
  }
}


<ESCID>\n {
  yylval.sequence += yytext[0];
  if (yylval.in_comment_flag){
    BEGIN(ATTR);
  } else {
      BEGIN(INITIAL);
      return SlashedSection;
  }
}
 

<ESCID>. {
  yylval.sequence += yytext[0];
}

. {
  yylval.character = yytext[0];
  return Other;
}

EOF {
  return Eof;
}

%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s);
  exit(1);
}



