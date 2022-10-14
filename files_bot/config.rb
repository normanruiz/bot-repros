require './files_bot/logger.rb'
require 'json'

module Config
	include Logger

	def cargar_configuracion
		estado = true
		parametros = Hash.new
		carpeta_config = File.join('.')
		archivo_config = 'config.json'
		begin
			mensaje = "Cargando configuracion..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			if verificar_archivo(carpeta_config, archivo_config)
				parametros = cargar_archivo(carpeta_config, archivo_config)
				mensaje = "Configuracion cargada correctamente..."
				puts("  " + mensaje)
				escribir_log(mensaje)
				mensaje = "Subproceso finalizado..."
				puts("  " + mensaje)
				escribir_log(mensaje)
			else
				mensaje = "No se pudo configurar el bot..."
				puts("  " + mensaje)
				escribir_log(mensaje)
				estado = false
			end
		rescue Exception => excepcion
			estado = false
			mensaje = "ERROR - Cargando configuracion - #{excepcion.message}}"
			puts("  " + mensaje)
			escribir_log(mensaje)
		ensure
			if estado 
				return parametros
			else 
				return estado
			end
		end
	end

	private
	def verificar_archivo(carpeta_config, archivo_config)
		estado = false
		if File.file?(File.join(carpeta_config, archivo_config))
			estado = true
		end
		estado	
	end

	def cargar_archivo(carpeta_config, archivo_config)
		archivo_config = File.open(File.join(carpeta_config, archivo_config))
		parametros = JSON.parse(archivo_config.read)
		return parametros
	end

end


