require "to-arff/version"
require 'sqlite3'

module ToARFF

	class SQLiteDB

		attr_accessor :db_file_path, :db, :tables, :columns, :column_type

		def initialize(path, options={})
			@db_file_path = path
			@tables = options.fetch(:tables, Array.new)
			@columns = options.fetch(:columns, Hash.new)
			@column_type = options.fetch(:columns, Hash.new)
			process_db_file
		end

		def process_db_file
			if @db_file_path != ''
				if File.exist? "#{@db_file_path}"
					begin
						@db = SQLite3::Database.open "#{@db_file_path}"
					rescue SQLite3::Exception => e 
						puts "#{e}"
					end
				else
					raise "#{@db_file_path} doesn't exist. Enter a valid file path."
				end
			else
				raise "Database File Path cannot be empty."
			end
		end

		# Get all the tables' name and store them in an array (@tables).
		def set_all_tables
			begin
				tables_arr = @db.execute("SELECT name FROM sqlite_master WHERE type='table';")
				tables_arr.each do |elem|
					@tables.push(elem.first)
				end
			rescue SQLite3::Exception => e 
				puts "#{e}"
			end
		end

		# Get all colums for a given table.
		def get_columns(table_name)
			columns_arr = Array.new
			begin
		    pst = @db.prepare "SELECT * FROM #{table_name} LIMIT 6"
		    pst.columns.each do |c|
		    	columns_arr.push(c)
		    end
		  return columns_arr
			rescue SQLite3::Exception => e
			  puts e
			end
		end

		def set_all_columns
			if @tables.length == 0
				set_all_tables
			end
			@tables.each do |t|
				@columns[t] = get_columns(t)
			end
		end

		# If the column type is nominal return true.
		def is_numeric(table_name, column_name)
			begin
				if @db.execute("SELECT #{column_name} from #{table_name} LIMIT 1").first.first.is_a? Numeric
					return true
				else
					return false
				end
			rescue SQLite3::Exception => e
			  puts e
			end
		end

		def convert_table(table_name)
			puts "@RELATION #{table_name}\n\n"
			get_columns(table_name).each do |col|
				if is_numeric(table_name, col)
					puts "@ATTRIBUTE #{col} NUMERIC\n"
				else
					puts "@ATTRIBUTE #{col} NOMINAL\n"
				end
			end
			puts "\n@DATA"
			stm = @db.prepare "SELECT * FROM #{table_name}" 
	    rs = stm.execute    
	    rs.each do |row|
	      puts row.join ","
	    end
	    puts "\n\n"
		end

		def convert_all#(output_file_path)
			@tables.each do |t|
				convert_table(t)
			end
		end

	end
  
end
