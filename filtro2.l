%{
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>

//INDICAR LISTA ONDE SE VAI POR OS PROVERBIOS

%}

%x STR

%%

"<title>Provérbios".+"</title>"	{
									yytext[yyleng-8] = '\0';
									printf("%s\n", yytext+7);
									BEGIN STR;
								}
<STR>"</page"					{	BEGIN INITIAL;}
<STR>[*].+[\n]					{
									yytext[yyleng-2] = '\0';
									printf("%s\n", yytext+2);	
}

<*>.|\n							{;}

%%

//Será preciso adicionar o caso de ter de ser dentro de um <page> para inicial STR?


int yywrap(){
	return 1;
}

int main(){
	yylex();
	return 0;
}