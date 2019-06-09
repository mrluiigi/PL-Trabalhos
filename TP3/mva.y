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
		GSList* listaProduziu;
		GSList* listaParticipou;
    } *ArtistaStruct;

    GHashTable* artistasEncontrados = NULL;
    GSList* artistasEsperados = NULL;

    GHashTable* obrasEncontradas = NULL;
    GSList* obrasEsperadas = NULL;


    GHashTable* eventosEncontrados = NULL;
    GSList* eventosEsperados = NULL;


    GSList* listaAtributos;

    AtributoStruct ats;

    GSList* listaRelacoesTemp = NULL;

    GSList* listaEnsinou = NULL;
    GSList* listaAprendeu = NULL;
    GSList* listaColaborou = NULL;

    GSList* listaProduziu = NULL;
    GSList* listaProduzida = NULL;

    GSList* listaParticipou = NULL;

	GSList* listaExposta = NULL;
	GSList* listaExpoe = NULL;

	



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
            printf("\"%s\" -> \"%s\" [label=\"ensinou\"]\n", title, outraEntidade);
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
            printf("\"%s\" -> \"%s\" [label=\"aprendeu com\"]\n", title, outraEntidade);
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
            printf("\"%s\" -> \"%s\" [label=\"colaborou\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          }    
        }

        if(listaProduziu != NULL){
          temp = listaProduziu;
          fwrite("<h2>Produziu:</h2>\n",1,19, fd);
          while(temp != NULL){
          	outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"produziu\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Obra %s.html\">%s</a>\n", outraEntidade, outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          }    
        }

        if(listaParticipou != NULL){
          temp = listaParticipou;
          fwrite("<h2>Participou:</h2>\n",1,20, fd);
          while(temp != NULL){
          	outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"participou\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Evento %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          }    
        }



        fwrite("</body>\n</html>" , 1 , 15, fd );
    }


    void writeHtmlObra(char* title, char* body) {
        char* fileName;

        asprintf(&fileName, "Obra %s.html", title);

        FILE* fd = fopen(fileName,"w");

        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(title, 1, strlen(title), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        fwrite(body, 1, strlen(body), fd);

        GSList* temp;
        char * href;
        char* outraEntidade;
        if(listaExposta != NULL){
          temp = listaExposta;
          fwrite("<h2>Exposta:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"Exposta em\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Evento %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }
        if(listaProduzida != NULL){
          temp = listaProduzida;
          fwrite("<h2>Produzida:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"Produzida por\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }

        fwrite("</body>\n</html>" , 1 , 15, fd );


    }

    void writeHtmlEvento(char* title, char* body) {
        char* fileName;

        asprintf(&fileName, "Evento %s.html", title);

        FILE* fd = fopen(fileName,"w");

        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(title, 1, strlen(title), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        fwrite(body, 1, strlen(body), fd);

        GSList* temp;
        char * href;
        char* outraEntidade;
        if(listaExpoe != NULL){
          temp = listaExpoe;
          fwrite("<h2>Expoe:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"Expoe\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Obra %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }

        fwrite("</body>\n</html>" , 1 , 15, fd );


    }


    void writeDotArtista(char* nome){
        printf("\"%s\" [URL=\"file:Artista %s.html\" style=filled, color=\".3 .4 .8\"]\n", nome, nome);
    }

    void writeDotObra(char* nome){
        printf("\"%s\" [URL=\"file:Obra %s.html\" style=filled, color=\"1.0 .6 1.0\"]\n", nome, nome);
    }

    void writeDotEvento(char* nome){
        printf("\"%s\" [URL=\"file:Evento %s.html\" style=filled, color=\".5 .5 1.0\"]\n", nome, nome);
    }


%}

%union { char* VARNAME; int CONSTINT; char* string;}

%token ART
%token OBRAKEYWORD
%token EVENTOKEYWORD


%token ENSINOU
%token APRENDEU
%token COLABOROU

%token PRODUZIU
%token PARTICIPOU

%token EXPOSTA

%token EXPOE

%token PRODUZIDA

%token NOMECOMPLETO
%token PAIS
%token SECULO
%token PERIODO


%token NOME
%token DATA
%token TECNICA
%token VALORMONETARIO
%token LOCALEXPOSICAO
%token TIPO
%token LOCALIZACAO





%token <string> VALOR
%token <string> ATRIBUTOOBRA
%token <string> ATRIBUTOEVENTO

%type <string> Atributo Atributos ArtistaInfo ObraInfo AtributoObra AtributosObra EventoInfo AtributosEvento AtributoEvento TipoAtributoArtista TipoAtributoObra TipoAtributoEvento

%%

MvA : Entidades                                                            

Entidades : Entidades Entidade
          | Entidade
          ;



Entidade : Artista 
		 | Obra   
		 | Evento                           
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
                                                                                    ats->listaProduziu = listaProduziu;
                                                                                    ats->listaParticipou = listaParticipou;


                                                                                    writeDotArtista($2);
                                                                                  	writeHtml($2, $4);

                                                                                    listaAtributos = NULL;
                                                                                  	listaEnsinou = NULL;
                                                                                  	listaAprendeu = NULL;
                                                                                  	listaColaborou = NULL;  
                                                                                  	listaProduziu = NULL;
                                                                                  	listaParticipou = NULL;                                                                                	
                                                                               	}
        ;

ArtistaInfo : Atributos Relacoes                                       			{
																					asprintf(&$$, "<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>%s</table>", $1);
																				}
            ;

Atributos : Atributos Atributo   	                                         	{
																					asprintf(&$$, "%s\n%s", $1, $2);
																					listaAtributos = g_slist_append(listaAtributos, ats);
																				}
          | %empty                                                           	{
          																			$$ = "";
          																		}
          ;

Atributo : TipoAtributoArtista'=' VALOR                                         {	
																				asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
																				ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                              }
         ;


TipoAtributoArtista : NOMECOMPLETO                                              {$$ = "Nome completo";}
                    | PAIS                                                      {$$ = "País";}
                    | SECULO                                                    {$$ = "Século";}
                    | PERIODO                                                   {$$ = "Período";}                                                              
                    ;


Obra : OBRAKEYWORD VALOR '{' ObraInfo '}'                                   {  	
                                                                                gboolean naoExistia = g_hash_table_insert(obrasEncontradas, $2, $2);
																			    if(naoExistia == FALSE){
                                                                                   	char * mensagemErro;
                                                                                    asprintf(&mensagemErro, "Obra %s repetida\n", $2);
                                                                                    yyerror(mensagemErro);
                                                                                } 	 

                                                                                writeDotObra($2);
                                                                              	writeHtmlObra($2, $4);
                                                                              	listaExposta = NULL;
                                                                              	listaProduzida = NULL;
                                                                            }
        ;




ObraInfo : AtributosObra RelacoesObra                                      {
																				asprintf(&$$, "<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>%s</table>", $1);
																			}
            ;

AtributosObra : AtributosObra AtributoObra   	                           	{
																				asprintf(&$$, "%s\n%s", $1, $2);
																				listaAtributos = g_slist_append(listaAtributos, ats);
																			}
          		| %empty                                                   	{
          																			$$ = "";
          																	}
          ;

AtributoObra : TipoAtributoObra '=' VALOR                                   {	
																				asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
																				ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                            }
         ;


TipoAtributoObra : NOME                                                         {$$ = "Nome";}
                 | DATA                                                         {$$ = "Data";}
                 | TECNICA                                                      {$$ = "Técnica";}
                 | VALORMONETARIO                                               {$$ = "Valor";}                                                              
                 | LOCALEXPOSICAO                                               {$$ = "Local de exposição";}   
                 ;




Evento : EVENTOKEYWORD VALOR '{' EventoInfo '}'                             {  	
                                                                                gboolean naoExistia = g_hash_table_insert(eventosEncontrados, $2, $2);
																			    if(naoExistia == FALSE){
                                                                                   	char * mensagemErro;
                                                                                    asprintf(&mensagemErro, "Obra %s repetida\n", $2);
                                                                                    yyerror(mensagemErro);
                                                                                }	 

                                                                                writeDotEvento($2);
                                                                              	writeHtmlEvento($2, $4);
                                                                              	listaExpoe = NULL;                                                                             	
                                                                            }
        ;




EventoInfo : AtributosEvento RelacoesEvento                                 {
																				asprintf(&$$, "<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>%s</table>", $1);
																			}
            ;

AtributosEvento : AtributosEvento AtributoEvento   	                        {
																				asprintf(&$$, "%s\n%s", $1, $2);
																				listaAtributos = g_slist_append(listaAtributos, ats);
																			}
          		| %empty                                                   	{
          																			$$ = "";
          																	}
          ;

AtributoEvento : TipoAtributoEvento '=' VALOR                                     {	
																				asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
																				ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                              }
         ;


TipoAtributoEvento : TIPO                                                      {$$ = "Tipo";}
                   | LOCALIZACAO                                               {$$ = "Localização";}
                   | DATA                                                      {$$ = "Data";} 
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
        | PRODUZIU '=' '{' ListaEntidades '}' 								{
        																		listaProduziu = g_slist_concat(listaProduziu, listaRelacoesTemp);
        																		listaRelacoesTemp = NULL;
        																	}
        | PARTICIPOU '=' '{' ListaEntidades '}' 							{
        																		listaParticipou = g_slist_concat(listaParticipou, listaRelacoesTemp);
        																		listaRelacoesTemp = NULL;
        																	}
        ;

RelacoesObra : RelacoesObra RelacaoObra   	                                {
																				
																			}
      	 	 | %empty                                                       {
      																			
      																		}
         	 ;

RelacaoObra : EXPOSTA '=' '{' ListaEntidades '}'                            {	
                                                                                eventosEsperados = g_slist_concat(eventosEsperados, listaRelacoesTemp);
																				listaExposta = g_slist_concat(listaExposta, listaRelacoesTemp);
																				listaRelacoesTemp = NULL;
                                                                            }
            | PRODUZIDA '=' '{' ListaEntidades '}'							{	
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, listaRelacoesTemp);
																				listaProduzida = g_slist_concat(listaProduzida, listaRelacoesTemp);
																				listaRelacoesTemp = NULL;
                                                                            }
       		;

RelacoesEvento : RelacoesEvento RelacaoEvento   	                        {
																				
																			}
      	 	 | %empty                                                       {
      																			
      																		}
         	 ;

RelacaoEvento : EXPOE '=' '{' ListaEntidades '}'                            {	
                                                                                obrasEsperadas = g_slist_concat(obrasEsperadas, listaRelacoesTemp);
																				listaExpoe = g_slist_concat(listaExpoe, listaRelacoesTemp);
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
  printf("/*\n* @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph g {\nrankdir=LR;\n ratio=fill; node[fontsize=24]; edge[fontsize=16];\n");
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
    obrasEncontradas = g_hash_table_new(g_str_hash,g_str_equal);
    eventosEncontrados = g_hash_table_new(g_str_hash,g_str_equal);
    writeDotBeginning();
    yyparse();
    printf("}");
    testeArtistasEsperados();
    return 0;
}