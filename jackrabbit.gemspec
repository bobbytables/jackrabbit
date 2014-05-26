# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jackrabbit/version'

Gem::Specification.new do |spec|
  spec.name          = "jackrabbit"
  spec.version       = Jackrabbit::VERSION
  spec.authors       = ["Robert Ross"]
  spec.email         = ["robert@creativequeries.com"]
  spec.summary       = %q{Work with RabbitMQ in a more sane way}
  spec.description   = %q{Jackrabbit simplifies doing very common tasks with RabbitMQ}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 3.0.0.rc1'
  spec.add_development_dependency 'bunny_hair', '~> 0.0.10'
end
