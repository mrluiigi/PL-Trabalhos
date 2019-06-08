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

 GSList* listaRelacoesTemp = NULL;

 GSList* listaEnsinou = NULL;
 GSList* listaAprendeu = NULL;
 GSList* listaColaborou = NULL;

 //char* tabelaAtributos;
 //char* relacao;

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

void writeDotArtista(char* nome){
  printf("%s [URL=\"file:%s.html\"]\n", nome, nome);
}

void writeRelacoes(){
	if(listaEnsinou != NULL){
		printf("%s\n", (char*)listaEnsinou->data);
	}
	if(listaAprendeu != NULL){
		printf("%s\n", (char*)listaAprendeu->data);
	}
	if(listaColaborou != NULL){
		printf("%s\n", (char*)listaColaborou->data);
	}
}

%}

%union { char* VARNAME; int CONSTINT; char* string;}

%token ART

%token ENSINOU
%token APRENDEU
%token COLABOROU

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
																					writeDotArtista($2);
                                                                                  	writeHtml($2, $4);
                                                                                  	writeRelacoes();
                                                                                  	listaEnsinou = NULL;
                                                                                  	listaAprendeu = NULL;
                                                                                  	listaColaborou = NULL;                                                                                  	
                                                                               	}
        ;

ArtistaInfo : Atributos Relacoes                                       			{
																					asprintf(&$$, "<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>%s</table>", $1);
																					//printf("Chega bem?: %s\n", $1);
																				}
            ;

Atributos : Atributos Atributo   	                                         	{
																					asprintf(&$$, "%s\n%s", $1, $2);
																					//printf("Atributos: %s Atributo: %s\n", $1, $2);
																					listaAtributos = g_slist_append(listaAtributos, ats);
																				}
          | %empty                                                           	{
          																			$$ = "";
          																			//asprintf(&$$, "%s", $1);
          																			//printf("Primeiro%s", $1);
          																			//listaAtributos = g_slist_append(listaAtributos, ats);
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

Relacoes : Relacoes Relacao   	                                         	{
																				
																			}
      	 | %empty                                                           {
      																			
      																		}
         ;

Relacao : ENSINOU '=' '{' ListaEntidades '}'                                {	
																				listaEnsinou = g_slist_concat(listaEnsinou, listaRelacoesTemp);
																				listaRelacoesTemp = NULL;
                                                                            }
        | APRENDEU '=' '{' ListaEntidades '}'                               {	
																				listaAprendeu = g_slist_concat(listaAprendeu, listaRelacoesTemp);
																				listaRelacoesTemp = NULL;
                                                                            }
        | COLABOROU '=' '{' ListaEntidades '}'                              {	
        																		listaColaborou = g_slist_concat(listaColaborou, listaRelacoesTemp);
        																		listaRelacoesTemp = NULL;
        																	}
        ;

ListaEntidades : ListaEntidades ';' VALOR 									{
																				listaRelacoesTemp = g_slist_append(listaRelacoesTemp, $3);

																			}
			   | VALOR 														{
			   																	listaRelacoesTemp = g_slist_append(listaRelacoesTemp, $1);

			   																}
			   ;


%%

int yyerror (char *s) {
    printf("ERRO SINTATICO %s \n", s);
    return 1;
}

void writeDotBeginning() {
  printf("/*\n* @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph g {\n");
}




int main() {
    writeDotBeginning();
    yyparse();
    printf("}");
    return 0;
}















