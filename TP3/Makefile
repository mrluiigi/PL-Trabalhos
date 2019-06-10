mva: mva.l mva.y
	flex mva.l
	yacc -d mva.y
	gcc -o mva y.tab.c `pkg-config --cflags --libs glib-2.0`

run: 
	./mva < teste.txt > graph.txt
	dot -Tsvg graph.txt > mva.svg
	
open:
	xdg-open mva.svg

clean:
	rm -f HTML/*.html
	rm -f y.tab.c
	rm -f y.tab.h
	rm -f mva
	rm -f lex.yy.c
	rm -f graph.txt
	rm -f mva.svg