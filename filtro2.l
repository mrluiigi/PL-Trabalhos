%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista;
GSList* listaProverbios;

gchar* title;
gchar* proverbio;

typedef struct{
	gchar* title;
	GSList* proverbios;
} Prov;

%}

%x PAGE
%x PROVERBIO

%%

"<title>Provérbios".+"</title>"					{
													title = malloc(1000);
													yytext[yyleng-8] = '\0';
													title = g_strconcat(title, yytext+7, NULL);
													listaProverbios = NULL;
													
													BEGIN PAGE;
												}


<PAGE><\/page>									{				
													Prov* p = (Prov*)malloc(sizeof(Prov));
													p->title = title;
													p->proverbios = listaProverbios;
													lista = g_slist_append(lista, p);

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
													proverbio = malloc(100);
													BEGIN PAGE;
												}								

<*>.|\n											{;}

%%

void showList(){
	GSList *l, *t;
	for(l = lista; l; l = l->next){
		Prov *p = (Prov*) l->data;
		printf("%s:\n", p->title);
		for(t = p->proverbios; t; t = t->next){
			printf("	%s\n", (char*) t->data);
		}
	}
}

void showEstatistics(){
	GSList *l, *t;
	for(l = lista; l; l = l->next){
		Prov *p = (Prov*) l->data;
		printf("%s contém %d provérbios\n", p->title, g_slist_length(p->proverbios));
	}
}

int yywrap(){
	return 1;
}

int main(){
	proverbio = malloc(100);
	listaProverbios = NULL;
	yylex();
	showList();

	printf("\n---------Estatísticas---------\n");
	showEstatistics();
	return 0;
}