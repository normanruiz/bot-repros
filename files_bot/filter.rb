require './files_bot/logger.rb'

module Filter
	include Logger

	def generar_nuevo_lote(parametros, terminales_candidatas, terminales_miembro)
		nuevo_lote = {}
	    estado = true
	    contador_i = 0
	    contador_u = 0
	    contador_i1 = 0
	    contador_i2 = 0
	    contador_i3 = 0
		begin

			mensaje = " #{'-' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = "Generando nuevo lote de terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)

			terminales_candidatas.each_pair do |terminal, repros|
				if terminales_miembro.key?(terminal) then
					if terminales_miembro[terminales_candidatas][0] == 'U' then
						nuevo_lote[terminal] = ["u", resolicitar(terminal, terminales_miembro)]
						contador_u += 1
					else
						contador_i += 1
					end
				else
					prioridad = priorizar(parametros, repros)
                	nuevo_lote[terminal] = ["i", prioridad]
					case prioridad
						when 1 then contador_i1 += 1
						when 2 then contador_i2 += 1
						when 3 then contador_i3 += 1
					end
				end
			end

			mensaje = "Se genero un lote con: #{nuevo_lote.keys.length} terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)
	        mensaje = "Resolicitudes: #{contador_u} terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)
	        mensaje = "Prioridad 1: #{contador_i1} terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)
	        mensaje = "Prioridad 2: #{contador_i2} terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)
	        mensaje = "Prioridad 3: #{contador_i3} terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)
	        mensaje = "Ignoradas: #{contador_i} terminales..."
			puts("  " + mensaje)
			escribir_log(mensaje)

			mensaje = "Subproceso finalizado..."
			puts("  " + mensaje)
			escribir_log(mensaje)

		rescue Exception => excepcion
			estado = false
			mensaje = "ERROR - Procesando terminales candidatas - #{excepcion.message}}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			if estado then
				return nuevo_lote
			else
				return estado
			end
		end
	end

	def resolicitar(terminal_candidata, terminales_miembro)
        solicitudes = terminales_miembro[terminal_candidata][1] + 1
        return solicitudes
	end

	def priorizar(parametros, repros)
    	prioridad = 3
        prioridades = parametros["repros_prioridad"]
        repros.each do |repro|
			if prioridades.key?(repro) then
				if prioridades[repro] < prioridad then
                    prioridad = prioridades[repro]
				end
			end
		end
        return prioridad
	end
end
