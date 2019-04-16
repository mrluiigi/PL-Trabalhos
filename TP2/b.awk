#O resultado não parece bem.
#Quais são as notas a pôr?
#O RS está a ";\n\n+" porque há pelo meio de records \n


BEGIN 	{
			FS=";"
			RS=";\n\n+"
			conta = 0;
		}


NR > 1 && $2 !~/""/		{
							print "Código: " $2 " Título: " $3 " Descrição: " $4 " Nota: " $27 "\n" ; 
							conta ++;
						}


END						{
							print "Existem " conta " registos que contém um Código";
						}