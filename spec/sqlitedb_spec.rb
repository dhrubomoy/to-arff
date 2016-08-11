require 'spec_helper'

describe ToARFF::SQLiteDB do


	before(:each) do
	  @sdb1 = ToARFF::SQLiteDB.new "./spec/sample_db_files/sample1.db"
		@expected_columns = {"albums" => ["AlbumId", "Title", "ArtistId"],
												"employees" => ["EmployeeId", "LastName", "FirstName", "Title", "ReportsTo", "BirthDate", "HireDate", "Address", "City", "State", "Country", "PostalCode", "Phone", "Fax", "Email"],
												"invoices" => ["InvoiceId", "CustomerId", "InvoiceDate", "BillingAddress", "BillingCity", "BillingState", "BillingCountry", "BillingPostalCode", "Total"],
												"playlists" => ["PlaylistId", "Name"],
												"artists" => ["ArtistId", "Name"],
												"genres" => ["GenreId", "Name"], 
												"media_types" => ["MediaTypeId", "Name"],
												"tracks" => ["TrackId", "Name", "AlbumId", "MediaTypeId", "GenreId", "Composer", "Milliseconds", "Bytes", "UnitPrice"],
												"customers" => ["CustomerId", "FirstName", "LastName", "Company", "Address", "City", "State", "Country", "PostalCode", "Phone", "Fax", "Email", "SupportRepId"],
												"invoice_items" => ["InvoiceLineId", "InvoiceId", "TrackId", "UnitPrice", "Quantity"],
												"playlist_track" => ["PlaylistId", "TrackId"],
												"sqlite_sequence" => ["name", "seq"],
												"sqlite_stat1" => ["tbl", "idx", "stat"]
											}
  	@expected_tables = @expected_columns.keys
	end

	describe "set_all_tables" do
	  it '@tables instance variable should store all the table names as array.' do
	  	@sdb1.set_all_tables
	  	expect(@sdb1.tables).to match_array @expected_tables
	  end
	end

	describe "set_all_columns" do
		context "should set all columns of all tables." do
			it "@columns hash should contain all the table names as keys." do
				@sdb1.set_all_columns
				expect(@sdb1.columns.keys).to match_array @expected_columns.keys
				#puts @sdb1.columns
			end

			it "@columns[:table] should store all the column names as array of strings." do
				@sdb1.set_all_columns
				@expected_tables.each do |t|
					expect(@sdb1.columns[t]).to match_array @expected_columns[t]
				end
			end
		end
	end

	describe 

	describe "get_columns(table_name)" do
		it "should return all columns of a given table." do
			expected_result1 = ["AlbumId", "Title", "ArtistId"]
			expected_result2 = ["EmployeeId", "LastName", "FirstName", "Title", "ReportsTo", "BirthDate", "HireDate", "Address", "City", "State", "Country", "PostalCode", "Phone", "Fax", "Email"]
			expected_result3 = ["InvoiceId", "CustomerId", "InvoiceDate", "BillingAddress", "BillingCity", "BillingState", "BillingCountry", "BillingPostalCode", "Total"]
			expect(@sdb1.get_columns("albums")).to match_array expected_result1
			expect(@sdb1.get_columns("employees")).to match_array expected_result2
			expect(@sdb1.get_columns("invoices")).to match_array expected_result3
		end
	end

end