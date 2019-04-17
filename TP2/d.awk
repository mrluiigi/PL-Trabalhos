BEGIN 		{
				FS=";"
				RS=";\n\n+"
					
				print "digraph{\n 	rankdir=LR;" > "d.dot"
				print "Código [style=filled, color=\".7 .3 1.0\"];" > "d.dot";

			}


NR > 1		{
				print "	\"Código\" ->" " \"" $2 "\";" > "d.dot";
				print "	\"" $2 "\" " "[style=filled, color=\".3 .4 .8\"];" > "d.dot";




				n = split($8, diplomasREF, "#\n");
				split(diplomasREF[1], primeiro, "\"");
				primeiroREF = substr(diplomasREF[1], 2);						
				if(primeiroREF != "") 	{
					print "	\"" primeiroREF "\" " "[style=filled, color=\"1.0 .6 1.0\"];" > "d.dot";
					print "	\"" $2 "\" ->"  " \"" primeiroREF "\";" > "d.dot";
				}
				for(i = 2; i < n; i++){
					if(diplomasREF[i] != "\n"){
						print "	\"" diplomasREF[i] "\" " "[style=filled, color=\"1.0 .6 1.0\"];" > "d.dot";
						print "	\"" $2 "\" ->"  " \"" diplomasREF[i] "\";" > "d.dot";
					}
				}



				if($9 != ""){
					print "	\"" $9 "\" " "[style=filled, color=\".5 .5 1.0\"];" > "d.dot";
					print "	\"" $2 "\" ->"  " \"" $9 "\";" > "d.dot";
				}				
			}



END			{
				print "}"	> "d.dot"
			}