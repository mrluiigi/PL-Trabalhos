#Programa awk relativo à primeira alínea
#Retira linhas vazias extra e as que tem todos os campos vazios
#A ação correspondente ao pattern NR == 1 serve para por num ficheiro quais os campos de cada record

BEGIN 	{
			FS=";"
			RS="\n\n+"
		}


NR == 1 	{
				for(i = 1; i <= NF; i++){
					print i "->" $i > "meta.txt"
				}
			}

$0 !~/;{34}/	{
						if($1 == "") print "NIL" $0 "\n" >> "processado.txt"
						else print $0 "\n" > "processado.txt"
				}
