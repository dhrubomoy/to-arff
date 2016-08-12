require 'spec_helper'

describe ToARFF::SQLiteDB do


	before(:each) do
	  @sdb1 = ToARFF::SQLiteDB.new "./spec/sample_db_files/sample1.db"
	  @sdb2 = ToARFF::SQLiteDB.new "./spec/sample_db_files/sample2.db"
		@expected_columns_sdb1 = {"albums" => ["AlbumId", "Title", "ArtistId"],
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
		@expected_columns_sdb2 = {"albums" => ["AlbumId", "Title", "ArtistId"],
												"employees" => ["EmployeeId", "LastName", "FirstName", "Title", "ReportsTo", "BirthDate", "HireDate", "Address", "City", "State", "Country", "PostalCode", "Phone", "Fax", "Email"],
												"sqlite_sequence" => ["name", "seq"]
												}
		@expected_tables_sdb1 = @expected_columns_sdb1.keys
		@expected_tables_sdb2 = @expected_columns_sdb2.keys
		@expected_arff_albums_sdb2 = "@RELATIONalbums@ATTRIBUTEAlbumIdNUMERIC@ATTRIBUTETitleSTRING@ATTRIBUTEArtistIdNUMERIC@DATA1,\"ForThoseAboutToRockWeSaluteYou\",12,\"BallstotheWall\",23,\"RestlessandWild\",24,\"LetThereBeRock\",15,\"BigOnes\",36,\"JaggedLittlePill\",47,\"Facelift\",58,\"Warner25Anos\",69,\"PlaysMetallicaByFourCellos\",710,\"Audioslave\",8"
		@expected_arff_albums_sdb2_w_cols = "@RELATIONalbums@ATTRIBUTEAlbumIdNUMERIC@ATTRIBUTETitleSTRING@DATA1,\"ForThoseAboutToRockWeSaluteYou\"2,\"BallstotheWall\"3,\"RestlessandWild\"4,\"LetThereBeRock\"5,\"BigOnes\"6,\"JaggedLittlePill\"7,\"Facelift\"8,\"Warner25Anos\"9,\"PlaysMetallicaByFourCellos\"10,\"Audioslave\""
		@expected_arff_employees_sdb2 = "@RELATIONemployees@ATTRIBUTEEmployeeIdNUMERIC@ATTRIBUTELastNameSTRING@ATTRIBUTEFirstNameSTRING@ATTRIBUTETitleSTRING@ATTRIBUTEReportsToSTRING@ATTRIBUTEBirthDateSTRING@ATTRIBUTEHireDateSTRING@ATTRIBUTEAddressSTRING@ATTRIBUTECitySTRING@ATTRIBUTEStateSTRING@ATTRIBUTECountrySTRING@ATTRIBUTEPostalCodeSTRING@ATTRIBUTEPhoneSTRING@ATTRIBUTEFaxSTRING@ATTRIBUTEEmailSTRING@DATA1,\"Adams\",\"Andrew\",\"GeneralManager\",\"\",\"1962-02-1800:00:00\",\"2002-08-1400:00:00\",\"11120JasperAveNW\",\"Edmonton\",\"AB\",\"Canada\",\"T5K2N1\",\"+1(780)428-9482\",\"+1(780)428-3457\",\"andrew@chinookcorp.com\"2,\"Edwards\",\"Nancy\",\"SalesManager\",1,\"1958-12-0800:00:00\",\"2002-05-0100:00:00\",\"8258AveSW\",\"Calgary\",\"AB\",\"Canada\",\"T2P2T3\",\"+1(403)262-3443\",\"+1(403)262-3322\",\"nancy@chinookcorp.com\"3,\"Peacock\",\"Jane\",\"SalesSupportAgent\",2,\"1973-08-2900:00:00\",\"2002-04-0100:00:00\",\"11116AveSW\",\"Calgary\",\"AB\",\"Canada\",\"T2P5M5\",\"+1(403)262-3443\",\"+1(403)262-6712\",\"jane@chinookcorp.com\"4,\"Park\",\"Margaret\",\"SalesSupportAgent\",2,\"1947-09-1900:00:00\",\"2003-05-0300:00:00\",\"68310StreetSW\",\"Calgary\",\"AB\",\"Canada\",\"T2P5G3\",\"+1(403)263-4423\",\"+1(403)263-4289\",\"margaret@chinookcorp.com\"5,\"Johnson\",\"Steve\",\"SalesSupportAgent\",2,\"1965-03-0300:00:00\",\"2003-10-1700:00:00\",\"7727B41Ave\",\"Calgary\",\"AB\",\"Canada\",\"T3B1Y7\",\"1(780)836-9987\",\"1(780)836-9543\",\"steve@chinookcorp.com\"6,\"Mitchell\",\"Michael\",\"ITManager\",1,\"1973-07-0100:00:00\",\"2003-10-1700:00:00\",\"5827BownessRoadNW\",\"Calgary\",\"AB\",\"Canada\",\"T3B0C5\",\"+1(403)246-9887\",\"+1(403)246-9899\",\"michael@chinookcorp.com\"7,\"King\",\"Robert\",\"ITStaff\",6,\"1970-05-2900:00:00\",\"2004-01-0200:00:00\",\"590ColumbiaBoulevardWest\",\"Lethbridge\",\"AB\",\"Canada\",\"T1K5N8\",\"+1(403)456-9986\",\"+1(403)456-8485\",\"robert@chinookcorp.com\"8,\"Callahan\",\"Laura\",\"ITStaff\",6,\"1968-01-0900:00:00\",\"2004-03-0400:00:00\",\"9237STNW\",\"Lethbridge\",\"AB\",\"Canada\",\"T1H1Y8\",\"+1(403)467-3351\",\"+1(403)467-8772\",\"laura@chinookcorp.com\""
		@expected_arff_genres_sdb1 = "@RELATIONgenres@ATTRIBUTEGenreIdNUMERIC@ATTRIBUTENameSTRING@DATA1,\"Rock\"2,\"Jazz\"3,\"Metal\"4,\"Alternative&Punk\"5,\"RockAndRoll\"6,\"Blues\"7,\"Latin\"8,\"Reggae\"9,\"Pop\"10,\"Soundtrack\"11,\"BossaNova\"12,\"EasyListening\"13,\"HeavyMetal\"14,\"R&B/Soul\"15,\"Electronica/Dance\"16,\"World\"17,\"HipHop/Rap\"18,\"ScienceFiction\"19,\"TVShows\"20,\"SciFi&Fantasy\"21,\"Drama\"22,\"Comedy\"23,\"Alternative\"24,\"Classical\"25,\"Opera\""
		@expected_arff_sdb2_all_tables = "@RELATIONalbums@ATTRIBUTEAlbumIdNUMERIC@ATTRIBUTETitleSTRING@ATTRIBUTEArtistIdNUMERIC@DATA1,\"ForThoseAboutToRockWeSaluteYou\",12,\"BallstotheWall\",23,\"RestlessandWild\",24,\"LetThereBeRock\",15,\"BigOnes\",36,\"JaggedLittlePill\",47,\"Facelift\",58,\"Warner25Anos\",69,\"PlaysMetallicaByFourCellos\",710,\"Audioslave\",8@RELATIONsqlite_sequence@ATTRIBUTEnameSTRING@ATTRIBUTEseqNUMERIC@DATA\"albums\",10\"employees\",8@RELATIONemployees@ATTRIBUTEEmployeeIdNUMERIC@ATTRIBUTELastNameSTRING@ATTRIBUTEFirstNameSTRING@ATTRIBUTETitleSTRING@ATTRIBUTEReportsToSTRING@ATTRIBUTEBirthDateSTRING@ATTRIBUTEHireDateSTRING@ATTRIBUTEAddressSTRING@ATTRIBUTECitySTRING@ATTRIBUTEStateSTRING@ATTRIBUTECountrySTRING@ATTRIBUTEPostalCodeSTRING@ATTRIBUTEPhoneSTRING@ATTRIBUTEFaxSTRING@ATTRIBUTEEmailSTRING@DATA1,\"Adams\",\"Andrew\",\"GeneralManager\",\"\",\"1962-02-1800:00:00\",\"2002-08-1400:00:00\",\"11120JasperAveNW\",\"Edmonton\",\"AB\",\"Canada\",\"T5K2N1\",\"+1(780)428-9482\",\"+1(780)428-3457\",\"andrew@chinookcorp.com\"2,\"Edwards\",\"Nancy\",\"SalesManager\",1,\"1958-12-0800:00:00\",\"2002-05-0100:00:00\",\"8258AveSW\",\"Calgary\",\"AB\",\"Canada\",\"T2P2T3\",\"+1(403)262-3443\",\"+1(403)262-3322\",\"nancy@chinookcorp.com\"3,\"Peacock\",\"Jane\",\"SalesSupportAgent\",2,\"1973-08-2900:00:00\",\"2002-04-0100:00:00\",\"11116AveSW\",\"Calgary\",\"AB\",\"Canada\",\"T2P5M5\",\"+1(403)262-3443\",\"+1(403)262-6712\",\"jane@chinookcorp.com\"4,\"Park\",\"Margaret\",\"SalesSupportAgent\",2,\"1947-09-1900:00:00\",\"2003-05-0300:00:00\",\"68310StreetSW\",\"Calgary\",\"AB\",\"Canada\",\"T2P5G3\",\"+1(403)263-4423\",\"+1(403)263-4289\",\"margaret@chinookcorp.com\"5,\"Johnson\",\"Steve\",\"SalesSupportAgent\",2,\"1965-03-0300:00:00\",\"2003-10-1700:00:00\",\"7727B41Ave\",\"Calgary\",\"AB\",\"Canada\",\"T3B1Y7\",\"1(780)836-9987\",\"1(780)836-9543\",\"steve@chinookcorp.com\"6,\"Mitchell\",\"Michael\",\"ITManager\",1,\"1973-07-0100:00:00\",\"2003-10-1700:00:00\",\"5827BownessRoadNW\",\"Calgary\",\"AB\",\"Canada\",\"T3B0C5\",\"+1(403)246-9887\",\"+1(403)246-9899\",\"michael@chinookcorp.com\"7,\"King\",\"Robert\",\"ITStaff\",6,\"1970-05-2900:00:00\",\"2004-01-0200:00:00\",\"590ColumbiaBoulevardWest\",\"Lethbridge\",\"AB\",\"Canada\",\"T1K5N8\",\"+1(403)456-9986\",\"+1(403)456-8485\",\"robert@chinookcorp.com\"8,\"Callahan\",\"Laura\",\"ITStaff\",6,\"1968-01-0900:00:00\",\"2004-03-0400:00:00\",\"9237STNW\",\"Lethbridge\",\"AB\",\"Canada\",\"T1H1Y8\",\"+1(403)467-3351\",\"+1(403)467-8772\",\"laura@chinookcorp.com\""
		@expected_arff_columns_sdb2_param1 = "@RELATIONalbums@ATTRIBUTEAlbumIdNUMERIC@ATTRIBUTETitleSTRING@DATA1,\"ForThoseAboutToRockWeSaluteYou\"2,\"BallstotheWall\"3,\"RestlessandWild\"4,\"LetThereBeRock\"5,\"BigOnes\"6,\"JaggedLittlePill\"7,\"Facelift\"8,\"Warner25Anos\"9,\"PlaysMetallicaByFourCellos\"10,\"Audioslave\"@RELATIONemployees@ATTRIBUTEEmployeeIdNUMERIC@ATTRIBUTELastNameSTRING@ATTRIBUTECitySTRING@DATA1,\"Adams\",\"Edmonton\"2,\"Edwards\",\"Calgary\"3,\"Peacock\",\"Calgary\"4,\"Park\",\"Calgary\"5,\"Johnson\",\"Calgary\"6,\"Mitchell\",\"Calgary\"7,\"King\",\"Lethbridge\"8,\"Callahan\",\"Lethbridge\""
		@expected_arff_columns_sdb2_param2 = "@RELATIONalbums@ATTRIBUTEAlbumIdNUMERIC@ATTRIBUTETitleSTRING@DATA1,\"ForThoseAboutToRockWeSaluteYou\"2,\"BallstotheWall\"3,\"RestlessandWild\"4,\"LetThereBeRock\"5,\"BigOnes\"6,\"JaggedLittlePill\"7,\"Facelift\"8,\"Warner25Anos\"9,\"PlaysMetallicaByFourCellos\"10,\"Audioslave\""
	end

	describe "set_all_tables" do
	  it '@tables instance variable should store all the table names as array.' do
	  	@sdb1.set_all_tables
	  	@sdb2.set_all_tables
	  	expect(@sdb1.tables).to match_array @expected_tables_sdb1
	  	expect(@sdb2.tables).to match_array @expected_tables_sdb2
	  end
	end

	describe "set_all_columns" do
		context "should set all columns of all tables." do
			it "@columns hash should contain all the table names as keys." do
				@sdb1.set_all_columns
				@sdb2.set_all_columns
				expect(@sdb1.columns.keys).to match_array @expected_columns_sdb1.keys
				expect(@sdb2.columns.keys).to match_array @expected_columns_sdb2.keys
			end

			it "@columns[:table] should store all the column names as array of strings." do
				@sdb1.set_all_columns
				@sdb2.set_all_columns
				@expected_tables_sdb1.each do |t|
					expect(@sdb1.columns[t]).to match_array @expected_columns_sdb1[t]
				end
				@expected_tables_sdb2.each do |t|
					expect(@sdb2.columns[t]).to match_array @expected_columns_sdb2[t]
				end
			end
		end
	end

	describe "get_columns(table_name)" do
		it "should return all columns of a given table." do
			expected_result1 = ["AlbumId", "Title", "ArtistId"]
			expected_result2 = ["EmployeeId", "LastName", "FirstName", "Title", "ReportsTo", "BirthDate", "HireDate", "Address", "City", "State", "Country", "PostalCode", "Phone", "Fax", "Email"]
			expected_result3 = ["InvoiceId", "CustomerId", "InvoiceDate", "BillingAddress", "BillingCity", "BillingState", "BillingCountry", "BillingPostalCode", "Total"]
			expect(@sdb1.get_columns("albums")).to match_array expected_result1
			expect(@sdb1.get_columns("employees")).to match_array expected_result2
			expect(@sdb2.get_columns("employees")).to match_array expected_result2  #sdb1 and sdb2 both have the same 'employees' table with same columns.
			expect(@sdb1.get_columns("invoices")).to match_array expected_result3
		end
	end

	describe "convert_table(table_name)" do
		it "should return a string containing ARFF for the given relation_name/table_name" do
			expect(@sdb2.convert_table("albums").gsub(/[\n\t ]/,"")).to eql @expected_arff_albums_sdb2
			expect(@sdb2.convert_table("employees").gsub(/[\n\t ]/,"")).to eql @expected_arff_employees_sdb2
			expect(@sdb1.convert_table("genres").gsub(/[\n\t ]/,"")).to eql @expected_arff_genres_sdb1
		end
	end

	describe "convert_table_with_columns(table_name, columns)" do
		it "should return a string containing ARFF for given table_name and columns." do
			expect(@sdb2.convert_table_with_columns("albums", ["AlbumId", "Title"]).gsub(/[\n\t ]/,"")).to eql @expected_arff_albums_sdb2_w_cols
		end
	end

	describe "convert(options={})" do
		context "convert() with no parameter" do
			it "should convert all the tables to their respective ARFFs." do
				expect(@sdb2.convert().gsub(/[\n\t ]/,"")).to eql @expected_arff_sdb2_all_tables
			end
		end
		context "convert() with more than one parameters" do
			it "should raise Argument Error." do
				# puts @sdb2.convert(:columns=>{"albums"=>["AlbumId", "Title"]}, :tables=>["AlbumId", "Title"])
				expect{ @sdb2.convert(:columns=>{"albums"=>["AlbumId", "Title"]}, :tables=>["AlbumId", "Title"]) }.to raise_error(ArgumentError)
				expect{ @sdb2.convert(:columns=>{"albums"=>["AlbumId", "Title"]}, :tables=>["AlbumId", "Title"], :column_types=>{"albums"=>{"AlbumId"=>"STRING","NOMINAL"=>"STRING"}}) }.to raise_error(ArgumentError)
			end
		end	
		context "convert() with wrong parameter name" do
			it "should raise Argument Error" do
				expect{ @sdb2.convert(:column=>{"albums"=>["AlbumId", "Title"]}) }.to raise_error(ArgumentError)
				expect{ @sdb1.convert(:blah=>{"albums"=>["AlbumId", "Title"]}) }.to raise_error(ArgumentError)
			end
		end
		context "convert() with parameter :tables" do
			it "should convert given tables to ARFFs." do
				expect(@sdb2.convert(:tables => ["albums", "employees"]).gsub(/[\n\t ]/,"")).to eql "#{@expected_arff_albums_sdb2}#{@expected_arff_employees_sdb2}"
				expect(@sdb2.convert(:tables => ["albums"]).gsub(/[\n\t ]/,"")).to eql @expected_arff_albums_sdb2
			end
		end
		context "convert() with parameter :columns" do
			it "should convert given columns of given tables to ARFFs." do
				# pending("Pending...")
				# raise "To be implemented."
				param1 = { "albums"=>["AlbumId", "Title"],
									 "employees"=>["EmployeeId", "LastName", "City"]
								 }
				param2 = { "albums"=>["AlbumId", "Title"] }
				expect(@sdb2.convert(:columns => param1).gsub(/[\n\t ]/,"")).to eql @expected_arff_columns_sdb2_param1
				expect(@sdb2.convert(:columns => param2).gsub(/[\n\t ]/,"")).to eql @expected_arff_columns_sdb2_param2
			end
		end
		context "convert() with parameter :column_types" do
			it "should convert given columns of given tables to ARFFs with given column/attribute types." do
				pending("Pending...")
				raise "To be implemented."
			end
		end
	end

end
















