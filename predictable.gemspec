# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'predictable/version'

Gem::Specification.new do |spec|
  spec.name          = "predictable"
  spec.version       = Predictable::VERSION
  spec.authors       = ["JS Boulanger"]
  spec.email         = ["jsboulanger@gmail.com"]
  spec.description   = "Ruby/Rails DSL for Prediction.io, an open source machine learning server."
  spec.summary       = "Ruby/Rails DSL for Prediction.io."
  spec.homepage      = "https://github.com/jsboulanger/predictable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('activerecord')
  spec.add_dependency('predictionio')

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
