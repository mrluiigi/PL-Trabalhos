#Programa awk relativo à primeira alínea
#Retira linhas vazias extra e as que tem todos os campos vazios

BEGIN 	{
			FS=";"
			RS="\n\n+"
		}


$0 !~/;{34}/	{
						if($1 == "") print "NIL" $0 "\n" >> "processado.txt"
						else print $0 "\n" > "processado.txt"
				}
