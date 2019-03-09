CC = gcc

program:
	flex filtro1.l
	$(CC) -o citacoes lex.yy.c `pkg-config --cflags --libs glib-2.0`

clear: 
	rm -f lex.yy.c
	rm -f filtro