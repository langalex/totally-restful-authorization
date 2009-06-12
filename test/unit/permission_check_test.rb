require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

class Model; end

class ModelsController < ActionController::Base
  attr_accessor :current_user
  check_authorization
  
  def update
    @model = Model.find params[:id]
    @model.attributes= {}
  end
  
  def show
    @model = Model.find params[:id]
    render :text => 'show'
  end
  
  def edit
    render :text => 'edit'
  end
  
  def new
    render :text => 'new'
  end
  
  def create
    Model.create
  end
  
  def destroy
    @model = Model.find params[:id]
    @model.destroy
  end
end

class PermissionCheckTest < ActionController::TestCase
  
  def setup
    @user = stub 'user'
    @controller = ModelsController.new
    @controller.current_user = @user
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @model = stub 'test'
    Model.stubs(:find).with('1').returns(@model)
    Model.stubs(:new).returns(@model)
  end
  
  def test_doesnt_update_if_model_not_updatable
    @model.stubs(:respond_to?).with(:updatable_by?).returns(true)
    @model.stubs(:updatable_by?).with(@user).returns(false)
    @model.expects(:attributes=).never
    post :update, :id => 1
  end
  
  def test_updates_if_model_updatable
    @model.stubs(:respond_to?).with(:updatable_by?).returns(true)
    @model.stubs(:updatable_by?).with(@user).returns(true)
    @model.expects(:attributes=)
    post :update, :id => 1
  end
  
  def test_updates_if_model_doesnt_respond_to_updatable
    @model.expects(:attributes=)
    post :update, :id => 1
  end
  
  def test_doesnt_show_if_not_viewable
    @model.stubs(:respond_to?).with(:viewable_by?).returns(true)
    @model.stubs(:viewable_by?).with(@user).returns(false)
    get :show, :id => 1
    assert_response 403
    assert_nil assigns(:model)
  end
  
  def test_shows_if_viewable
    @model.stubs(:respond_to?).with(:viewable_by?).returns(true)
    @model.stubs(:viewable_by?).with(@user).returns(true)
    get :show, :id => 1
    assert_response :success
  end

  def test_shows_if_models_doesnt_respond_to_viewable
    get :show, :id => 1
    assert_response :success
  end
  
  def test_doesnt_edit_if_model_not_updatable
    @model.stubs(:respond_to?).with(:updatable_by?).returns(true)
    @model.stubs(:updatable_by?).with(@user).returns(false)
    get :edit, :id => 1
    assert_response 403
  end
  
  def test_does_edit_if_model_updatable
    @model.stubs(:respond_to?).with(:updatable_by?).returns(true)
    @model.stubs(:updatable_by?).with(@user).returns(true)
    get :edit, :id => 1
    assert_response 200
  end
  
  def test_does_edit_if_model_doesnt_respond_to_viewable
    get :edit, :id => 1
    assert_response 200
  end
  
  def test_doesnt_new_if_model_not_creatable
    @model.stubs(:respond_to?).with(:creatable_by?).returns(true)
    @model.stubs(:creatable_by?).with(@user).returns(false)
    get :new
    assert_response 403
  end
  
  def test_does_new_if_model_creatable
    @model.stubs(:respond_to?).with(:creatable_by?).returns(true)
    @model.stubs(:creatable_by?).with(@user).returns(true)
    get :new
    assert_response :success
  end
  
  def test_does_new_if_model_doesnt_respond_to_creatable
    get :new
    assert_response :success
  end
  
  def test_doesnt_create_if_model_not_creatable
    @model.stubs(:respond_to?).with(:creatable_by?).returns(true)
    @model.stubs(:creatable_by?).with(@user).returns(false)
    Model.expects(:create).never
    post :create
  end
  
  def test_creates_if_model_creatable
    @model.stubs(:respond_to?).with(:creatable_by?).returns(true)
    @model.stubs(:creatable_by?).with(@user).returns(true)
    Model.expects(:create)
    post :create
  end
  
  def test_creates_if_model_doesnt_respond_to_creatable
    Model.expects(:create)
    post :create
  end
  
  def test_doesnt_destroy_if_model_not_destroyable
    @model.stubs(:respond_to?).with(:destroyable_by?).returns(true)
    @model.stubs(:destroyable_by?).with(@user).returns(false)
    @model.expects(:destroy).never
    post :destroy, :id => 1
  end
  
  def test_destroy_if_model_destroyable
    @model.stubs(:respond_to?).with(:destroyable_by?).returns(true)
    @model.stubs(:destroyable_by?).with(@user).returns(true)
    @model.expects(:destroy)
    post :destroy, :id => 1
  end
  
  def test_destroy_if_model_doesnt_respond_to_destroyable
    @model.expects(:destroy)
    post :destroy, :id => 1
  end
end