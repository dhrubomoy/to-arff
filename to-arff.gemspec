# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'to-arff/version'
require 'to-arff'

Gem::Specification.new do |spec|
  spec.name          = 'to-arff'
  spec.version       = ToARFF::VERSION
  spec.authors       = ['dhrubo_moy']
  spec.email         = ['dhrubo_moy@yahoo.com']

  spec.summary       = %q{ ToARFF is a ruby gem to convert sqlite database file to ARFF (Attribute-Relation File Format) file. }
  # spec.description   = %q{  }
  spec.homepage      = 'https://github.com/dhrubomoy/to-arff'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
