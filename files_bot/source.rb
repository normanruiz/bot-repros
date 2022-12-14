require './files_bot/logger.rb'
require './files_bot/conection.rb'

module Source
	include Logger
	include Conection

	def buscar_candidatas(parametros)
		estado = true
		destino = 'data_source'
		consulta = "#{parametros['data_conection'][destino]['query']}"
		origen_datos = nil
		terminales_candidatas = Hash.new

		begin
			mensaje = " #{'-' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = "Recolectando terminales candidatas..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			origen_datos = conectar(parametros, destino)
			unless origen_datos.nil?
				resultado = ejecutar_consulta(origen_datos, consulta)
				resultado.each do |registro|
					key, value = registro.values
					key.strip!
					value.strip!
					if terminales_candidatas.key?(key) then
						terminales_candidatas[key].push(value)
					else
						terminales_candidatas[key] = Array.new
						terminales_candidatas[key].push(value)
					end
				end
				mensaje = "Terminales detectadas: #{terminales_candidatas.keys.length}"
				puts("  " + mensaje)
				escribir_log(mensaje)
				mensaje = "Repros pendientes detectadas: #{recuento_repros(terminales_candidatas)}"
				puts("  " + mensaje)
				escribir_log(mensaje)
				desconectar(origen_datos)

				mensaje = "Subproceso finalizado..."
				puts("  " + mensaje)
				escribir_log(mensaje)
			else
				estado = false
			end
		rescue Exception => excepcion
			estado = false
			mensaje = "ERROR - Procesando terminales candidatas - #{excepcion.message}}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
      unless origen_datos.closed? then
				desconectar(origen_datos)
			end
			if estado then
				return terminales_candidatas
			else
				return estado
			end
		end
	end

	def recuento_repros terminales_candidatas
		contador = 0
		terminales_candidatas.each do |k,v|
			contador += v.length
		end
		return contador
	end

end
