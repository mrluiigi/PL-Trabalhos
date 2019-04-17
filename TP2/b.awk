#Quais são as notas a pôr? O com $27?
#O RS está a ";\n\n+" porque há pelo meio de records "\n"


BEGIN 	{
			FS=";"
			RS=";\n\n+"
			conta = 0;
		}


NR > 1 && $2 !~/""/		{
							print "\nCÓDIGO: " $2 "\nTÍTULO: " $3 "\nDESCRIÇÃO: " $4 "\nNOTA: " $27 ; 
							conta ++;
						}


END						{
							print "\n\nExistem " conta " registos que contém um Código";
						}