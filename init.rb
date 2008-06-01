require File.dirname(__FILE__) + '/lib/permission_check'

ActiveRecord::Base.send :include, PermissionDsl