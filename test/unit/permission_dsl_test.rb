require File.dirname(__FILE__) + '/../test_helper'

class PermissionDslTest < Test::Unit::TestCase
  class Model
    include TotallyRestfulAuthorization::PermissionDsl
  end
  
  
  def setup
    @clazz = Model
    @clazz.update_permissions.clear
    @clazz.view_permissions.clear
    @clazz.update_permissions.clear
    @clazz.destroy_permissions.clear
    @clazz.create_permissions.clear
  end
  
  def test_is_not_updatable_if_no_permissions_declared
    assert !@clazz.new.updatable_by?(stub('user'))
  end
  
  def test_understands_multiple_roles_at_once
    @clazz.send :updatable_by, [:admin, :superadmin]
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true, :superadmin? => false))
    assert @clazz.new.updatable_by?(stub('superadmin', :admin? => false, :superadmin? => true))
  end
  
  def test_is_not_updatable_for_nil
    @clazz.send :updatable_by, :admin
    assert !@clazz.new.updatable_by?(nil)
  end
  
  def test_special_role_self_is_interpreted_as_user_is_same_as_object
    @clazz.send :updatable_by, :self
    _self = @clazz.new
    assert _self.updatable_by?(_self)
  end
  
  def test_hash_with_associated_is_interpreted_as_attributes_on_the_object
    @clazz.class_eval do
      attr_accessor :user
      updatable_by(:associated => :user)
    end
    
    instance = @clazz.new
    user = 'user'
    instance.user = user
    assert instance.updatable_by?(user)
    assert !instance.updatable_by?('other user')
  end
  
  def test_special_role_anyone_is_interpreted_as_any_object
    @clazz.send :updatable_by, :anyone
    assert @clazz.new.updatable_by?('yet another object')
  end
  
  def test_anyone_allows_nil
    @clazz.send :updatable_by, :anyone
    assert @clazz.new.updatable_by?(nil)
  end
  
  def test_allows_role_access_to_entire_object
    @clazz.send :updatable_by, :admin
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true))
  end
  
  def test_forbids_user_without_role_access_to_object
    @clazz.send :updatable_by, :admin
    assert !@clazz.new.updatable_by?(stub('admin', :admin? => false))
  end
  
  def test_allows_role_access_only_to_specific_field
    @clazz.send :updatable_by, :admin, :only => [:name]
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true), :name)
  end
  
  def test_forbids_role_access_to_fields_not_in_only_array
    @clazz.send :updatable_by, :admin, :only => [:name]
    assert !@clazz.new.updatable_by?(stub('admin', :admin? => true), :email)
  end
  
  def test_allows_role_access_to_fields_not_in_except_array
    @clazz.send :updatable_by, :admin, :except => [:email]
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true), :name)
  end
  
  def test_forbids_role_access_to_fields_in_except_array
    @clazz.send :updatable_by, :admin, :except => [:email]
    assert !@clazz.new.updatable_by?(stub('admin', :admin? => true), :email)
  end
  
  def test_allows_access_if_conditions_met
    @clazz.send :updatable_by, :admin, :condition => lambda{|model, updater| updater.admin?}
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true))
  end
  
  def test_forbids_access_if_condition_not_met
    @clazz.send :updatable_by, :admin, :condition => lambda{|model, updater| !updater.admin?}
    assert !@clazz.new.updatable_by?(stub('admin', :admin? => true))
  end
  
  def test_multiple_role_declarations_dont_overwrite_one_another
    @clazz.send :updatable_by, :admin
    @clazz.send :updatable_by, :user
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true, :user? => false))
  end
  
  def test_multiple_option_declarations_per_role_dont_overwrite_one_another
    @clazz.send :updatable_by, :admin, :only => [:user]
    @clazz.send :updatable_by, :admin, :only => [:email]
    assert @clazz.new.updatable_by?(stub('admin', :admin? => true), :user)
  end
  
  def test_viewable_by?
    @clazz.send :viewable_by, :admin
    assert @clazz.new.viewable_by?(stub('admin', :admin? => true))
  end
  
  def test_creatable_by?
    @clazz.send :creatable_by, :admin
    assert @clazz.new.creatable_by?(stub('admin', :admin? => true))
  end
  
  def test_destroyable_by?
    @clazz.send :destroyable_by, :admin
    assert @clazz.new.destroyable_by?(stub('admin', :admin? => true))
  end
  
  def test_declarations_in_inherited_class_dont_interfere_with_superclass
    @clazz2 = Class.new @clazz
    @clazz2.send :destroyable_by, :admin
    assert !@clazz.new.destroyable_by?(stub('admin', :admin? => true))
  end

end