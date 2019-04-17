BEGIN 		{
				FS=";"
				RS=";\n\n+"

				print "digraph{" > "donos.dot"
			}


#Serve para por num ficheiro quais os campos de cada record
NR == 1 	{
				for(i = 1; i <= NF; i++){
					print i "->" $i > "meta.txt"
				}
			}


NR > 1		{
				if($18 != "") dimensao[$18]++;
			}



NR > 1		{
				n = split($12, donos, "#");
				if(n <= 2){
					if( donos[1] != "") print "	\"" donos[1] "\" -> " "\"" $2 "\"" > "donos.dot";
				}
				else{
					dono1 = substr(donos[1], 2);						
					if(dono1 != "")	
						print "	\"" dono1 "\" -> " "\"" $2 "\"" > "donos.dot";
					for(i = 2; i < n; i++){
						if(donos[i] != ""){
							print "	\"" donos[i] "\" -> " "\"" $2 "\"" > "donos.dot";
						}
					}
				}
			}



END			{
				for(dim in dimensao){
					print dimensao[dim] " processos com dimensão qualitativa " dim;
				}


				print "}" > "donos.dot";

			}