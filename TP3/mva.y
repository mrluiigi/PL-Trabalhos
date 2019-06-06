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
    char* id;
    GSList* listaAtributos;
 } ArtistaStruct;

 GSList* listaArtistas;

%}

%union { char VARNAME; int CONSTINT; char* string; ArtistaStruct  ARTST}

%token ART

%token <VARNAME> VALOR
%token <VARNAME> PALAVRA

%type <ARTST> Artista;

%%

MvA : Entidades                                                            

Entidades : Entidades Entidade
          | Entidade
          ;



Entidade : Artista                               
         ;

Artista : ART VALOR '{' ArtistaInfo '}'          {ArtistaStruct art = malloc(sizeof(struct artistaStruct)); $$ = art;}
        ;

ArtistaInfo : Atributos 
            ;

Atributos : Atributos Atributo
          |
          ;

Atributo : PALAVRA '=' VALOR
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