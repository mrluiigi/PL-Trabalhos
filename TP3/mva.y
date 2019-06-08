%{
  #define _GNU_SOURCE
  #include <stdio.h>
  #include <ctype.h>
  #include <string.h>
  #include <glib.h>
  #include "lex.yy.c"
  int yylex();
  int yyerror(char *s);

 typedef struct atributoStruct{
    char* atribNome;
    char* atribValor;
 } *AtributoStruct;

/*
 typedef struct artistaStruct{
    char* id;
    GSList* listaAtributos;
 } *ArtistaStruct;

 GSList* listaArtistas;
*/
 GSList* listaAtributos;

 AtributoStruct ats;

void writeHtml(char* title, char* body) {
	char* fileName;

	asprintf(&fileName, "%s.html", title);

	FILE* fd = fopen(fileName,"w");
	
	fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
	fwrite(title, 1, strlen(title), fd);
	fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
	fwrite(body, 1, strlen(body), fd);
	fwrite("</body>\n</html>" , 1 , 15, fd );
}
%}

%union { char* VARNAME; int CONSTINT; char* string;}

%token ART

%token <string> VALOR
%token <string> PALAVRA

%type <string> Atributo Atributos ArtistaInfo

%%

MvA : Entidades                                                            

Entidades : Entidades Entidade
          | Entidade
          ;



Entidade : Artista                               
         ;

Artista : ART VALOR '{' ArtistaInfo '}'                                        	{  	
																					
                                                                                  	printf("%s\n", $2);
                                                                                  	writeHtml($2, $4);
                                                                                  	
                                                                               	}
        ;

ArtistaInfo : Atributos                                                       	{
																					asprintf(&$$, "<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>%s</table>", $1);
																					//printf("Chega bem?: %s\n", $1);
																				}
            ;

Atributos : Atributos Atributo                                                 	{
																					asprintf(&$$, "%s\n%s", $1, $2);
																					//printf("Atributos: %s Atributo: %s\n", $1, $2);
																					listaAtributos = g_slist_append(listaAtributos, ats);
																				}
          | Atributo                                                           	{
          																			asprintf(&$$, "%s", $1);
          																			//printf("Primeiro%s", $1);
          																			listaAtributos = g_slist_append(listaAtributos, ats);
          																		}
          ;

Atributo : PALAVRA '=' VALOR                                                  {	
																				asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
																				ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                                //printf("%s\n", $1);
                                                                            //  asprintf(ats->atribNome, "%s\n%s\n", $1, $2);
                                                                              }
         ;

%%

int yyerror (char *s) {
    printf("ERRO SINTATICO %s \n", s);
    return 1;
}





int main() {
    printf("/*\n * @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph g {\n");
    yyparse();
    return 0;
}















