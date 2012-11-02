# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thread_local_variable_access/version'

Gem::Specification.new do |gem|
  gem.name          = "thread_local_variable_access"
  gem.version       = ThreadLocalVariableAccess::VERSION
  gem.authors       = ["Stefan Kaes"]
  gem.email         = ["stefan.kaes@xing.com"]
  gem.description   = %q{Provide thread local variables for ruby 1.9 and API for all ruby versions}
  gem.summary       = %q{Provide functionality compatible to latest trunk commit for all ruby version above 1.8}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
