# ToARFF

ToARFF is a ruby library to convert SQLite database files and CSV files to ARFF files (Attribute-Relation File Format), which is used to specify datasets for WEKA, a machine learning and data mining tool.

**What is an ARFF File:** [This wiki](http://weka.wikispaces.com/ARFF+%28book+version%29 ) describes perfectly,
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

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dhrubomoy/to-arff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).