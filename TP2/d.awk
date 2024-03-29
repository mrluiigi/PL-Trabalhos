BEGIN 		{
				FS=";"
				RS=";\n\n+"
					
				#rankdir = LR para que o grafo se faça da esquerda para a direita
				print "digraph{\n 	rankdir=LR;" > "d.dot"
			}


NR > 1		{
				print "	\"" $2 "\" " "[style=filled, color=\".3 .4 .8\"];" > "d.dot";


				#Separa todos os diplomas, estes estão entre "#"
				n = split($8, diplomasREF, "#\n");
				#Todos os diplomas estão entre aspas, logo isto faz com que se separe o primeiro diploma da primeira aspa.
				primeiroREF = substr(diplomasREF[1], 2);						
				if(primeiroREF != "") 	{
					print "	\"" primeiroREF "\" " "[style=filled, color=\"1.0 .6 1.0\"];" > "d.dot";
					print "	\"" $2 "\" ->"  " \"" primeiroREF "\";" > "d.dot";
				}
				#No ciclo só se percorre do campo 2 ao penúltimo, pois o ultimo é uma aspa também
				for(i = 2; i < n; i++){
					if(diplomasREF[i] != "\n"){
						print "	\"" diplomasREF[i] "\" " "[style=filled, color=\"1.0 .6 1.0\"];" > "d.dot";
						print "	\"" $2 "\" ->"  " \"" diplomasREF[i] "\";" > "d.dot";
					}
				}


				#Só para os registos que tem diplomas complementares
				if($9 != ""){
					print "	\"" substr($9, 1, length($9)-1) "\" " "[style=filled, color=\".5 .5 1.0\"];" > "d.dot";
					print "	\"" $2 "\" ->"  " \"" substr($9, 1, length($9)-1) "\";" > "d.dot";
				}				
			}



END			{
				print "}" > "d.dot"
			}


			