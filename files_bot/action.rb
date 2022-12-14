require './files_bot/logger.rb'
require './files_bot/conection.rb'

module Action
	include Logger
	include Conection

    def anexar_lote(parametros, nuevo_lote)
        estado = true
        count_i = 0
        count_u = 0
        cant_hilos = parametros["max_multithread"]
		destino = "data_destiny"
		nonquery_i = parametros["data_conection"][destino]["nonquery_i"]
		nonquery_u = parametros["data_conection"][destino]["nonquery_u"]
		threads = []
        begin
            mensaje = " #{'-' * 128}"
            puts(mensaje)
            escribir_log(mensaje, false)
            mensaje = "Persistiendo datos del nuevo lote..."
            puts("  " + mensaje)
            escribir_log(mensaje)
            mensaje = "Nonquery insert: #{nonquery_i}"
            puts("  " + mensaje)
            escribir_log(mensaje)
            mensaje = "Nonquery update: #{nonquery_u}"
            puts("  " + mensaje)
            escribir_log(mensaje)
            mensaje = "Comenzando escritura de datos..."
            puts("  " + mensaje)
            escribir_log(mensaje)

            trabajos = nuevo_lote.keys.length

            if trabajos % cant_hilos != 0 then
                trabajos += cant_hilos
				trabajos /= cant_hilos
            end

			cant_hilos.times do | contador |
				hilo = "Thread #{contador.to_s}"
				sublote = generar_sublote(hilo, contador, trabajos, nuevo_lote)
				threads.append( Thread.new { persisitir(hilo, parametros, sublote) } )
			end

			threads.each { |thread| thread.join }

            mensaje = "Subproceso finalizado..."
            puts("  " + mensaje)
            escribir_log(mensaje)

        rescue Exception => excepcion
            estado = false
            mensaje = "ERROR - Anexando nuevo lote - #{excepcion.message}}"
            puts("  " + mensaje)
            escribir_log(mensaje)
        ensure
            return estado
        end
    end

	def generar_sublote(hilo, contador, trabajos, nuevo_lote)
		estado = true
		sublote = {}
		keys_aux = []
		aux = []

		begin
			if contador > 0 then
				contador *= trabajos
			end
			keys_aux = nuevo_lote.keys
			aux = keys_aux.slice(contador, trabajos)
			sublote = nuevo_lote.select { |k,v| aux.include?(k) }
			mensaje = "#{hilo} - Sublote generado: #{sublote}"
			escribir_log(mensaje)

		rescue Exception => excepcion
			estado = false
			mensaje = "ERROR - Generando sublote - #{excepcion.message}}"
			puts("  " + mensaje)
			escribir_log(mensaje)

		ensure
			if estado then
				return sublote
			else
				return estado
			end

		end

	end

	def persisitir(hilo, parametros, sublote)
		estado = true
		consulta = nil
		destino = "data_destiny"
		nonquery_i = parametros["data_conection"][destino]["nonquery_i"]
		nonquery_u = parametros["data_conection"][destino]["nonquery_u"]
		destino_datos = nil
		begin
			destino_datos = conectar(parametros, destino)
			unless destino_datos.nil?

				sublote.each_pair do |k,v|
					consulta = case v[0]
					when 'u'
						update = nonquery_u.sub("{terminal}", k)
						ejecutar_actualizacion(destino_datos, update)
		    			mensaje = "#{hilo} - Ejecutando update: #{update}"
						escribir_log(mensaje)
					when 'i'
						insert = nonquery_i.sub("{terminal}", k)
						insert = insert.sub("{prioridad}", v[1].to_s)
						ejecutar_insercion(destino_datos, insert)
						mensaje = "#{hilo} - Ejecutando insert: #{insert}"
						escribir_log(mensaje)
					end

				end
			else
				estado = false
			end

		rescue Exception => excepcion
			estado = false
			mensaje = "ERROR - Persistiendo datos del nuevo lote - #{excepcion.message}}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			unless destino_datos.closed? then
				desconectar(destino_datos)
			end
		  	return estado
		end
	end

end
