CC = gcc
P1 = citacoes
P2 = proverbios

run:
	flex -o lex1.yy.c filtro1.l
	$(CC) lex1.yy.c -o $(P1) `pkg-config --cflags --libs glib-2.0`
	
	flex -o lex2.yy.c filtro2.l
	$(CC) lex2.yy.c -o $(P2) `pkg-config --cflags --libs glib-2.0`

clean: 
	rm -f lex1.yy.c
	rm -f lex2.yy.c
	rm -f citacoes
	rm -f proverbios
