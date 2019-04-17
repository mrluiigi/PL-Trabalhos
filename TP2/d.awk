BEGIN 		{
				FS=";"
				RS=";\n\n+"
					
				print "digraph{" > "d.dot"

			}


NR > 1		{
				print "	\"Código\" ->" " \"" $2 "\";" > "d.dot";

				n = split($8, diplomas, "#\n");
				split(diplomas[1], primeiro, "\"");								
				print "	\"" $2 "\" ->"  " \"" primeiro[2] "\";" > "d.dot";
				for(i = 2; i < n; i++){
					print "	\"" $2 "\" ->"  " \"" diplomas[i] "\";" > "d.dot";
				}

			}



END			{
				print "}"	> "d.dot"
			}