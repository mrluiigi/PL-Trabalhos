# TP2
Trabalho Prático nº2 (GAWK)

## Relatorio
[Link do Relatório](https://www.overleaf.com/5756466445pjgxyrqqrwws)


## Executar ficheiro AWK
	gawk -f <Programa AWK> <Input>


### Alínea a)

	Ficheiro depois da limpeza chama-se "processado.txt"


### Alínea d)
	
	Aplicar o programa awk ao ficheiro processado.txt:

		$ gawk -f d.awk processado.txt
	

	Gerar o grafo (em DOT):
		$ dot -Tpdf d.dot > d.pdf


	Abrir d.pdf para visualizar o grafo.

##### Cores do grafo
	Verde -> Código
	Vermelho -> Diplomas jurídico-administrativos REF
	Azul claro -> Diplomas jurídico-administrativos complementar