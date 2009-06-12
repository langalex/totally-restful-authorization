$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'totally_restful_authorization/permission_check'
require 'totally_restful_authorization/permission_dsl'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, TotallyRestfulAuthorization::PermissionDsl
end

if defined?(ActionController::Base)
  ActionController::Base.class_eval do
    def self.check_authorization
      include TotallyRestfulAuthorization::PermissionCheck
    end
  end
end