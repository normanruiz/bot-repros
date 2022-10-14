
require './files_bot/logger.rb'
require './files_bot/config.rb'
require './files_bot/source.rb'

class Bot
	include Logger
	include Config
	include Source

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
				unless aux_conf then
					@estado = false
				else
					@parametros = aux_conf.clone
					@estado = @parametros['status']
					unless @estado then
						mensaje = " #{'-' * 128}"
						puts(mensaje)
						escribir_log(mensaje, false)
						mensaje = "ALERTA - Ejecucion principal - BOT desactivado..."
						puts("  " + mensaje)
						escribir_log(mensaje)
					end
				end
			end

		buscar_candidatas(@parametros)

		rescue Exception => excepcion
			@estado = false
			mensaje = " #{'-' * 128}"
			puts(mensaje)
			escribir_log(mensaje, false)
			mensaje = "ERROR - Ejecucion principal - #{excepcion.message}"
			puts("  " + mensaje)
			escribir_log(mensaje)

		ensure
			unless @estado then
				mensaje = " #{'-' * 128}"
				puts(mensaje)
				escribir_log(mensaje, false)
				mensaje = "ALERTA - Ejecucion principal - Se detiene el proceso, no se ejecutaran mas acciones..."
				puts("  " + mensaje)
				escribir_log(mensaje)
			end
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
