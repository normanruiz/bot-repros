
require './files_bot/logger.rb'

class Bot
	include Logger

	attr_accessor :estado

	def run
		@estado = 0
		begin
		system('clear')
		verificar_log()
		puts("")
		puts(" " + "=" * 128)
		mensaje = "Iniciando Repro's Bot..."
		puts("  " + mensaje)
		escribir_log(mensaje)
		mensaje = " #{'~' * 128}"
		escribir_log(mensaje, false)
		puts(" " + "~" * 128)
		puts("")



		mensaje = " #{'~' * 128}"
		escribir_log(mensaje, false)
		puts(" " + "~" * 128)
		mensaje = "Finalizando Repro's Bot..."
		puts("  " + mensaje)
		escribir_log(mensaje)
		mensaje = " #{'=' * 128}"
		puts(mensaje)
		escribir_log(mensaje, false)
		puts("")

		rescue Excetion => excepcion
			@estado = 1
			puts("  #{Datetime.now.to_str} - ERROR - Ejecicion principal - #{excepcion.message}")
		ensure
			return @estado
		end

	end

end

bot = Bot.new
bot.run
