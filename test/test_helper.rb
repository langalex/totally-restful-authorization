require 'rubygems'
gem 'mocha'
gem 'actionpack'
require 'actionpack'
require 'action_controller'
require 'action_controller/test_process'
require 'test/unit'
Dir.glob(File.dirname(__FILE__) + '/../lib/*.rb').each do |file|
  require file
end
require 'mocha'

