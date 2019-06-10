%{
    #define _GNU_SOURCE
    #include <stdio.h>
    #include <ctype.h>
    #include <string.h>
    #include <glib.h>
    #include "lex.yy.c"

    int yylex();
    int yyerror(char *s);

    //Estrutura para armazenar os atributos de um artista
    typedef struct artistaAtributos{
        char* nome;
        char* pais; 
		char* seculo;
		char* periodo;
		char* imagem;
    } *ArtistaAtributos;

    ArtistaAtributos artAtrib;

    //Chamar no final de processar cada artista
    void initArtistaAtributos(){
        if(artAtrib != NULL){
            free(artAtrib->nome);
            free(artAtrib->pais);
            free(artAtrib->seculo);
            free(artAtrib->periodo);
            free(artAtrib->imagem);
            free(artAtrib);
        }
		artAtrib = malloc(sizeof(struct artistaAtributos));
		artAtrib->nome = NULL;
		artAtrib->pais = NULL;
		artAtrib->seculo = NULL;
		artAtrib->periodo = NULL;
		artAtrib->imagem = NULL;
    }

    //Estrutura para armazenar os atributos de uma obra
    typedef struct obraAtributos{
        char* nome;
        char* data; 
		char* tecnica;
		char* valor;
		char* local;
        char* imagem;
    } *ObraAtributos;

    ObraAtributos obrAtrib;

    //Chamar no final de processar cada obra
    void initObraAtributos(){
        if(obrAtrib != NULL){
            free(obrAtrib->nome);
            free(obrAtrib->data);
            free(obrAtrib->tecnica);
            free(obrAtrib->valor);
            free(obrAtrib->local);
            free(obrAtrib);
        }
		obrAtrib = malloc(sizeof(struct obraAtributos));
		obrAtrib->nome = NULL;
		obrAtrib->data = NULL;
		obrAtrib->tecnica = NULL;
		obrAtrib->valor = NULL;
		obrAtrib->local = NULL;
        obrAtrib->imagem = NULL;
    }

    //Estrutura para armazenar os atributos de um evento
    typedef struct eventoAtributos{
        char* tipo;
        char* localizacao; 
		char* data;
        char* imagem;
    } *EventoAtributos;

    EventoAtributos eventAtrib;

    //Chamar no final de processar cada artista
    void initEventoAtributos(){
        if(eventAtrib != NULL){
            free(eventAtrib->tipo);
            free(eventAtrib->localizacao);
            free(eventAtrib->data);
            free(eventAtrib->imagem);
            free(eventAtrib);
        }
        eventAtrib = malloc(sizeof(struct eventoAtributos));
		eventAtrib->tipo = NULL;
		eventAtrib->localizacao = NULL;
		eventAtrib->data = NULL;
        eventAtrib->imagem = NULL;
    }
    //Estruturas de dados para armazenar todas as entidades encontradas
    GHashTable* artistasEncontrados = NULL;
    GHashTable* obrasEncontradas = NULL;
    GHashTable* eventosEncontrados = NULL;
    //Estruturas de dados para armazenar todas as entidades que são referidas nas relações
    GSList* artistasEsperados = NULL;
    GSList* obrasEsperadas = NULL;
    GSList* eventosEsperados = NULL;

    //Lista para guardar as entidades mencionadas numa relação antes da relação ser determinada
    GSList* listaRelacoesTemp = NULL;

    //Relações entre artista e artista
    GSList* listaEnsinou = NULL;
    GSList* listaAprendeu = NULL;
    GSList* listaColaborou = NULL;
    //Relação entre artista e obra
    GSList* listaProduziu = NULL;
    //Relação entre artista e evento
    GSList* listaParticipou = NULL;
    //Chamar no final de cada artista para outros artistas não ficarem com as mesmas relações
    void limparRelacoesArtista(){
        g_slist_free(listaEnsinou);
        g_slist_free(listaAprendeu);
        g_slist_free(listaColaborou);
        g_slist_free(listaProduziu);
        g_slist_free(listaParticipou);
        listaEnsinou = NULL;
        listaAprendeu = NULL;
        listaColaborou = NULL;  
        listaProduziu = NULL;
        listaParticipou = NULL;
    }

    //Relação entre obra e artista
    GSList* listaProduzida = NULL;
    //Relações entre obra e evento
    GSList* listaExposta = NULL;
    GSList* listaVendida = NULL;
    //Chamar no final de cada obra para outras obras não ficarem com as mesmas relações
    void limparRelacoesObra(){
        g_slist_free(listaProduzida);
        g_slist_free(listaExposta);
        g_slist_free(listaVendida);
        listaProduzida = NULL;
        listaExposta = NULL;
        listaVendida = NULL;  
    }

    //Relações entre evento e obra
    GSList* listaExpoe = NULL;
    GSList* listaVendidos = NULL;
    //Chamar no final de cada evento para outros eventos não ficarem com as mesmas relações
    void limparRelacoesEvento(){
        g_slist_free(listaExpoe);
        g_slist_free(listaVendidos);
        listaExpoe = NULL;
        listaVendidos = NULL; 
    }

    //Imprime no ficheiro dado uma tabela em HTML com os atributos do artista atual
    void writeTabelaAtributosArtista(FILE* fd){

        fwrite("<table>\n", 1 , 7, fd);        
	    char* linhaTabela;
	    if(artAtrib->nome != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Nome Completo", artAtrib->nome);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(artAtrib->pais != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "País", artAtrib->pais);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(artAtrib->seculo != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Século", artAtrib->seculo);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(artAtrib->periodo != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Período", artAtrib->periodo);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        fwrite("</table>\n", 1 , 9, fd);
    }

    //Escreve nodo para o artista
    void writeDotArtista(char* nome){
        if(artAtrib->imagem == NULL){
            printf("\"%s\" [URL=\"file:Artista %s.html\" style=filled, color=\".3 .4 .8\"]\n", nome, nome);
        }
        else{
            printf("\"%s\" [style=filled fillcolor=\".3 .4 .8\" URL=\"file:Artista %s.html\" shape=box label=<<table border=\"0\"><tr><td border=\"0\" fixedsize=\"true\" width=\"200\" height=\"200\" ><img src=\"%s\"/></td></tr><tr><td>%s</td></tr></table> >]",
                   nome, nome, artAtrib->imagem, nome); 
        }
    }

    void writeArtista(char* nome) {
        //Escrever nodo para o artista
        writeDotArtista(nome);

        //Abrir ficheiro html
        char* fileName;
        asprintf(&fileName, "Artista %s.html", nome);
        FILE* fd = fopen(fileName,"w");
        free(fileName);

        //Escrever inicio e titulo
        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(nome, 1, strlen(nome), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        //Adicionar imagem
        if(artAtrib->imagem != NULL){
        	char* img;
            asprintf(&img, "<img src=\"%s\">", artAtrib->imagem);
			fwrite(img, 1, strlen(img), fd);	
            free(img);
        }
        //Escrever a tabela html de atributps
        writeTabelaAtributosArtista(fd);
        //Processar as relações
        GSList* temp;
        char * href;
        char* outraEntidade;
        if(listaEnsinou != NULL){
          temp = listaEnsinou;
          fwrite("<h2>Ensinou:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"ensinou\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          } 
        }
        if(listaAprendeu != NULL){
          temp = listaAprendeu;
          fwrite("<h2>Aprendeu com:</h2>\n",1,23, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"aprendeu com\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          }
        }
        if(listaColaborou != NULL){
          temp = listaColaborou;
          fwrite("<h2>Colaborou com:</h2>\n",1,24, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"colaborou com\" dir=\"both\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          }    
        }

        if(listaProduziu != NULL){
          temp = listaProduziu;
          fwrite("<h2>Produziu:</h2>\n",1,19, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"produziu\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Obra %s.html\">%s</a>\n", outraEntidade, outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          }    
        }

        if(listaParticipou != NULL){
          temp = listaParticipou;
          fwrite("<h2>Participou:</h2>\n",1,20, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"participou\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Evento %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            temp = temp->next;
            free(href);
          }    
        }
        fwrite("</body>\n</html>" , 1 , 15, fd );
    }
    //Imprime no ficheiro dado uma tabela em HTML com os atributos da obra atual
    void writeTabelaAtributosObra(FILE* fd){

        fwrite("<table>\n", 1 , 7, fd);
        
	    char* linhaTabela;
	    if(obrAtrib->nome != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Nome", obrAtrib->nome);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(obrAtrib->data != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "País", obrAtrib->data);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(obrAtrib->tecnica != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Técnica", obrAtrib->tecnica);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(obrAtrib->valor != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Valor", obrAtrib->valor);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(obrAtrib->local != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Local de exposição", obrAtrib->local);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        fwrite("</table>\n", 1 , 9, fd);
    }

    //Escreve nodo para a obra
    void writeDotObra(char* nome){
        if(obrAtrib->imagem == NULL){
            printf("\"%s\" [URL=\"file:Obra %s.html\" style=filled, color=\"1.0 .6 1.0\"]\n", nome, nome);
        }
        else{
            printf("\"%s\" [style=filled fillcolor=\"1.0 .6 1.0\" URL=\"file:Obra %s.html\" shape=box label=<<table border=\"0\"><tr><td border=\"0\" fixedsize=\"true\" width=\"200\" height=\"200\" ><img src=\"%s\"/></td></tr><tr><td>%s</td></tr></table> >]",
                   nome, nome, obrAtrib->imagem, nome); 
        }
    }

    void writeObra(char* nome) {
        //Escrever nodo para obra
        writeDotObra(nome);
        //Abrir ficheiro html
        char* fileName;
        asprintf(&fileName, "Obra %s.html", nome);
        FILE* fd = fopen(fileName,"w");
        free(fileName);
        //Escrever inicio e titulo
        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(nome, 1, strlen(nome), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        //Adicionar imagem
        if(obrAtrib->imagem != NULL){
        	char* img;
            asprintf(&img, "<img src=\"%s\">", obrAtrib->imagem);
			fwrite(img, 1, strlen(img), fd);
            free(img);	
        }
        //Escrever tabela html dos atributos
        writeTabelaAtributosObra(fd);
        //Processar relações
        GSList* temp;
        char * href;
        char* outraEntidade;
        if(listaExposta != NULL){
          temp = listaExposta;
          fwrite("<h2>Exposta:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"exposta em\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Evento %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          } 
        }
        if(listaProduzida != NULL){
          temp = listaProduzida;
          fwrite("<h2>Produzida:</h2>\n",1,20, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"produzida por\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Artista %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          } 
        }
        if(listaVendida != NULL){
          temp = listaVendida;
          fwrite("<h2>Vendida:</h2>\n",1,20, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"vendida em\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Evento %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          } 
        }
        fwrite("</body>\n</html>" , 1 , 15, fd );
    }
    //Imprime no ficheiro dado uma tabela em HTML com os atributos do evento atual
    void writeTabelaAtributosEvento(FILE* fd){

        fwrite("<table>\n", 1 , 7, fd);
        
	    char* linhaTabela;
	    if(eventAtrib->tipo != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Tipo", eventAtrib->tipo);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(eventAtrib->localizacao != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Localização", eventAtrib->localizacao);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        if(eventAtrib->data != NULL){
            asprintf(&linhaTabela, "<tr>\n<th>%s</th>\n<td>%s</td>\n</tr>", "Data", eventAtrib->data);
			fwrite(linhaTabela, 1, strlen(linhaTabela), fd);
            free(linhaTabela);
        }
        fwrite("</table>\n", 1 , 9, fd);
    }
    //Escreve nodo para o evento
    void writeDotEvento(char* nome){
        if(eventAtrib->imagem == NULL){
            printf("\"%s\" [URL=\"file:Evento %s.html\" style=filled, color=\".5 .5 1\"]\n", nome, nome);
        }
        else{
            printf("\"%s\" [style=filled fillcolor=\".5 .5 1\" URL=\"file:Evento %s.html\" shape=box label=<<table border=\"0\"><tr><td border=\"0\" fixedsize=\"true\" width=\"200\" height=\"200\" ><img src=\"%s\"  /></td></tr><tr><td>%s</td></tr></table> >]",
                   nome,nome, eventAtrib->imagem, nome);
        }
    }

    void writeEvento(char* nome) {
        //Escrever nodo para o artista
        writeDotEvento(nome);
        //Abrir ficheiro html
        char* fileName;
        asprintf(&fileName, "Evento %s.html", nome);
        FILE* fd = fopen(fileName,"w");
        free(fileName);
        //Escrever inicio e titulo
        fwrite("<!DOCTYPE html>\n<html>\n<head>\n<h1>" , 1 , 34, fd );
        fwrite(nome, 1, strlen(nome), fd);
        fwrite("</h1>\n</head>\n<body>" , 1 , 20, fd );
        //Adicionar imagem
        if(eventAtrib->imagem != NULL){
        	char* img;
            asprintf(&img, "<img src=\"%s\">", eventAtrib->imagem);
			fwrite(img, 1, strlen(img), fd);	
            free(img);
        }
        //Escrever tabela html dos atributos
        writeTabelaAtributosEvento(fd);
        //Processar relacoes
        GSList* temp;
        char * href;
        char* outraEntidade;
        if(listaExpoe != NULL){
          temp = listaExpoe;
          fwrite("<h2>Expõe:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"expõe\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Obra %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          } 
        }
        if(listaVendidos != NULL){
          temp = listaVendidos;
          fwrite("<h2>Vendeu:</h2>\n",1,18, fd);
          while(temp != NULL){
            outraEntidade = (char*)temp->data;
            //Aresta do dot
            printf("\"%s\" -> \"%s\" [label=\"vendeu\"]\n", nome, outraEntidade);
            //Link html
            asprintf(&href,"<a href=\"Obra %s.html\">%s</a>\n", outraEntidade,outraEntidade);
            fwrite(href,1,strlen(href), fd);
            free(href);
            temp = temp->next;
          } 
        }

        fwrite("</body>\n</html>" , 1 , 15, fd );
    }
%}

%union { char* VARNAME; int CONSTINT; char* string;}

%token ARTISTAKEYWORD
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


Artista : ARTISTAKEYWORD VALOR '{' ArtistaInformacoes '}'                       {   
                                                                                    gboolean naoExistia = g_hash_table_insert(artistasEncontrados, $2, $2);
                                                                                    if(naoExistia == FALSE){
                                                                                        char * mensagemErro;
                                                                                        asprintf(&mensagemErro, "Artista %s repetido\n", $2);
                                                                                        yyerror(mensagemErro);
                                                                                    }
                                                                                    writeArtista($2);
                                                                                    //Remover das variáveis globais a informação do artista
                                                                                    limparRelacoesArtista();
                                                                                    initArtistaAtributos();
                                                                                }
        ;


ArtistaInformacoes : ArtistaInformacoes  ArtistaInformacao
                   | %empty
                   ;

ArtistaInformacao : AtributoArtista
                  | RelacaoArtista
                  ;




AtributoArtista : TipoAtributoArtista'=' VALOR                              {   
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
                                                                                    artAtrib->imagem = $3;
                                                                                }
                                                                            }
            ;


TipoAtributoArtista : NOMECOMPLETO                                              {$$ = "Nome completo";}
                    | PAIS                                                      {$$ = "País";}
                    | SECULO                                                    {$$ = "Século";}
                    | PERIODO                                                   {$$ = "Período";}  
                    | IMAGEM                                                    {$$ = "Imagem";}                                                            
                    ;

RelacaoArtista : ENSINOU '=' '{' ListaEntidades '}'                         {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaEnsinou = g_slist_concat(listaEnsinou, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
               | APRENDEU '=' '{' ListaEntidades '}'                        {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaAprendeu = g_slist_concat(listaAprendeu, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
               | COLABOROU '=' '{' ListaEntidades '}'                       {   
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                artistasEsperados = g_slist_concat(artistasEsperados, l);
                                                                                listaColaborou = g_slist_concat(listaColaborou, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
               | PRODUZIU '=' '{' ListaEntidades '}'                        {
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                obrasEsperadas = g_slist_concat(obrasEsperadas, l);
                                                                                listaProduziu = g_slist_concat(listaProduziu, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
               | PARTICIPOU '=' '{' ListaEntidades '}'                      {
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                eventosEsperados = g_slist_concat(eventosEsperados, l);
                                                                                listaParticipou = g_slist_concat(listaParticipou, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
               ;

Obra : OBRAKEYWORD VALOR '{' ObraInformacoes '}'                            {   
                                                                                gboolean naoExistia = g_hash_table_insert(obrasEncontradas, $2, $2);
                                                                                if(naoExistia == FALSE){
                                                                                    char * mensagemErro;
                                                                                    asprintf(&mensagemErro, "Obra %s repetida\n", $2);
                                                                                    yyerror(mensagemErro);
                                                                                }    
                                                                                writeObra($2);
                                                                                //Remover das variáveis globais a informação da obra
                                                                                initObraAtributos();
                                                                                limparRelacoesObra();
                                                                            }
     ;

ObraInformacoes : ObraInformacoes  ObraInformacao
                | %empty
                ; 

ObraInformacao : AtributoObra 
               | RelacaoObra
               ;

AtributoObra : TipoAtributoObra '=' VALOR                                   {   
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
                                                                                else if(strcmp($1,"Imagem") == 0){
                                                                                    if(obrAtrib->imagem != NULL){
                                                                                        yyerror("Imagem repetido");
                                                                                    }
                                                                                    obrAtrib->imagem = $3;
                                                                                }
                                                                            }
             ;


TipoAtributoObra : NOME                                                         {$$ = "Nome";}
                 | DATA                                                         {$$ = "Data";}
                 | TECNICA                                                      {$$ = "Técnica";}
                 | VALORMONETARIO                                               {$$ = "Valor";}                                                              
                 | LOCALEXPOSICAO                                               {$$ = "Local de exposição";}   
                 | IMAGEM                                                       {$$ = "Imagem";}
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
            | VENDIDA '=' '{' ListaEntidades '}'                            {
                                                                                GSList * l = g_slist_copy(listaRelacoesTemp);
                                                                                eventosEsperados = g_slist_concat(eventosEsperados, l);
                                                                                listaVendida = g_slist_concat(listaVendida, listaRelacoesTemp);
                                                                                listaRelacoesTemp = NULL;
                                                                            }
            ;

Evento : EVENTOKEYWORD VALOR '{' EventoInformacoes '}'                      {   
                                                                                gboolean naoExistia = g_hash_table_insert(eventosEncontrados, $2, $2);
                                                                                if(naoExistia == FALSE){
                                                                                    char * mensagemErro;
                                                                                    asprintf(&mensagemErro, "Evento %s repetido\n", $2);
                                                                                    yyerror(mensagemErro);
                                                                                }    
                                                                                writeEvento($2);
                                                                                //Remover das variáveis globais a informação do evento
                                                                                initEventoAtributos();
                                                                                limparRelacoesEvento();                                                                             
                                                                            }
       ;

EventoInformacoes : EventoInformacoes  EventoInformacao
                | %empty
                ; 

EventoInformacao : AtributoEvento 
                 | RelacaoEvento
                 ;

AtributoEvento : TipoAtributoEvento '=' VALOR                               { 
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
                                                                                else if(strcmp($1,"Imagem") == 0){
                                                                                    if(eventAtrib->imagem != NULL){
                                                                                        yyerror("Imagem repetido");
                                                                                    }
                                                                                    eventAtrib->imagem = $3;
                                                                                }
                                                                            }
               ;

TipoAtributoEvento : TIPO                                                      {$$ = "Tipo";}
                   | LOCALIZACAO                                               {$$ = "Localização";}
                   | DATA                                                      {$$ = "Data";} 
                   | IMAGEM                                                    {$$ = "Imagem";}
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
	printf("/*\n* @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph MuseuVirtualDoArtista {\nrankdir=LR;forcelabels=true; ratio=fill; node[fontsize=16]; edge[fontsize=16];\n");
}

//Verifica se todos os artistas referidos nas relações estão definidos
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
    g_slist_free_full(artistasEsperados, g_free);  
    g_hash_table_destroy(artistasEncontrados);
}

//Verifica se todos os obras referidas nas relações estão definidos
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
    g_slist_free_full(obrasEsperadas, g_free); 
    g_hash_table_destroy(obrasEncontradas);
}

//Verifica se todos os eventos referidos nas relações estão definidos
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
    g_slist_free_full(eventosEsperados, g_free); 
    g_hash_table_destroy(eventosEncontrados);
}

int main() {
    //Inicializar variáveis globais
	initArtistaAtributos();
    initObraAtributos();
    initEventoAtributos();
    artistasEncontrados = g_hash_table_new_full(g_str_hash,g_str_equal, g_free,NULL);
    obrasEncontradas = g_hash_table_new_full(g_str_hash,g_str_equal, g_free,NULL);
    eventosEncontrados = g_hash_table_new_full(g_str_hash,g_str_equal, g_free,NULL);
    //Escrever inicio do ficheiro dot
    writeDotBeginning();
    //Processar
    yyparse();
    printf("}");
    //Validar referências a entidades
    testeArtistasEsperados();
    testeObrasEsperadas();
    testeEventosEsperados();
    return 0;
}