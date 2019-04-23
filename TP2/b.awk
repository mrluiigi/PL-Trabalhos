#Quais são as notas a pôr? O com $27?
#O RS está a ";\n\n+" porque há pelo meio de records "\n"


BEGIN 	{
			FS=";"
			RS=";\n\n+"
			conta = 0;
		}

#Começa depois do registo 1 porque este apenas contém a informação dos campos de cada registo.
NR > 1 && $2 !~/""/		{
							print "\nCÓDIGO: " $2 "\nTÍTULO: " $3 "\nDESCRIÇÃO: " $4 "\nNOTAS: " $27 ; 
							
							conta ++;
						}


END						{
							print "\n\nExistem " conta " registos que contém um Código";
						}