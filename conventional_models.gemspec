# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{conventional_models}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steve Hodgkiss"]
  s.date = %q{2010-04-10}
  s.description = %q{Generate ActiveRecord models automatically with basic relationships based on conventions.}
  s.email = %q{steve@hodgkiss.me.uk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "conventional_models.gemspec",
     "features/conventional_models.feature",
     "features/output_model_code.feature",
     "features/step_definitions/conventional_models_steps.rb",
     "features/step_definitions/output_model_code_steps.rb",
     "features/support/env.rb",
     "lib/conventional_models.rb",
     "lib/conventional_models/active_record_base_model_for.rb",
     "lib/conventional_models/column.rb",
     "lib/conventional_models/conventions.rb",
     "lib/conventional_models/database.rb",
     "lib/conventional_models/table.rb",
     "lib/conventional_models/version.rb",
     "spec/conventional_models/conventions_spec.rb",
     "spec/conventional_models/database_spec.rb",
     "spec/conventional_models/table_spec.rb",
     "spec/conventional_models_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/stevehodgkiss/conventional_models}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Generate ActiveRecord models. For lazy people.}
  s.test_files = [
    "spec/conventional_models/conventions_spec.rb",
     "spec/conventional_models/database_spec.rb",
     "spec/conventional_models/table_spec.rb",
     "spec/conventional_models_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0.6.4"])
      s.add_development_dependency(%q<aruba>, [">= 0.1.7"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<cucumber>, [">= 0.6.4"])
      s.add_dependency(%q<aruba>, [">= 0.1.7"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<cucumber>, [">= 0.6.4"])
    s.add_dependency(%q<aruba>, [">= 0.1.7"])
  end
end

