%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* listaAdulteracoes;
GSList* auxAdulterado;

#define N 10
gchar* proverbio;
gchar* adulterado;

int conta[N];

typedef struct{
	gchar* original;
	GSList* adulterados;
} Adulteracao;

%}

%x PAGE
%x ADULTERACAO
%x QUOT
%x PROVERBIO

%%

"<title>Provérbios".+"</title>"	{
									BEGIN PAGE;
								}

<PAGE><\/page>					{
									BEGIN INITIAL;
								}

<PAGE>^"*"" "*"&quot;"			{
									proverbio = malloc(100);
									BEGIN PROVERBIO;
								}

<PAGE>"'''Adulteração:'''"		{
									BEGIN ADULTERACAO;
								}

<PROVERBIO>"&quot;"|\n			{	
									BEGIN PAGE;
								}

<PROVERBIO>[^&]*				{
									proverbio = g_strconcat(proverbio, yytext, NULL);
								}

<ADULTERACAO>^"*"|^"**"			{	
									Adulteracao* ad = (Adulteracao*)malloc(sizeof(Adulteracao));
									ad->original = proverbio;
									ad->adulterados = auxAdulterado;
									
									conta[g_slist_length(auxAdulterado)]++;		//conta o número de adulterados

									listaAdulteracoes = g_slist_append(listaAdulteracoes, ad);
									auxAdulterado = NULL;
									BEGIN PAGE;
								}

<ADULTERACAO>^"***"" "*"&quot;"	{
									adulterado = malloc(100);
									BEGIN QUOT;
								}

<QUOT>"&quot;"|\n				{	
									auxAdulterado = g_slist_append (auxAdulterado, adulterado);
									BEGIN ADULTERACAO;
								}

<QUOT>[^&]* 					{
									adulterado = g_strconcat(adulterado, yytext, NULL);
								}

<*>.|\n							{;}

%%

void showList(){
	GSList *l, *t;
	for(l = listaAdulteracoes; l; l = l->next){
		Adulteracao *q = (Adulteracao*) l->data;
		printf("Original: %s\n", q->original);
		for(t = q->adulterados; t; t = t->next){
			printf("	%s\n", (gchar*) t->data);
		}
	}
}

void printStatistics(){
	for(int i = 1; i < N; i++)
		printf("	Existem %d adulterados para %d originais\n", i, conta[i]);
}

int yywrap(){
	return 1;
}

int main(){
	listaAdulteracoes = NULL;
	auxAdulterado = NULL;
	yylex();
	showList();
	printf("---------------------\nEstatísticas: \n");
	printStatistics();
	return 0;
}