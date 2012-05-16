# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion_require/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mick Staugaard"]
  gem.email         = ["mick@staugaard.com"]
  gem.description   = "Implementation of Kernel#require for RubyMotion"
  gem.summary       = "Automatic file dependency resolution for RubyMotion"
  gem.homepage      = ""

  gem.files         = Dir.glob("lib/**/*") + ["README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "motion_require"
  gem.require_paths = ["lib"]
  gem.version       = MotionRequire::VERSION
end
