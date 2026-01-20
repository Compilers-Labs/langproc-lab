%option noyywrap

%{

#include "nocomment.hpp"

// The following line avoids an annoying warning in Flex
// See: https://stackoverflow.com/questions/46213840/
extern "C" int fileno(FILE *stream);

%}

%x ESCID
%x ATTR 
%x COMMENT
%x COMMENT_IN_ATTR
%x ESCID_IN_ATTR

%%


<INITIAL>"(*" {
  yylval.attr_sequence = "(*";
  BEGIN(ATTR);
}

<INITIAL>"\\" {
    yylval.escid_sequence = yytext[0];
    BEGIN(ESCID);
}

<INITIAL>"//" {
  BEGIN(COMMENT);
  return AddCommentCount;
}

<INITIAL>. {
  yylval.character = yytext[0];
  return DumpChar;
}

<ATTR>"\\" {
  yylval.attr_sequence += yytext[0];
  BEGIN(ESCID_IN_ATTR);
}

<ATTR>"//" {
  BEGIN(COMMENT_IN_ATTR);
}

<ATTR>"*)" {
  BEGIN(INITIAL);
  return AddCommentCount;
}

<ATTR>(.|\n) {
  yylval.attr_sequence += yytext[0];
}

<ATTR>EOF {
  return EofAttr; //dump sequence and reg eof
}

<COMMENT>. {}

<COMMENT>\n {
  BEGIN(INITIAL);
}

<COMMENT>EOF {
    return Eof;
}

<ESCID>[^ \n]  {
  yylval.escid_sequence += yytext[0];
}

<ESCID>[ \n] {
  yylval.escid_sequence += yytext[0];
  BEGIN(INITIAL);
  return DumpEscId; //dump sequence
}

<ESCID>EOF {
  return EofEscId; //dump esc sequence and reg eof
}

<ESCID_IN_ATTR>[^ \n] {
  yylval.attr_sequence += yytext[0];
}

<ESCID_IN_ATTR>[ \n] {
  yylval.attr_sequence += yytext[0];
  BEGIN(ATTR);
}

<ESCID_IN_ATTR>EOF {
  return EofAttr; //dump sequence reg off
}

<COMMENT_IN_ATTR>. {}

<COMMENT_IN_ATTR>\n {
  BEGIN(ATTR);
}

<COMMENT_IN_ATTR>EOF {
    return EofAttr; //dump seq reg off
}

%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s);
  exit(1);
}



