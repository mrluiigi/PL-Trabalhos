%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* auxQ;
char* str = "";
char* nome = "";

typedef struct{
	char* autor;
	GSList* citacoes;
} QuotesAuthor;

%}

%x PAGE
%x QUOT

%%
"<page>"								{	BEGIN PAGE;}

<PAGE><\/page>							{	
											QuotesAuthor* qa = (QuotesAuthor*)malloc(sizeof(QuotesAuthor));
											qa->autor = nome;
											qa->citacoes = auxQ;
											lista = g_slist_append(lista, qa);
											qa = NULL;
											BEGIN INITIAL;
										}
								
<PAGE>"Author:"[^\n]+					{	
											yytext[yyleng-1] = '\0';
											nome = malloc(strlen(yytext-7)+1);
											strcpy(nome, yytext+7);
										}

<PAGE>"&quot;"							{BEGIN QUOT;}
<QUOT>"&quot;"							{BEGIN PAGE;}

<QUOT>[|]								{printf(" ");}
<QUOT>"["|"]"|"'''"		 				{;}
<QUOT>.|\n 								{ECHO;}



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
	lista = NULL;
	auxQ = NULL;
	yylex();
	//showList();
	return 0;
}