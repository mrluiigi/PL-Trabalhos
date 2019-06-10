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


    typedef struct artistaAtributos{
        char* nome;
        char* pais; 
		char* seculo;
		char* periodo;
		char* imagem;
    } *ArtistaAtributos;

    ArtistaAtributos artAtrib;

    void initArtistaAtributos(){
		artAtrib = malloc(sizeof(struct artistaAtributos));
		artAtrib->nome = NULL;
		artAtrib->pais = NULL;
		artAtrib->seculo = NULL;
		artAtrib->periodo = NULL;
		artAtrib->imagem = NULL;
    }


    typedef struct obraAtributos{
        char* nome;
        char* data; 
		char* tecnica;
		char* valor;
		char* local;
    } *ObraAtributos;

    ObraAtributos obrAtrib;

    void initObraAtributos(){
		obrAtrib = malloc(sizeof(struct obraAtributos));
		obrAtrib->nome = NULL;
		obrAtrib->data = NULL;
		obrAtrib->tecnica = NULL;
		obrAtrib->valor = NULL;
		obrAtrib->local = NULL;
    }


    typedef struct eventoAtributos{
        char* tipo;
        char* localizacao; 
		char* data;
    } *EventoAtributos;

    EventoAtributos eventAtrib;

    void initEventoAtributos(){
		eventAtrib = malloc(sizeof(struct eventoAtributos));
		eventAtrib->tipo = NULL;
		eventAtrib->localizacao = NULL;
		eventAtrib->data = NULL;
    }

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

    GSList* listaVendida = NULL;
    GSList* listaVendidos = NULL;



    char * imagem = NULL;




    void writeTabelaAtributosArtista(FILE* fd){

        fwrite("<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>", 1 , 51, fd);
        
	    char* linhaTabela;
	    if(artAtrib->nome != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Nome Completo", artAtrib->nome);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(artAtrib->pais != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Pais", artAtrib->pais);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(artAtrib->seculo != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Seculo", artAtrib->seculo);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(artAtrib->periodo != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Periodo", artAtrib->periodo);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(artAtrib->imagem != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Imagem", artAtrib->imagem);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        fwrite("</table>\n", 1 , 9, fd);
    }

    void writeHtmlArtista(char* title) {
        char* fileName;

        asprintf(&fileName, "Artista %s.html", title);

        FILE* fd = fopen(fileName,"w");

        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(title, 1, strlen(title), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        writeTabelaAtributosArtista(fd);
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
            printf("\"%s\" -> \"%s\" [label=\"colaborou\" dir=\"both\"]\n", title, outraEntidade);
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

    void writeTabelaAtributosObra(FILE* fd){

        fwrite("<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>", 1 , 51, fd);
        
	    char* linhaTabela;
	    if(obrAtrib->nome != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Nome", obrAtrib->nome);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(obrAtrib->data != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "País", obrAtrib->data);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(obrAtrib->tecnica != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Técnica", obrAtrib->tecnica);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(obrAtrib->valor != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Valor", obrAtrib->valor);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(obrAtrib->local != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Local de exposição", obrAtrib->local);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        fwrite("</table>\n", 1 , 9, fd);
    }

    void writeHtmlObra(char* title) {
        char* fileName;

        asprintf(&fileName, "Obra %s.html", title);

        FILE* fd = fopen(fileName,"w");

        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(title, 1, strlen(title), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        writeTabelaAtributosObra(fd);

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
          fwrite("<h2>Produzida:</h2>\n",1,20, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"Produzida por\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }
        if(listaVendida != NULL){
          temp = listaVendida;
          fwrite("<h2>Vendida:</h2>\n",1,20, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"Vendida em\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Evento %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }

        fwrite("</body>\n</html>" , 1 , 15, fd );


    }

    void writeTabelaAtributosEvento(FILE* fd){

        fwrite("<table>\n<tr>\n<th>Atributo</th>\n<th>Valor</th>\n</tr>", 1 , 51, fd);
        
	    char* linhaTabela;
	    if(eventAtrib->tipo != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Tipo", eventAtrib->tipo);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(eventAtrib->localizacao != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Localização", eventAtrib->localizacao);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        if(eventAtrib->data != NULL){
            asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", "Data", eventAtrib->data);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
        }
        fwrite("</table>\n", 1 , 9, fd);
    }

    void writeHtmlEvento(char* title) {
        char* fileName;

        asprintf(&fileName, "Evento %s.html", title);

        FILE* fd = fopen(fileName,"w");

        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(title, 1, strlen(title), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        writeTabelaAtributosEvento(fd);

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
        if(listaVendidos != NULL){
          temp = listaVendidos;
          fwrite("<h2>Vendidos:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            printf("\"%s\" -> \"%s\" [label=\"Vendidos\"]\n", title, outraEntidade);
            asprintf(&href,"<a href=\"Obra %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
          } 
        }

        fwrite("</body>\n</html>" , 1 , 15, fd );


    }


    void writeDotArtista(char* nome){
        if(imagem == NULL){
            printf("\"%s\" [URL=\"file:Artista %s.html\" style=filled, color=\".3 .4 .8\"]\n", nome, nome);
        }
        else{
             printf("\"%s\" [nojustify=true shape=\"none\" label=\"\" xlabel=\"%s\" image=\"%s\" URL=\"file:Artista %s.html\" width=\"1\" height=\"1\" imagescale=both  fixedsize=true]\n", nome, nome, imagem, nome);   
        }
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

%token VENDIDA
%token VENDEU

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

%token IMAGEM



%token <string> VALOR
%token <string> ATRIBUTOOBRA
%token <string> ATRIBUTOEVENTO

%type <string> AtributoArtista AtributoObra AtributoEvento TipoAtributoArtista TipoAtributoObra TipoAtributoEvento

%%

MvA : Entidades                                                            

Entidades : Entidades Entidade
          | Entidade
          ;



Entidade : Artista 
         | Obra   
         | Evento                           
         ;

Artista : ART VALOR '{' ArtistaInformacoes '}'                                  {   
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
                                                                                    writeHtmlArtista($2);

                                                                                    listaAtributos = NULL;
                                                                                    listaEnsinou = NULL;
                                                                                    listaAprendeu = NULL;
                                                                                    listaColaborou = NULL;  
                                                                                    listaProduziu = NULL;
                                                                                    listaParticipou = NULL;
                                                                                    initArtistaAtributos();
                                                                                    imagem = NULL;                                                                               
                                                                                }
        ;


ArtistaInformacoes : ArtistaInformacoes  ArtistaInformacao
                   | %empty
                   ;

ArtistaInformacao : AtributoArtista
                  | RelacaoArtista
                  ;




AtributoArtista : TipoAtributoArtista'=' VALOR                              {   
                                                                                char* linhaTabela;
                                                                                asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
                                                                                listaAtributos = g_slist_append(listaAtributos, linhaTabela);
                                                                                asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
                                                                                if(strcmp($1,"Nome completo") == 0){
                                                                                    if(artAtrib->nome != NULL){
                                                                                    	yyerror("Nome repetido");
                                                                                    }
                                                                                    artAtrib->nome = $3;
                                                                                }
                                                                                else if(strcmp($1,"País") == 0){
                                                                                	if(artAtrib->pais != NULL){
                                                                                    	yyerror("País repetido");
                                                                                    }
                                                                                    artAtrib->pais = $3;
                                                                                }
                                                                                else if(strcmp($1,"Século") == 0){
                                                                                	if(artAtrib->seculo != NULL){
                                                                                    	yyerror("Século repetido");
                                                                                    }
                                                                                    artAtrib->seculo = $3;
                                                                                }
                                                                                else if(strcmp($1,"Período") == 0){
                                                                                	if(artAtrib->periodo != NULL){
                                                                                    	yyerror("Período repetido");
                                                                                    }
                                                                                    artAtrib->periodo = $3;
                                                                                }
                                                                                else if(strcmp($1,"Imagem") == 0){
                                                                                	if(artAtrib->imagem != NULL){
                                                                                    	yyerror("Imagem repetido");
                                                                                    }
                                                                                    imagem = $3;
                                                                                    artAtrib->imagem = $3;
                                                                                }
                                                                                ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                            }
         ;


TipoAtributoArtista : NOMECOMPLETO                                              {$$ = "Nome completo";}
                    | PAIS                                                      {$$ = "País";}
                    | SECULO                                                    {$$ = "Século";}
                    | PERIODO                                                   {$$ = "Período";}  
                    | IMAGEM                                                    {$$ = "Imagem";}                                                            
                    ;


Obra : OBRAKEYWORD VALOR '{' ObraInformacoes '}'                                   {   
                                                                                gboolean naoExistia = g_hash_table_insert(obrasEncontradas, $2, $2);
                                                                                if(naoExistia == FALSE){
                                                                                    char * mensagemErro;
                                                                                    asprintf(&mensagemErro, "Obra %s repetida\n", $2);
                                                                                    yyerror(mensagemErro);
                                                                                }    

                                                                                writeDotObra($2);
                                                                                writeHtmlObra($2);
                                                                                initObraAtributos();
                                                                                listaExposta = NULL;
                                                                                listaProduzida = NULL;
                                                                                listaVendida = NULL;  
                                                                                listaAtributos = NULL;
                                                                            }
        ;






ObraInformacoes : ObraInformacoes  ObraInformacao
                | %empty
                ; 

ObraInformacao : AtributoObra 
               | RelacaoObra
               ;

AtributoObra : TipoAtributoObra '=' VALOR                                   {   
                                                                                char* linhaTabela;
                                                                                asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
                                                                                listaAtributos = g_slist_append(listaAtributos, linhaTabela);
                                                                                asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);

																				if(strcmp($1,"Nome") == 0){
                                                                                    if(obrAtrib->nome != NULL){
                                                                                    	yyerror("Nome repetido");
                                                                                    }
                                                                                    obrAtrib->nome = $3;
                                                                                }
                                                                                else if(strcmp($1,"Data") == 0){
                                                                                	if(obrAtrib->data != NULL){
                                                                                    	yyerror("Data repetido");
                                                                                    }
                                                                                    obrAtrib->data = $3;
                                                                                }
                                                                                else if(strcmp($1,"Técnica") == 0){
                                                                                	if(obrAtrib->tecnica != NULL){
                                                                                    	yyerror("Técnica repetido");
                                                                                    }
                                                                                    obrAtrib->tecnica = $3;
                                                                                }
                                                                                else if(strcmp($1,"Valor") == 0){
                                                                                	if(obrAtrib->valor != NULL){
                                                                                    	yyerror("Valor repetido");
                                                                                    }
                                                                                    obrAtrib->valor = $3;
                                                                                }
                                                                                else if(strcmp($1,"Local de exposição") == 0){
                                                                                	if(obrAtrib->local != NULL){
                                                                                    	yyerror("Local de exposição repetido");
                                                                                    }
                                                                                    obrAtrib->local = $3;
                                                                                }

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




Evento : EVENTOKEYWORD VALOR '{' EventoInformacoes '}'                             {   
                                                                                gboolean naoExistia = g_hash_table_insert(eventosEncontrados, $2, $2);
                                                                                if(naoExistia == FALSE){
                                                                                    char * mensagemErro;
                                                                                    asprintf(&mensagemErro, "Evento %s repetido\n", $2);
                                                                                    yyerror(mensagemErro);
                                                                                }    

                                                                                writeDotEvento($2);
                                                                                writeHtmlEvento($2);
                                                                                initEventoAtributos();
                                                                                listaAtributos = NULL;
                                                                                listaExpoe = NULL;
                                                                                listaVendidos = NULL;                                                                              
                                                                            }
        ;




EventoInformacoes : EventoInformacoes  EventoInformacao
                | %empty
                ; 

EventoInformacao : AtributoEvento 
                 | RelacaoEvento
                 ;

AtributoEvento : TipoAtributoEvento '=' VALOR                               { 
                                                                                char* linhaTabela;
                                                                                asprintf(&linhaTabela, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);
                                                                                listaAtributos = g_slist_append(listaAtributos, linhaTabela);
                                                                                asprintf(&$$, "<tr>\n<td>%s</td>\n<td>%s</td>\n</tr>", $1, $3);

																				if(strcmp($1,"Tipo") == 0){
                                                                                    if(eventAtrib->tipo != NULL){
                                                                                    	yyerror("Tipo repetido");
                                                                                    }
                                                                                    eventAtrib->tipo = $3;
                                                                                }
                                                                                else if(strcmp($1,"Localização") == 0){
                                                                                	if(eventAtrib->localizacao != NULL){
                                                                                    	yyerror("Localização repetido");
                                                                                    }
                                                                                    eventAtrib->localizacao = $3;
                                                                                }
                                                                                else if(strcmp($1,"Data") == 0){
                                                                                	if(eventAtrib->data != NULL){
                                                                                    	yyerror("Data repetida");
                                                                                    }
                                                                                    eventAtrib->data = $3;
                                                                                }
                                                                                

                                                                                ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                            }
         ;


TipoAtributoEvento : TIPO                                                      {$$ = "Tipo";}
                   | LOCALIZACAO                                               {$$ = "Localização";}
                   | DATA                                                      {$$ = "Data";} 
                   ;




RelacaoArtista : ENSINOU '=' '{' ListaEntidades '}'                                {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaEnsinou = g_slist_concat(listaEnsinou, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
        | APRENDEU '=' '{' ListaEntidades '}'                               {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaAprendeu = g_slist_concat(listaAprendeu, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
        | COLABOROU '=' '{' ListaEntidades '}'                              {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaColaborou = g_slist_concat(listaColaborou, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
        | PRODUZIU '=' '{' ListaEntidades '}'                               {
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                obrasEsperadas = g_slist_concat(obrasEsperadas, l);
                                                                                listaProduziu = g_slist_concat(listaProduziu, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
        | PARTICIPOU '=' '{' ListaEntidades '}'                             {
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                eventosEsperados = g_slist_concat(eventosEsperados, l);
                                                                                listaParticipou = g_slist_concat(listaParticipou, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
        ;



RelacaoObra : EXPOSTA '=' '{' ListaEntidades '}'                            {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                eventosEsperados = g_slist_concat(eventosEsperados, l);
                                                                                listaExposta = g_slist_concat(listaExposta, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
            | PRODUZIDA '=' '{' ListaEntidades '}'                          {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaProduzida = g_slist_concat(listaProduzida, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
            | VENDIDA '=' '{' ListaEntidades '}'							{
            																	GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                eventosEsperados = g_slist_concat(eventosEsperados, l);
                                                                                listaVendida = g_slist_concat(listaVendida, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
            																}
            ;



RelacaoEvento : EXPOE '=' '{' ListaEntidades '}'                            {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                obrasEsperadas = g_slist_concat(obrasEsperadas, l);
                                                                                listaExpoe = g_slist_concat(listaExpoe, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
              | VENDEU '=' '{' ListaEntidades '}'							{
              																	GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                obrasEsperadas = g_slist_concat(obrasEsperadas, l);
                                                                                listaVendidos = g_slist_concat(listaVendidos, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
              																}
            ;

ListaEntidades : ListaEntidades ';' VALOR                                   {
                                                                                listaRelacoesTemp = g_slist_append(listaRelacoesTemp, $3);
                                                                            }
               | VALOR                                                      {
                                                                                listaRelacoesTemp = g_slist_append(listaRelacoesTemp, $1);
                                                                            }
               ;


%%

int yyerror (char *s) {
    printf("ERRO: %s \n", s);
    exit(1);
}

void writeDotBeginning() {
  printf("/*\n* @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph g {\nrankdir=LR;forcelabels=true; ratio=fill; node[fontsize=16]; edge[fontsize=16];\n");
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


void testeObrasEsperadas(){
    GSList* temp = obrasEsperadas;
    while(temp != NULL){
    char* esperado = (char*)temp->data;
    gpointer res = g_hash_table_lookup (obrasEncontradas,esperado);
    if(res == NULL){
        char * mensagemErro;
        asprintf(&mensagemErro, "Esperado encontrar obra %s\n", esperado);
        yyerror(mensagemErro);
    }
    temp = temp->next;
    }     
}


void testeEventosEsperados(){
    GSList* temp = eventosEsperados;
    while(temp != NULL){
    char* esperado = (char*)temp->data;
    gpointer res = g_hash_table_lookup (eventosEncontrados,esperado);
    if(res == NULL){
        char * mensagemErro;
        asprintf(&mensagemErro, "Esperado encontrar evento %s\n", esperado);
        yyerror(mensagemErro);
    }
    temp = temp->next;
    }     
}

int main() {
	initArtistaAtributos();
    initObraAtributos();
    initEventoAtributos();
    artistasEncontrados = g_hash_table_new(g_str_hash,g_str_equal);
    obrasEncontradas = g_hash_table_new(g_str_hash,g_str_equal);
    eventosEncontrados = g_hash_table_new(g_str_hash,g_str_equal);
    writeDotBeginning();
    yyparse();
    printf("}");
    testeArtistasEsperados();
    testeObrasEsperadas();
    testeEventosEsperados();
    return 0;
}