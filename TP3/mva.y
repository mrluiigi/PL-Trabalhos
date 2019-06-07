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

 FILE* fileDescriptor = NULL;
 char* fileName = NULL;

%}

%union { char* VARNAME; int CONSTINT; char* string;}

%token ART

%token <string> VALOR
%token <string> PALAVRA



%%

MvA : Entidades                                                            

Entidades : Entidades Entidade
          | Entidade
          ;



Entidade : Artista                               
         ;

Artista : ART VALOR '{' ArtistaInfo '}'                                        {  asprintf(&fileName, "%s.html", $2);
                                                                                  printf("%s\n", $2);
                                                                                  fileDescriptor = fopen(fileName,"w");}
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
    printf("/*\n * @command = dot\n* @imageurl = TRUE\n *\n*/\ndigraph g {\n");
    yyparse();
    return 0;
}















