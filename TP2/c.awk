BEGIN 	{
			FS=";"
			RS=";\n\n+"
			
		}


NR > 1	{
			contaTipos[$10]++;
		}

END		{
			print "Tipo de processo -> número de processos correspondestes";
			for(tipo in contaTipos){
				print tipo " -> " contaTipos[tipo];
			}
		}