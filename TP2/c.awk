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
				if(tipo != ""){
					print tipo " -> " contaTipos[tipo];
				}
				else {
					print "Sem tipo -> " contaTipos[tipo];
				}
			}
		}