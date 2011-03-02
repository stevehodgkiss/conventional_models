# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "conventional_models/version"

Gem::Specification.new do |s|
  s.name = %q{conventional_models}
  s.version = ConventionalModels::VERSION::STRING
  s.platform = Gem::Platform::RUBY
  s.authors = ["Steve Hodgkiss"]
  s.email = %q{steve@hodgkiss.me.uk}
  s.homepage = %q{http://github.com/stevehodgkiss/conventional_models}
  s.summary = %q{Generate ActiveRecord models. For lazy people.}
  s.description = %q{Generate ActiveRecord models automatically with basic relationships based on conventions.}
  s.default_executable = %q{cmconsole}
  
  s.rubyforge_project = "conventional_models"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  
  s.require_paths = ["lib"]
  
  s.add_development_dependency("rspec", [">= 2.3"])
  s.add_development_dependency("cucumber", [">= 0.6.4"])
  s.add_development_dependency("aruba", [">= 0.1.7"])
  s.add_runtime_dependency("activerecord", [">= 2.3.5"])
  s.add_runtime_dependency("rdoc")
end
