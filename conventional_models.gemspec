# -*- encoding: utf-8 -*-
require File.expand_path("../lib/conventional_models/version", __FILE__)

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
  
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "conventional_models"
  
  s.executables = ["cmconsole"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "README.rdoc"]
  s.test_files = Dir["spec/**/*.rb", "features/**/*", "Gemfile", "Gemfile.lock"]
  
  s.require_paths = ["lib"]
  
  s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
  s.add_development_dependency(%q<cucumber>, [">= 0.6.4"])
  s.add_development_dependency(%q<aruba>, [">= 0.1.7"])
  s.add_runtime_dependency(%q<activerecord>, [">= 2.3.5"])
end
