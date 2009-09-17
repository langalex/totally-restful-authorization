## totally restful authorization

This plugin adds an authorization layer to your rails app that is <del>completely</del> totally transparent to your restful controllers. All you have to is call a macro in your controller and provide 4 methods (or use provided macros again) in your model that control who is allowed to access it or not. The controllers will then automatically block or allow the usual CRUD actions (new, create, edit, update, show, destroy) to run or not.

### How it works

Call _check_authorization_ in your restful controller...

    class ApplicationController < ActionController::Base
      check_authorization
    end

... and then declare the permissions in your model:

    class User
    	updatable_by :admin # updatable if updater.admin? return true
    	updatable_by :admin, :only => [:description] # only allow some attribute to be updated
    	updatable_by :self # special role self, allows the object to update itself
    	updatable_by :associated => :friend # allow user.friend to update the object
	
    	viewable_by :anyone # special role, includes nil
    	viewable_by :admin, :condition => lambda{|user, viewer| user.non_admin? && viewer.account_activated?} # use conditions for more complex permissions
	
	
	
    	destroyable_by [:admin, :root] # declare multiple roles at once
    end

Or implement one or more of these four methods directly:

    class User
      def updatable_by?(user, parameters = {})
        true
      end
  
      def creatable_by?(user, parameters = {})
        true
      end
  
      def destroyable_by?(user)
        true
      end
  
      def	viewable_by?(user)
        true
      end
    end

The user parameter is taken from the current_user in your controller (so you have to provide a current_user method, or install clearance/authlogic or something like that).

The parameters parameter is the model's part of the params hash in the controller. For example when doing an update:

    post :update, 'user' => {'name' => 'joe'}
    
Then {'name' => 'joe'} will be pass to User#updatable_by? as the second parameter.


From now on your controller will run a before filter before the new/create/edit/update/destroy/show actions to make sure that the current_user is allowed to update/create/destroy/view the model. If you don't declare any permissions no actions can be performed on your model.

## resource_controller

If you are using resource_conroller be sure to call check_authorization first and then resource_controller. This way totally-restful-authorization will use resource_controller's (which are more powerful and customizable) methods to load objects.

=================================================================

For questions, patches etc. contact alex[at]upstream-berlin.com

Copyright (c) 2009 Alexander Lang, released under the MIT license
