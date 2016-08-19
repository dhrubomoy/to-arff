require 'coveralls'
Coveralls.wear!

require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start
# SimpleCov.command_name 'RSpec'
# SimpleCov.start


$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'to-arff.rb'
require 'to-arff/sqlitedb'