%option noyywrap

%{
	#include "y.tab.h"
%}


%%

ARTISTA 	    	{return ART;}

Nome" "Completo		{yylval.string = strdup(yytext); return ATRIBUTOARTISTA;}
Pais				{yylval.string = strdup(yytext); return ATRIBUTOARTISTA;}
Seculo				{yylval.string = strdup(yytext); return ATRIBUTOARTISTA;}
Periodo				{yylval.string = strdup(yytext); return ATRIBUTOARTISTA;}


OBRA				{return OBRAKEYWORD;}

Nome				{yylval.string = strdup(yytext); return ATRIBUTOOBRA;}
Ano					{yylval.string = strdup(yytext); return ATRIBUTOOBRA;}
Tecnica				{yylval.string = strdup(yytext); return ATRIBUTOOBRA;}
Valor				{yylval.string = strdup(yytext); return ATRIBUTOOBRA;}
Local" "Exposicao 	{yylval.string = strdup(yytext); return ATRIBUTOOBRA;}


EVENTO				{return EVENTOKEYWORD;}

Tipo				{yylval.string = strdup(yytext); return ATRIBUTOEVENTO;}
Localizacao			{yylval.string = strdup(yytext); return ATRIBUTOEVENTO;}
Data				{yylval.string = strdup(yytext); return ATRIBUTOEVENTO;}



ensinouCom			{return ENSINOU;}
aprendeuCom			{return APRENDEU;}
colaborouCom		{return COLABOROU;}

produziu			{return PRODUZIU;}
participou			{return PARTICIPOU;}


[{}=";]				{return yytext[0];}
\"[^"]*\"	    	{	yytext[yyleng -	1] = '\0';
						yylval.string = strdup(yytext+1);
	           			return VALOR;
	        		}


%%


