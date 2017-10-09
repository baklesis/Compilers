%{
#include <iostream>
#include <stdio.h>
using namespace std;
#define YY_DECL extern "C" int yylex()
//#define YYDEBUG 1

#include "bisonfile.tab.h"
int count = 0;
%}

%option yylineno

%%
":"		{ return COLON; }
","		{ return COMMA; }
"int"		{ return INTEGER; }
"char"		{ return CHARACTER; }
"bool"		{ return BOOLEAN; }
"double"	{ return DOUBLES; }
"true"		{ return BOOLV;   }
"false"		{ return BOOLV;   }
"void"		{ return VOID; }
"if"		{ return IF;   }
"else"		{ return ELSE; }
"for"		{ return FOR; }
"continue"	{ return CONTINUE; }
"break"		{ return BREAK; }
"return"	{ return RETURN; }
";"		{ return SEMICOLON; }
"("		{ return LPARE; }
")"		{ return RPARE; }
"?"		{ return QMARK; }
"new"		{ return NEW; }
"delete"	{ return DELETE; }
"NULL"		{ return NULLS; }
"["		{ return LBRACKET; }
"]"		{ return RBRACKET; }
"{"		{ return LBRACE; }
"}"		{ return RBRACE; }
"&"		{ return '&' ; }
"*"		{ return '*' ; }
"+" 		{ return '+' ; }
"-"		{ return '-' ; }
"!"		{ return '!' ; }
"/"		{ return '/' ; }
"%"		{ return '%' ; }
"<"		{ return '<' ; }
">"		{ return '>' ; }
"<="		{ return LE  ; }
">="		{ return GE  ; }
"=="		{ return EQ  ; }
"!="		{ return NE  ; }
"&&"		{ return LA  ; }
"||"            { return LO  ; }
"++"		{ return PLUSPLUS; }
"--"		{ return MINUSMINUS; }
"="		{ return '=' ; }
"*="		{ return MULAS ; }
"/="		{ return DIVAS ; }
"%="		{ return MODAS ; }
"+="		{ return PLUSAS ; }
"-+"		{ return MINUSAS ; }
\'[a-zA-Z]\' 		{ yylval.cval  =  strdup(yytext); return CHAR;   }
[0-9]+\.[0-9]		{ yylval.dval  =  atof(yytext);   return DOUBLE; }
[0-9]+			{ yylval.ival  =  atoi(yytext);   return INT  ;  }
\"[a-zA-Z0-9]+\"	{ yylval.sval  =  strdup(yytext); return STRING; }
[a-zA-Z][a-zA-Z_0-9]*	{ yylval.idval =  strdup(yytext); return ID;     }
[ \t\n]		;
"//".* 	;	
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       
%%

