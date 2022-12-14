require './files_bot/logger.rb'
require './files_bot/conection.rb'

module Target
	include Logger
	include Conection

	def buscar_miembros(parametros)
		estado = true
		destino = 'data_destiny'
		consulta = "#{parametros['data_conection'][destino]['query']}"
		origen_datos = nil
		terminales_miembro = Hash.new
		estados = ['Solicitado', 'Fallido']

		begin
			mensaje = " #{'-' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = "Recolectando terminales miembro..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			origen_datos = conectar(parametros, destino)
			unless origen_datos.nil?
				resultado = ejecutar_consulta(origen_datos, consulta)
				resultado.each do |registro|
					t, s, e = registro.values
					if estados.include?(e) then
						a = 'u'
					else
						a = 'i'
					end
					terminales_miembro[t] = [a, s]
				end
				mensaje = "Terminales miembro detectadas: #{terminales_miembro.keys.length}"
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
			mensaje = "ERROR - Procesando terminales miembro - #{excepcion.message}}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
      unless origen_datos.closed? then
				desconectar(origen_datos)
			end
			if estado then
				return terminales_miembro
			else
				return estado
			end
		end
	end
end
