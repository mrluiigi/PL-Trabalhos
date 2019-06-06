mva: mva.l mva.y
	flex mva.l
	yacc -d mva.y
	gcc -o mva y.tab.c `pkg-config --cflags --libs glib-2.0`


	