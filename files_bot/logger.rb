
require 'date'

module Logger
	def verificar_log
		estado = true
		fecha = Date.today
		carpeta_log = File.join('.', 'files_log')
		archivo_log = "log-#{fecha}.txt"
		begin
			if File.directory?(carpeta_log)
				unless File.file?(File.join(carpeta_log, archivo_log)) then
					crear_archivo(carpeta_log, archivo_log)
				end
			else
				Dir.mkdir(carpeta_log)
				crear_archivo(carpeta_log, archivo_log)
			end
		rescue Exception => excepcion
			estado = false
			puts("  #{DateTime.now} - ERROR - Escribiendo log - #{excepcion.message}")
		ensure
			return estado
		end
	end

	def escribir_log(linea, tiempo = true)
		estado = true
		fecha = Date.today
		hora = DateTime.now.strftime('%T')
		carpeta_log = File.join('.', 'files_log')
		archivo_log = "log-#{fecha}.txt"
		begin
			file_log = File.open(File.join(carpeta_log, archivo_log), 'a')
			if tiempo
				file_log.write("  #{hora} - #{linea}\n")
			else
				file_log.write("#{linea}\n")
			end
			file_log.close()
		rescue Exception => excepcion
			estado = false
			puts("  #{DateTime.now} - ERROR - Escribiendo log - #{excepcion.message}")
		ensure
			return estado
		end
	end

	private
	def crear_archivo(carpeta_log, archivo_log)
		file_log = File.new(File.join(carpeta_log, archivo_log), 'w')
		file_log.write(" " + "=" * 128 + "\n")
		file_log.write("  #{DateTime.now} - Archivo de log generado\n")
		#file_log.write(" " + "~" * 128 + "\n")
		file_log.close()
	end
end
