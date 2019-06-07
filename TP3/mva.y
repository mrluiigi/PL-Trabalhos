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

%}

%union { char* VARNAME; int CONSTINT; char* string;}

%token ART

%token <VARNAME> VALOR
%token <VARNAME> PALAVRA



%%

MvA : Entidades                                                            

Entidades : Entidades Entidade
          | Entidade
          ;



Entidade : Artista                               
         ;

Artista : ART VALOR '{' ArtistaInfo '}'          
        ;

ArtistaInfo : Atributos                                                       
            ;

Atributos : Atributos Atributo                                                 {listaAtributos = g_slist_append(listaAtributos, ats);}
          | Atributo                                                           {listaAtributos = g_slist_append(listaAtributos, ats);}
          ;

Atributo : PALAVRA '=' VALOR                                                  {ats = malloc(sizeof(struct atributoStruct));
                                                                                ats->atribNome = $1;  
                                                                                ats->atribValor = $3;
                                                                            //  asprintf(ats->atribNome, "%s\n%s\n", $1, $2);
                                                                              }
         ;

%%

int yyerror (char *s) {
    printf("ERRO SINTATICO %s \n", s);
    return 1;
}

int main() {
    yyparse();
    return 0;
}