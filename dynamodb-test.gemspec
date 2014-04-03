# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamodb/test/version'

Gem::Specification.new do |spec|
  spec.name          = "dynamodb-test"
  spec.version       = Dynamodb::Test::VERSION
  spec.authors       = ["John Kamenik"]
  spec.email         = ["jkamenik@gmail.com"]
  spec.summary       = %q{Amazon dynamodb test.}
  spec.description   = %q{Tests accessing a dynamodb instance in ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'dotenv'
  spec.add_dependency 'aws-sdk'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
