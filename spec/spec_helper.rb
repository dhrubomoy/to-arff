require 'simplecov'
SimpleCov.command_name 'RSpec'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'to-arff.rb'
require 'to-arff/sqlitedb'
require 'coveralls'

Coveralls.wear!