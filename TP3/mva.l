%option noyywrap

%{
	#include "y.tab.h"
	
%}

%%

ARTISTA 	    {return ART;}
[{}=]			{return yytext[0];}
\"[^"]*\"	    {return VALOR;}
[a-zA-Z]+		{return PALAVRA;}

%%


