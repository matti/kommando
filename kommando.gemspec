# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kommando/version'

Gem::Specification.new do |spec|
  spec.name          = "kommando"
  spec.version       = Kommando::VERSION
  spec.authors       = ["Matti Paksula"]
  spec.email         = ["matti.paksula@iki.fi"]

  spec.summary       = %q{Command runner with expect-like features}
  spec.description   = %q{Great for integration testing.}
  spec.homepage      = "http://github.com/matti/kommando"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-autotest", "~> 1.0"
  spec.add_development_dependency "ZenTest", "~> 4.11"
  spec.add_development_dependency "byebug"
end
