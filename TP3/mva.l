%option noyywrap

%{
	#include "y.tab.h"
%}


%%

ARTISTA 	    	{return ARTISTAKEYWORD;}

Nome" "Completo		{return NOMECOMPLETO;}
Pais				{return PAIS;}
Seculo				{return SECULO;}
Periodo				{return PERIODO;}
Imagem              {return IMAGEM;}


OBRA				{return OBRAKEYWORD;}

Nome				{return NOME;}
Data				{return DATA;}
Tecnica				{return TECNICA;}
Valor				{return VALORMONETARIO;}
Local" "Exposicao 	{return LOCALEXPOSICAO;}


EVENTO				{return EVENTOKEYWORD;}

Tipo				{return TIPO;}
Localizacao			{return LOCALIZACAO;}



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


