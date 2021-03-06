# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lobber/version'

Gem::Specification.new do |spec|
  spec.name          = "lobber"
  spec.version       = Lobber::VERSION
  spec.authors       = ["Mike Ball"]
  spec.email         = ["mikedball@gmail.com"]
  spec.description   = %q{A commandline tool to quickly push a directory to AWS S3}
  spec.summary       = %q{Toss a directory to AWS S3}
  spec.homepage      = "http://github.com/mdb/lobber"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fog"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
