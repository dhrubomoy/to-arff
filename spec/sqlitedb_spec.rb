require 'spec_helper'

describe ToARFF::SQLiteDB do


	before(:each) do
	  @fs1 = ToARFF::SQLiteDB.new "./spec/chinook.db"
	end

	context "get_all_tables" do
	  it 'returns all the tables of the database.' do
	  	expected_arr1 = ["albums", "employees", "invoices", "playlists", "artists", 
	  									"genres", "media_types", "tracks", "customers", "invoice_items", 
	  									"playlist_track", "sqlite_sequence", "sqlite_stat1"]
	  	expect(@fs1.get_all_tables).to match_array expected_arr1
	  end
	end

end