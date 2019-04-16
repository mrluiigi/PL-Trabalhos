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
					if($1 == "") print "NIL" $0 "\n" >> "novo.txt"
					else print $0 "\n" > "novo.txt"
				}