%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* auxQuote;

char str[1];
char* nome = "";

char* imprime = "";

char* quote;

typedef struct{
	char* autor;
	GSList* citacoes;
} QuotesAuthor;

%}

%x PAGE
%x QUOT

%%
"<page>"								{
											//printf("InicioPage\n");
											BEGIN PAGE;}

								
<PAGE>"Author:"[^\n]+					{	
											yytext[yyleng] = '\0';
											nome = malloc(strlen(yytext-7)+1);
											strcpy(nome, yytext+7);
										}


<PAGE>\*" "*"'"*"&quot;"				{	
											//printf("InicioQuote\n");
											BEGIN QUOT;
										}


<PAGE><\/page>							{	
											QuotesAuthor* qa = (QuotesAuthor*)malloc(sizeof(QuotesAuthor));

											if(auxQuote != NULL){
												//printf("FimPage\n");

												qa->autor = nome;
												nome = "";
												qa->citacoes = auxQuote;
												lista = g_slist_append(lista, qa);
																				
												while(auxQuote != NULL){
													printf("quotes: %s\n", (char*)auxQuote->data);
													if(qa->autor != ""){
														printf("autor: %s\n", qa->autor);
													}
													auxQuote = auxQuote->next;
												}
												
											}
											//printf("123\n");

											BEGIN INITIAL;
										}

<QUOT>"&quot;"|\n						{
											//printf("FimQuote\n %s\n", quote);
											auxQuote = g_slist_append (auxQuote, quote);
											quote = malloc(10000);
											BEGIN PAGE;
										}
										
<QUOT>[|]								{printf(" ");}

<QUOT>"["|"]"|"'''"		 				{;}

<QUOT>.									{
											strcpy(str, yytext);
											strcat(quote, str); 
										}

<*>.|\n									{;}

%%


void showList(){
	GSList *l, *t;
	for(l = lista; l; l = l->next){
		QuotesAuthor *q = (QuotesAuthor*) l->data;
		printf("AUTOR: %s\nCITAÇÕES: \n", q->autor);
		for(t = q->citacoes; t; t = t->next){
			printf("-->%s\n", (char*) t->data);
		}
	}
}


int yywrap(){
	return 1;
}

int main(){
	quote = malloc(100000);
	lista = NULL;
	auxQuote = NULL;
	yylex();
	//showList();
	return 0;
}