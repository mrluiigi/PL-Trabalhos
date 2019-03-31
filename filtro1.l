%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* auxQuote;

int numPageAutor;
int quotesSemAutor;

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
											auxQuote = NULL;
											BEGIN PAGE;}

<PAGE>"|"" "*"Nome"" "*"="" "*			{	
											nome = malloc(100);
											BEGIN AUTOR;
										}
										
<AUTOR>[|\n]							{	BEGIN PAGE;}

<AUTOR>"&lt;"[^&]*"&gt;"						{;}

<AUTOR>"["|"]"|"'"*|\**					{;}

<AUTOR>.								{	
											nome = g_strconcat(nome, yytext, NULL);
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
												numPageAutor += 1;
												printf("Autor: %s\n", qa->autor);
												while(auxQuote != NULL){
													printf("	Quote: %s\n", (gchar*)auxQuote->data);
													auxQuote = auxQuote->next;
												}
											}
											else{
												quotesSemAutor += 1;
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

<QUOT>[|]								{	quote = g_strconcat(quote," ", NULL);}

<QUOT>"["|"]"|"'"*|\**					{;}

<QUOT>.									{
											quote = g_strconcat(quote, yytext, NULL); 
										}

<*>.|\n									{;}

%%

void showStatistics(){
	GSList *l, *t;
	for(l = lista; l; l = l->next){
		QuotesAuthor *q = (QuotesAuthor*) l->data;
		if(strcmp(q->autor, "") != 0)
			printf("Autor %s tem %d citações\n", q->autor, g_slist_length(q->citacoes));
	}
}

int yywrap(){
	return 1;
}

int sortLista(gconstpointer a, gconstpointer b) {
	QuotesAuthor* q1 = (QuotesAuthor*) a;
	QuotesAuthor* q2 = (QuotesAuthor*) b;
	return strcmp(q1->autor, q2->autor);

}

int main(){
	quote = malloc(100);
	lista = NULL;
	auxQuote = NULL;
	numPageAutor = 0;
	quotesSemAutor = 0;
	yylex();
	lista = g_slist_sort(lista, sortLista);

	printf("\n---------Estatísticas---------\n");
	showStatistics();
	printf("\nNúmero de páginas de autor: %d\n", numPageAutor);
	printf("\nNúmero de páginas não autor: %d\n", quotesSemAutor);
	return 0;
}