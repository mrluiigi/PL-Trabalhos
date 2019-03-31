%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* auxQuote;

gchar str[1];
gchar* nome = "";

gchar* imprime = "";

gchar* quote;

typedef struct{
	gchar* autor;
	GSList* citacoes;
} QuotesAuthor;

%}

%x PAGE
%x QUOT

%%
"<page>"								{
											//printf("InicioPage\n");
											BEGIN PAGE;}

								
<PAGE>"Author:"[^\n|"}}"]+				{	
											yytext[yyleng] = '\0';
											nome = malloc(strlen(yytext)-7+1);
											strcpy(nome, yytext+7);
										}


<PAGE>^\*" "*"'"*"&quot;"				{	
											//printf("InicioQuote\n");
											BEGIN QUOT;
										}


<PAGE><\/page>							{	
											//printf("antes\n");
											QuotesAuthor* qa = (QuotesAuthor*)malloc(sizeof(QuotesAuthor));

											if(auxQuote != NULL){
												//printf("FimPage\n");

												qa->autor = nome;
												nome = "";
												qa->citacoes = auxQuote;
												lista = g_slist_append(lista, qa);
																				
												while(auxQuote != NULL){
													printf("quotes: %s\n", (gchar*)auxQuote->data);
													if(qa->autor != ""){
														printf("autor: %s\n", qa->autor);
													}
													auxQuote = auxQuote->next;
												}
												
											}
											//printf("depois\n");

											//printf("123\n");

											BEGIN INITIAL;
										}

<QUOT>"&quot;"|\n|"[https://"			{
											//printf("FimQuote\n %s\n", quote);
											auxQuote = g_slist_append (auxQuote, quote);
											//printf("antes\n");
											quote = malloc(100);
											//printf("depois\n");
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


void showList(){
	GSList *l, *t;
	for(l = lista; l; l = l->next){
		QuotesAuthor *q = (QuotesAuthor*) l->data;
		printf("AUTOR: %s\nCITAÇÕES: \n", q->autor);
		for(t = q->citacoes; t; t = t->next){
			printf("-->%s\n", (gchar*) t->data);
		}
	}
}


int yywrap(){
	return 1;
}

int main(){
	quote = malloc(100);
	lista = NULL;
	auxQuote = NULL;
	yylex();
	//showList();
	return 0;
}