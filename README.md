# ToARFF
[![Build Status](https://travis-ci.org/dhrubomoy/to-arff.svg?branch=master)](https://travis-ci.org/dhrubomoy/to-arff)
[![Coverage Status](https://coveralls.io/repos/github/dhrubomoy/to-arff/badge.svg)](https://coveralls.io/github/dhrubomoy/to-arff)
[![Gem Version](https://badge.fury.io/rb/to-arff.svg)](https://badge.fury.io/rb/to-arff)
[![Dependency Status](https://gemnasium.com/badges/github.com/dhrubomoy/to-arff.svg)](https://gemnasium.com/github.com/dhrubomoy/to-arff)
[![Code Climate](https://codeclimate.com/github/dhrubomoy/to-arff/badges/gpa.svg)](https://codeclimate.com/github/dhrubomoy/to-arff)
##Table of Content
- [About](#about)
  - [What is an ARFF File](#what-is-an-arff-file)
- [Installation](#installation)
- [Usage](#usage)
  - [Convert from an SQLite Database](#convert-from-an-sqlite-database)
- [Contributing](#contributing)
- [License](#license)

## About
ToARFF is a ruby library to convert SQLite database files to ARFF files (Attribute-Relation File Format), which is used to specify datasets for WEKA, a machine learning and data mining tool.

### What is an ARFF File: 
[This wiki](http://weka.wikispaces.com/ARFF+%28book+version%29 ) describes perfectly,
"An ARFF (Attribute-Relation File Format) file is an ASCII text file that describes a list of instances sharing a set of attributes. ARFF files were developed by the Machine Learning Project at the Department of Computer Science of The University of Waikato for use with the Weka machine learning software."

**Note:** Converting from an SQLite database will generate one ARFF file per table. See [this stackoverflow post](http://stackoverflow.com/questions/37009995/weka-machine-learning-arff-file-multiple-relations).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'to-arff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install to-arff

## Usage

###Convert from an SQLite Database
#### By Specifying Column Types (Recommended)
Its better to specify column types.
```ruby
require 'to-arff'
# You can download the file from  '/spec /sample_db_files/sample2.db'
sample = ToARFF::SQLiteDB.new "/path/to/sample_sqlite.db"
# Attribute names and types must be valid
# eg. { "table1" => {"column11"=>"NUMERIC",
#                    "column12"=>"STRING"
#                   },
#       "table2" => {"column21"=>"class {Iris-setosa,Iris-versicolor,Iris-virginica}",
#                    "column22"=>"DATE \"yyyy-MM-dd HH:mm:ss\""
#                   }
sample_column_types_param = { "employees" => {"EmployeeId"=>"NUMERIC",
                                              "LastName"=>"STRING",
                                              "City"=>"STRING",
                                              "HireDate"=>"DATE \"yyyy-MM-dd HH:mm:ss\""
                                             },
                              "albums" => { "Albumid"=>"NUMERIC",
                                            "Title"=>"STRING"
                                          }
                            }
puts sample.convert column_types: sample_column_types_param
```
We will get something similar to following:
```
@RELATION employees

@ATTRIBUTE EmployeeId NUMERIC
@ATTRIBUTE LastName STRING
@ATTRIBUTE City STRING
@ATTRIBUTE HireDate DATE "yyyy-MM-dd HH:mm:ss"

@DATA
1,"Adams","Edmonton","2002-08-14 00:00:00"
2,"Edwards","Calgary","2002-05-01 00:00:00"
3,"Peacock","Calgary","2002-04-01 00:00:00"
...and so on...

@RELATION albums

@ATTRIBUTE Albumid NUMERIC
@ATTRIBUTE Title STRING

@DATA
1,"For Those About To Rock We Salute You"
2,"Balls to the Wall"
3,"Restless and Wild"
...and so on...
```

#### By Specifying Column Names
```ruby
require 'to-arff'
sample = ToARFF::SQLiteDB.new "/path/to/sample_sqlite.db"
sample_columns =  { "albums" => ["AlbumId", "Title", "ArtistId"],
                    "employees" => ["EmployeeId", "LastName", "FirstName", "Title"]
                  }
puts sample.convert columns: sample_columns
```
We will get something similar:
```
@RELATION albums

@ATTRIBUTE AlbumId NUMERIC
@ATTRIBUTE Title STRING
@ATTRIBUTE ArtistId NUMERIC

@DATA
1,"For Those About To Rock We Salute You",1
2,"Balls to the Wall",2
...and so on...



@RELATION employees

@ATTRIBUTE EmployeeId NUMERIC
@ATTRIBUTE LastName STRING
@ATTRIBUTE FirstName STRING
@ATTRIBUTE HireDate STRING

@DATA
1,"Adams","Andrew","2002-08-14 00:00:00"
2,"Edwards","Nancy","2002-05-01 00:00:00"
...and so on..
```
As you can see, "HireDate" Attribute didn't have the correct datatype. It should be "DATE "yyyy-MM-dd HH:mm:ss"", not "STRING"

#### You can also do following, but might not generate correct datatypes
```ruby
require 'to-arff'
sample = ToARFF::SQLiteDB.new "/path/to/sample_sqlite.db"
sample.convert tables: ["albums","employees"]
# OR
sample.convert
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dhrubomoy/to-arff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

1. Fork it ( https://github.com/dhrubomoy/to-arff/fork )
2. Create branch (`git checkout -b my-new-feature`)
3. Make changes. Add test cases for your changes
4. Run `rspec spec/` and make sure all the test passes
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
