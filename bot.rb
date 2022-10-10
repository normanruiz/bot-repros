class Bot
	attr_accessor :estado
	def run
		@estado = 0
		system('clear') 
		puts("")
		puts(" " + "=" * 128)
		mensaje = "Iniciando Repro's Bot..." 
		puts("  " + mensaje)
		mensaje = " #{'~' * 128}"
		puts(mensaje)
		puts("")

		mensaje = " #{'~' * 128}"
		puts(mensaje)
		mensaje = "Finalizando Repro's Bot..."
		puts("  " + mensaje)
		mensaje = " #{'=' * 128}"
		puts(mensaje)
		puts("")
	end
end

bot = Bot.new
bot.run
