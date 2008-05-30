module PermissionCheck
  def self.included(base)
    base.before_filter :check_instance_permissions, :only => [:update, :destroy, :edit, :show]
    base.before_filter :check_create_permissions, :only => [:create, :new]
  end
  
  private
  
  def check_instance_permissions
    begin
    model = model_class.find params[:id]
    deny_access_unless permission_granted?(model)
  rescue => e
    p e.message
    raise e
  end
  end
  
  def check_create_permissions
    begin
    model = model_class.new
    deny_access_unless permission_granted?(model)
    rescue => e
      p e.message
      raise e
    end
  end
  
  def permission_granted?(model)
    if model.respond_to? actionable_method.to_sym
      model.send(actionable_method, current_user)
    else
      true
    end
  end
  
  def actionable_method
    "#{map_to_permission(actionable_name)}_by?"
  end
  
  def deny_access_unless(boolean)
    if boolean
      true
    else
      render :text => 'Permission Denied', :status => 403
      false
    end
  end
  
  
  def actionable_name
    if params[:action][-1,1]  == 'e'
      "#{params[:action][0..-2]}able"
    else
      "#{params[:action]}able"
    end
  end
  
  def map_to_permission(actionable)
    {
      'editable' => 'updatable',
      'showable' => 'viewable',
      'newable' => 'creatable'
    }[actionable] || actionable
  end
  
  def model_class
    Class.const_get self.class.name[0..-12]
  end
end