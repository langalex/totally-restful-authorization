require File.dirname(__FILE__) + '/lib/permission_check'
require File.dirname(__FILE__) + '/lib/permission_dsl'

ActiveRecord::Base.send :include, PermissionDsl