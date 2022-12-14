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

	def ejecutar_insercion(conexion, consulta)
		resultado = false
		begin
			mensaje = "Insertando registro en base de datos..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			mensaje = "Insert: #{consulta}"
			escribir_log(mensaje)
			resultado = conexion.execute("SET ANSI_NULLS ON")
            resultado = conexion.execute("SET CURSOR_CLOSE_ON_COMMIT OFF")
            resultado = conexion.execute("SET ANSI_NULL_DFLT_ON ON")
            resultado = conexion.execute("SET IMPLICIT_TRANSACTIONS OFF")
            resultado = conexion.execute("SET ANSI_PADDING ON")
            resultado = conexion.execute("SET QUOTED_IDENTIFIER ON")
            resultado = conexion.execute("SET ANSI_WARNINGS ON")
            resultado = conexion.execute("SET CONCAT_NULL_YIELDS_NULL ON")
			resultado = conexion.execute(consulta)
			resultado.insert
		rescue Exception => excepcion
			mensaje = "ERROR - Insertando registro en base de datos - #{excepcion.message}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			return resultado
		end
	end

	def ejecutar_actualizacion(conexion, consulta)
		resultado = false
		begin
			mensaje = "Actualizando registro en base de datos..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			mensaje = "Update: #{consulta}"
			escribir_log(mensaje)
			resultado = conexion.execute("SET ANSI_NULLS ON")
			resultado = conexion.execute("SET CURSOR_CLOSE_ON_COMMIT OFF")
			resultado = conexion.execute("SET ANSI_NULL_DFLT_ON ON")
			resultado = conexion.execute("SET IMPLICIT_TRANSACTIONS OFF")
			resultado = conexion.execute("SET ANSI_PADDING ON")
			resultado = conexion.execute("SET QUOTED_IDENTIFIER ON")
			resultado = conexion.execute("SET ANSI_WARNINGS ON")
			resultado = conexion.execute("SET CONCAT_NULL_YIELDS_NULL ON")
			resultado = conexion.execute(consulta)
		rescue Exception => excepcion
			mensaje = "ERROR - Actualizando registro en base de datos - #{excepcion.message}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			return resultado
		end
	end

end
