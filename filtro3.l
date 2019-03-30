%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

//INDICAR LISTA ONDE SE VAI POR OS PROVERBIOS
GSList* listaAdulterados;

char str[1];
char* original;
char* anterior;
char* adulterado;


%}

%x 
%x 

%%

"<title>Provérbios".+"</title>"	{
									yytext[yyleng-8] = '\0';
									printf("%s\n", yytext+7);
									BEGIN PAGE;
								}


<PAGE><\/page>					{										
									
								}
				

<PAGE>\*+" "*"'"*"&quot;"		{
									
								}


<PROVERBIO>.					{
									
								}


<PROVERBIO>"["+|"]"+			{;}
<PROVERBIO>"'"+					{;}
<PROVERBIO>" "*"'"*"&quot;"		{;}


<PROVERBIO>\n					{
									
								}								

<*>.|\n							{;}

%%



int yywrap(){
	return 1;
}

int main(){
	proverbio = malloc(100000);
	listaProverbios = NULL;
	yylex();
	return 0;
}