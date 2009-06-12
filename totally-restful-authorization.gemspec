# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{totally-restful-authorization}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Lang"]
  s.date = %q{2009-06-12}
  s.email = %q{alex@upstream-berlin.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README"
  ]
  s.files = [
    "LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "lib/totally_restful_authorization.rb",
     "lib/totally_restful_authorization/permission_check.rb",
     "lib/totally_restful_authorization/permission_dsl.rb",
     "rails/init.rb",
     "test/test_helper.rb",
     "test/unit/permission_check_test.rb",
     "test/unit/permission_dsl_test.rb",
     "totally-restful-authorization.gemspec"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/langalex/totally_restful_authorization}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{This plugin adds an authorization layer to your rails app that is totally transparent to your restful controllers and a DSL for declaring permissions on your models.}
  s.test_files = [
    "test/test_helper.rb",
     "test/unit/permission_check_test.rb",
     "test/unit/permission_dsl_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
