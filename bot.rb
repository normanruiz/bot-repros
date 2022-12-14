
require './files_bot/logger.rb'
require './files_bot/config.rb'
require './files_bot/source.rb'
require './files_bot/target.rb'
require './files_bot/filter.rb'
require './files_bot/action.rb'

class Bot
	include Logger
	include Config
	include Source
	include Target
	include Filter
	include Action

	attr_accessor :estado, :parametros, :terminales_candidatas, :terminales_miembro, :nuevo_lote

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
				aux_conf = cargar_configuracion()
				unless aux_conf then
					@estado = false
				else
					@parametros = aux_conf.clone()
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

			if @estado
				@terminales_candidatas = buscar_candidatas(@parametros)
				unless @terminales_candidatas then
					@estado = false
					mensaje = "ALERTA - Ejecucion principal - No se pudo completar la recoleccion de terminales candidatas..."
					puts("  " + mensaje)
					escribir_log(mensaje)
				end
			end

			if @estado
      	@terminales_miembro = buscar_miembros(@parametros)
        unless @terminales_miembro then
         	@estado = false
         	mensaje = "ALERTA - Ejecucion principal - No se pudo completar la recoleccion de terminales miembro..."
         	puts("  " + mensaje)
         	escribir_log(mensaje)
        end
			end

			if @estado
				@nuevo_lote = generar_nuevo_lote(@parametros, @terminales_candidatas, @terminales_miembro)
				unless @nuevo_lote then
					@estado = false
					mensaje = "ALERTA - Ejecucion principal - No se pudo completar la generacion del nuevo lote de terminales..."
					puts("  " + mensaje)
					escribir_log(mensaje)
				end
			end

			if @estado
				@estado = anexar_lote(@parametros, @nuevo_lote)
				unless @estado then
					mensaje = "ALERTA - Ejecucion principal - No se pudo completar la persistencia de datos..."
					puts("  " + mensaje)
					escribir_log(mensaje)
				end
			end

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
