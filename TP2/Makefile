.PHONY : a b c d clean

a: a.awk formacao.txt
	gawk -f a.awk formacao.txt

b: b.awk processado.txt
	gawk -f b.awk processado.txt

c: c.awk processado.txt
	gawk -f c.awk processado.txt

d: d.awk processado.txt
	gawk -f d.awk processado.txt	
	dot -Tpdf d.dot > d.pdf

clean:
	rm -f processado.txt
	rm -f *.dot
	rm -f *.pdf