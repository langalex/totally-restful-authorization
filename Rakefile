require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "totally-restful-authorization"
    gem.summary = %Q{This plugin adds an authorization layer to your rails app that is totally transparent to your restful controllers and a DSL for declaring permissions on your models.}
    gem.email = "alex@upstream-berlin.com"
    gem.homepage = "http://github.com/langalex/totally_restful_authorization"
    gem.authors = ["Alexander Lang"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test
