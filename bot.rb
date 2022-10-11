
require './files_bot/logger.rb'
require './files_bot/config.rb'

class Bot
	include Logger
	include Config

	attr_accessor :estado, :parametros

	def run
		@estado = true
		begin
			system('clear')
			
			if @estado 
				@estado = verificar_log()
			end
			
			puts("")
			mensaje = " #{'=' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = " Iniciando Repro's Bot..."
			puts(" " + mensaje)
			escribir_log(mensaje)
			mensaje = " #{'~' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			
			if @estado 
				aux_conf = cargar_configuracion
				if aux_conf.eql?(false) 
					@estado = false
				else
					@parametros = aux_conf.clone
				end
			end

		rescue Exception => excepcion
			@estado = 1
			mensaje = " #{'-' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = "ERROR - Ejecucion principal - #{excepcion.message}"
			puts("  " + mensaje)
			escribir_log(mensaje)

		ensure
			mensaje = " #{'~' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = "Finalizando Repro's Bot..."
			puts("  " + mensaje)
			escribir_log(mensaje)
			mensaje = " #{'=' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			puts("")
			return @estado
		end

	end

end

bot = Bot.new
bot.run
