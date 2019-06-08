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


    typedef struct artistaStruct{
      char* nome;
      GSList* listaAtributos;
      GSList* listaEnsinou;
      GSList* listaAprendeu;
      GSList* listaColaborou;
    } *ArtistaStruct;

    GHashTable* artistasEncontrados = NULL;
    GSList* artistasEsperados = NULL;


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

        asprintf(&fileName, "Artista %s.html", title);

        FILE* fd = fopen(fileName,"w");

        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(title, 1, strlen(title), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        fwrite(body, 1, strlen(body), fd);

        GSList* temp;
        char * href;
        char* outraEntidade;
        if(listaEnsinou != NULL){
          temp = listaEnsinou;
          fwrite("<h2>Ensinou:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("%s -> %s [label=\"ensinou\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }
        if(listaAprendeu != NULL){
          temp = listaAprendeu;
          fwrite("<h2>Aprendeu com:</h2>\n",1,23, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("%s -> %s [label=\"aprendeu com\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          }
        }
        if(listaColaborou != NULL){
          temp = listaColaborou;
          fwrite("<h2>Colaborou com:</h2>\n",1,24, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("%s -> %s [label=\"colaborou\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          }    
        }

        fwrite("</body>\n</html>" , 1 , 15, fd );
        }

    void writeDotArtista(char* nome){
        printf("%s [URL=\"file:Artista %s.html\"]\n", nome, nome);
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
                                                                                    gboolean naoExistia = g_hash_table_insert(artistasEncontrados, $2, $2);
																			        if(naoExistia == FALSE){
                                                                                        char * mensagemErro;
                                                                                        asprintf(&mensagemErro, "Artista %s repetido\n", $2);
                                                                                        yyerror(mensagemErro);
                                                                                    }
                                                                                    ArtistaStruct ats = malloc(sizeof(struct artistaStruct));
                                                                                    ats->nome = $2;
                                                                                    ats->listaAtributos = listaAtributos;
                                                                                    ats->listaEnsinou = listaEnsinou;	
                                                                                    ats->listaAprendeu = listaAprendeu;   
                                                                                    ats->listaColaborou = listaColaborou;   	 

                                                                                    writeDotArtista($2);
                                                                                  	writeHtml($2, $4);
                                                                                  //	writeRelacoes($2);
                                                                                    listaAtributos = NULL;
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
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, listaRelacoesTemp);
																				listaEnsinou = g_slist_concat(listaEnsinou, listaRelacoesTemp);
																				listaRelacoesTemp = NULL;
                                                                            }
        | APRENDEU '=' '{' ListaEntidades '}'                               {	
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, listaRelacoesTemp);
																				listaAprendeu = g_slist_concat(listaAprendeu, listaRelacoesTemp);
																				listaRelacoesTemp = NULL;
                                                                            }
        | COLABOROU '=' '{' ListaEntidades '}'                              {	
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, listaRelacoesTemp);
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
    printf("ERRO: %s \n", s);
    exit(1);
}

void writeDotBeginning() {
  printf("/*\n* @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph g {\n");
}


void testeArtistasEsperados(){
    GSList* temp = artistasEsperados;
    while(temp != NULL){
    char* esperado = (char*)temp->data;
    gpointer res = g_hash_table_lookup (artistasEncontrados,esperado);
    if(res == NULL){
        char * mensagemErro;
        asprintf(&mensagemErro, "Esperado encontrar artista %s\n", esperado);
        yyerror(mensagemErro);
    }
    temp = temp->next;
    }     
}



int main() {
    artistasEncontrados = g_hash_table_new(g_str_hash,g_str_equal);
    writeDotBeginning();
    yyparse();
    printf("}");
    testeArtistasEsperados();
    return 0;
}















