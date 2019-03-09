%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

GSList* lista = NULL;
%}

%x PAGE

%%
"<page>"								{BEGIN PAGE;}

<PAGE></page>							{BEGIN INITIAL;}
<PAGE>"Author:"[^\n]+					{	
											yytext[yyleng-1] = '\0';
											printf("%s\n", yytext+7);
										}
<PAGE>[&]"quot"[;].+[&]"quot"[;]		{
											yytext[yyleng-6] = '\0';
											printf("%s\n", yytext+6);
											lista = g_slist_prepend(lista, yytext);

										}
<*>.|\next								{;}

%%

//ACABAR PARTE DE INSERIR NA LISTA

void showList(){
	GSList *l;
	for(l = lista; l; l = l->next){
		char *s = (char *) l->data;
		printf("%s\n", s);
	}
}


int yywrap(){
	return 1;
}

int main(){
	yylex();
	//showList();
	return 0;
}