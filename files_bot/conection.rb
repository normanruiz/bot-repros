require './files_bot/logger.rb'
require 'tiny_tds'

module Conection
	include Logger

		def conectar(parametros, ubicacion)
			conexion = nil 
			begin
				mensaje = "Estableciendo conexion con la base de datos..."
				puts("  " + mensaje)
        escribir_log(mensaje)
				conexion = TinyTds::Client.new username: "#{parametros['data_conection'][ubicacion]['username']}", password: "#{parametros['data_conection'][ubicacion]['password']}", host: "#{parametros['data_conection'][ubicacion]['server']}", port: 1433, database: "#{parametros['data_conection'][ubicacion]['database']}"
			rescue Exception => excepcion
				mensaje = "ERROR - Conectando a base de datos - #{excepcion.message}"
				puts("  " + mensaje)
        escribir_log(mensaje)
			ensure
				return conexion
			end
	end

	def desconectar conexion
		estado = true
		begin
			mensaje = "Cerrando conexion con la base de datos..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			conexion.close
		rescue Exception => excepcion
			estado = false
			mensaje = "ERROR - Desconectando a base de datos - #{excepcion.message}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			return estado
		end
	end

	def ejecutar_consulta(conexion, consulta)
		resultado = false
		begin
			mensaje = "Consultando base de datos..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			resultado = conexion.execute(consulta)
		rescue Exception => excepcion
			mensaje = "ERROR - Consultando a base de datos - #{excepcion.message}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			return resultado
		end
	end
end

