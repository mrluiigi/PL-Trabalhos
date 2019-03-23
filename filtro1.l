%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* auxQ;

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
											printf("InicioPage\n");
											BEGIN PAGE;}

								
<PAGE>"Author:"[^\n]+					{	
											yytext[yyleng-1] = '\0';
											nome = malloc(strlen(yytext-7)+1);
											strcpy(nome, yytext+7);
										}


<PAGE>\*" "*"'"*"&quot;"				{	
											printf("InicioQuote\n");
											BEGIN QUOT;
										}


<PAGE><\/page>							{	
											printf("FimPage\n");
											QuotesAuthor* qa = (QuotesAuthor*)malloc(sizeof(QuotesAuthor));
											qa->autor = nome;
											qa->citacoes = auxQ;
											lista = g_slist_append(lista, qa);
											qa = NULL;

											QuotesAuthor* teste = (QuotesAuthor*)malloc(sizeof(QuotesAuthor));
											teste = lista->data;
											

											GSList* quotes = malloc(sizeof(teste->citacoes));
											quotes = teste->citacoes;
											while(quotes != NULL){
												printf("quotes: %s\n", (char*)quotes->data);
												printf("autor: %s\n", teste->autor);
												quotes = quotes->next;
											}
											printf("123\n");
											BEGIN INITIAL;
										}

<QUOT>"&quot;"							{
											//printf("FimQuote\n %s\n", quote);
											auxQ = g_slist_append (auxQ, quote);
											quote = malloc(10000);
											BEGIN PAGE;
										}
										
<QUOT>[|]								{printf(" ");}

<QUOT>"["|"]"|"'''"		 				{;}

<QUOT>.|\n								{ 
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
	quote = malloc(10000);
	lista = NULL;
	auxQ = NULL;
	yylex();
	//showList();
	return 0;
}