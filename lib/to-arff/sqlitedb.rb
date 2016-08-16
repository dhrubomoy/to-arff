require "to-arff/version"
require 'sqlite3'

module ToARFF

  RELATION_MARKER = '@RELATION'
  ATTRIBUTE_MARKER = '@ATTRIBUTE'
	DATA_MARKER = '@DATA'

	ATTRIBUTE_TYPE_NUMERIC = 'NUMERIC'
	ATTRIBUTE_TYPE_STRING = 'STRING'


	class SQLiteDB

		attr_accessor :db_file_path, :db, :tables, :columns, :column_type

		def initialize(path)
			@db_file_path = path
			@tables = Array.new
			@columns = Hash.new
			@column_type = Hash.new
			process_db_file
			set_all_tables
			set_all_columns
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
		  columns_arr
			rescue SQLite3::Exception => e
			  puts e
			end
		end

		def set_all_columns
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

		# Converts a table to ARFF.
		def convert_table(table_name)
	  	convert_table_with_columns(table_name, get_columns(table_name))
		end

		def convert_table_with_columns(table_name, columns)
			rel = "#{RELATION_MARKER} #{table_name}\n\n"
			columns.each do |col|
				if is_numeric(table_name, col)
					rel << "#{ATTRIBUTE_MARKER} #{col} #{ATTRIBUTE_TYPE_NUMERIC}\n"
				else
					rel << "#{ATTRIBUTE_MARKER} #{col} #{ATTRIBUTE_TYPE_STRING}\n"
				end
			end
			columns_str = ""
			columns.each do |col|
				columns_str += col + ", "
			end
			columns_str = columns_str.chomp(", ")
			rel << "\n#{DATA_MARKER}\n"
			data = @db.prepare "SELECT #{columns_str} FROM #{table_name}" 
			data.each do |elem|
				row = ""
				elem.each do |val|
					if val.is_a? Numeric
						row = row + "#{val}" + ","
					else
						row = row + "\"#{val}\"" + ","
					end
				end
				rel << row.strip.chomp(",")
				rel << "\n"
			end
			rel << "\n\n\n"
	    rel
		end

		def convert_from_columns_hash(cols_hash)
			rel = ""
			cols_hash.keys.each do |table|
				rel << convert_table_with_columns(table, cols_hash[table])
			end
			rel
		end

		def check_given_tables_validity(given_tables)
			dif = downcase_array(given_tables) - downcase_array(@tables)
			if !dif.empty?		# If @tables doesn't contain all elements of given_tables
				raise ArgumentError.new("#{dif.first} does not exist.")
			end
		end

		def check_given_columns_validity(given_columns)
			given_tables = given_columns.keys
			check_given_tables_validity(given_tables)
			given_tables.each do |elem|
				dif = downcase_array(given_columns[elem]) - downcase_array(@columns[elem])
				if !dif.empty?		# If @tables doesn't contain all elements of given_tables
					raise ArgumentError.new("#{dif.first} does not exist.")
				end
			end
		end

		def downcase_array(arr)
			downcased_array = Array.new
			arr.each do |elem|
				downcased_array.push(elem.downcase)
			end
			downcased_array
		end

		def convert(options={})
			temp_tables = options.fetch(:tables, Array.new)
			temp_columns = options.fetch(:columns, Hash.new)
			temp_column_types = options.fetch(:column_types, Hash.new)
			res = ""
			if options.keys.empty?
				@tables.each do |t|
					res << convert_table(t)
				end
			end
			if options.keys.length == 1
				if options.keys.first.to_s != "tables" && options.keys.first.to_s != "columns" && options.keys.first.to_s != "column_types"
					raise ArgumentError.new("Wrong parameter name \":#{options.keys.first.to_s}\"")
				else
					if !temp_tables.empty?
						check_given_tables_validity(temp_tables)
						temp_tables.each do |t|
							res << convert_table(t)
						end
					end
					if !temp_columns.keys.empty?
						check_given_columns_validity(temp_columns)
						res << convert_from_columns_hash(temp_columns)
					end
					if !temp_column_types.empty?
						check_given_columns_validity(temp_column_types)
						#PENDING...
					end
				end
			end
			if options.keys.length > 1
				raise ArgumentError.new("You can specify only one out of the three parameters: table, columns, column_types.")
			end
			res
		end

	end
  
end
