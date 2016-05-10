# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zimbra_wall/version'

Gem::Specification.new do |spec|
  spec.name          = "zimbra_wall"
  spec.version       = ZimbraWall::VERSION
  spec.authors       = ["Patricio Bruna"]
  spec.email         = ["pbruna@itlinux.cl"]
  spec.summary       = "An authorization wall for Zimbra"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/pbruna/zimbra_wall"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'em-proxy', "~> 0.1.8"
  spec.add_dependency 'thor', "~> 0.19"
  spec.add_dependency 'uuid', "~> 2.3"
  spec.add_dependency 'http_parser.rb', "~> 0.6"
  spec.add_dependency 'addressable', "~> 2.3"
  spec.add_dependency 'xml-simple', "~> 1.1"
  spec.add_development_dependency "bundler"


  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-reporters"
end
