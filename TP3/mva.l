%option noyywrap

%{
	#include "y.tab.h"
%}


%%

ARTISTA 	    	{return ARTISTAKEYWORD;}

Nome" "Completo		{yylval.string = strdup(yytext); return NOMECOMPLETO;}
Pais				{yylval.string = strdup(yytext); return PAIS;}
Seculo				{yylval.string = strdup(yytext); return SECULO;}
Periodo				{yylval.string = strdup(yytext); return PERIODO;}
Imagem              {return IMAGEM;}


OBRA				{return OBRAKEYWORD;}

Nome				{yylval.string = strdup(yytext); return NOME;}
Data				{yylval.string = strdup(yytext); return DATA;}
Tecnica				{yylval.string = strdup(yytext); return TECNICA;}
Valor				{yylval.string = strdup(yytext); return VALORMONETARIO;}
Local" "Exposicao 	{yylval.string = strdup(yytext); return LOCALEXPOSICAO;}


EVENTO				{return EVENTOKEYWORD;}

Tipo				{yylval.string = strdup(yytext); return TIPO;}
Localizacao			{yylval.string = strdup(yytext); return LOCALIZACAO;}



Ensinou 			{return ENSINOU;}
Aprendeu" "com		{return APRENDEU;}
Colaborou" "com		{return COLABOROU;}

Produziu			{return PRODUZIU;}
Participou			{return PARTICIPOU;}

Exposta" "em 		{return EXPOSTA;}
Expoe				{return EXPOE;}
Produzida" "por 	{return PRODUZIDA;}
Vendida				{return VENDIDA;}
Vendeu				{return VENDEU;}


[{}=";]				{return yytext[0];}
\"[^"]*\"	    	{	yytext[yyleng -	1] = '\0';
						yylval.string = strdup(yytext+1);
	           			return VALOR;
	        		}


%%


