BEGIN 	{
			FS=";"
			RS=";\n\n+"
			
		}


NR > 1	{
			contaTipos[$10]++;
		}

END		{
			print "Tipos de processo -> correspondestes ocorrências";
			for(tipo in contaTipos){
				print tipo " -> " contaTipos[tipo];
			}
		}