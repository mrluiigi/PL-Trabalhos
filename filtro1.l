%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* auxQuote;

gchar str[1];
gchar* nome = "";
gchar* quote = "";

typedef struct{
	gchar* autor;
	GSList* citacoes;
} QuotesAuthor;

%}

%x PAGE
%x QUOT
%x AUTOR

%%
"<page>"								{
											BEGIN PAGE;}

<PAGE>"| Nome"" "*"=" 					{	
											BEGIN AUTOR;
										}
										
<AUTOR>\n|"|"							{	BEGIN PAGE;}
<AUTOR>[^|\n]*							{	
											nome = malloc(yyleng+1);
											strcpy(nome, yytext);
										}

<PAGE>^\*" "*"'"*"&quot;"				{	
											BEGIN QUOT;
										}

<PAGE><\/page>							{	
											QuotesAuthor* qa = (QuotesAuthor*)malloc(sizeof(QuotesAuthor));
											
											qa->autor = nome;
											nome = "";
											qa->citacoes = auxQuote;
											lista = g_slist_append(lista, qa);

											if(qa->autor != ""){
												printf("Autor: %s\n", qa->autor);
												while(auxQuote != NULL){
													printf("	Quote: %s\n", (gchar*)auxQuote->data);
													auxQuote = auxQuote->next;
												}
											}
											else{
												while(auxQuote != NULL){
													printf("Quote: %s\n", (gchar*)auxQuote->data);
													auxQuote = auxQuote->next;
												}
											}

											BEGIN INITIAL;
										}

<QUOT>"&quot;"|\n|"[https://"			{
											auxQuote = g_slist_append (auxQuote, quote);
											quote = malloc(100);
											BEGIN PAGE;
										}

<QUOT>"&lt".*"&gt;".*"&lt;".*"&gt;"		{;}

<QUOT>[|]								{quote = g_strconcat(quote," ", NULL);}

<QUOT>"["|"]"|"'"*|\**					{;}

<QUOT>.									{
											quote = g_strconcat(quote, yytext, NULL); 
										}

<*>.|\n									{;}

%%

int yywrap(){
	return 1;
}

int main(){
	quote = malloc(100);
	lista = NULL;
	auxQuote = NULL;
	yylex();
	return 0;
}