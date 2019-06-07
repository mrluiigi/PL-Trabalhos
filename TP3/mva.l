%option noyywrap

%{
	#include "y.tab.h"
	
%}


%%

ARTISTA 	    {return ART;}
[{}="]			{return yytext[0];}
\"[^"]*\"	    {	yytext[yyleng -	1] = '\0';
					yylval.string = strdup(yytext+1);
	           		return VALOR;
	        	}

[a-zA-Z]+		{yylval.string = strdup(yytext);
	             return PALAVRA;}

%%


