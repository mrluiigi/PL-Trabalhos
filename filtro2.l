%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

//INDICAR LISTA ONDE SE VAI POR OS PROVERBIOS
GSList* listaProverbios;

gchar* proverbio;


%}

%x PAGE
%x PROVERBIO

%%

"<title>Provérbios".+"</title>"					{
													yytext[yyleng-8] = '\0';
													printf("%s\n", yytext+7);
													BEGIN PAGE;
												}


<PAGE><\/page>									{										
													while(listaProverbios != NULL){
														printf("Provérbio: %s\n", (gchar*)listaProverbios->data);
														listaProverbios = listaProverbios->next;
													}
														
													BEGIN INITIAL;
												}

<PAGE>\*" "+"[http://"|"* Ver também"			{;}
<PAGE>"* Veja também:"							{;}		

<PAGE>^\*+" "*"'"*"&quot;"						{
													BEGIN PROVERBIO;
												}

<PAGE>^\*" "+"'"*|":'''&quot;"|^"'''"			{
													BEGIN PROVERBIO;
												}

<PAGE>^"'''"									{
													BEGIN PROVERBIO;
												}

<PAGE>^"*''"									{
													BEGIN PROVERBIO;
												}												


<PROVERBIO>.									{
													proverbio = g_strconcat(proverbio, yytext, NULL);
												}


<PROVERBIO>"["+|"]"+							{;}
<PROVERBIO>"'"+									{;}
<PROVERBIO>" "*"'"*"&quot;"						{;}
<PROVERBIO>"&lt".*"&gt;".*"&lt;".*"&gt;"		{;}
<PROVERBIO>"&lt".*"&gt;"						{;}


<PROVERBIO>\n									{
													listaProverbios = g_slist_append (listaProverbios, proverbio);
													proverbio = malloc(10000);
													BEGIN PAGE;
												}								

<*>.|\n											{;}

%%

//Será preciso adicionar o caso de ter de ser dentro de um <page> para inicial STR?


int yywrap(){
	return 1;
}

int main(){
	proverbio = malloc(100000);
	listaProverbios = NULL;
	yylex();
	return 0;
}