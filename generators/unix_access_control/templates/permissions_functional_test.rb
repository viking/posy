require File.dirname(__FILE__) + '/../test_helper'
require '<%= permission_plural %>_controller'

# Re-raise errors caught by the controller.
class <%= permission_class %>sController; def rescue_action(e) raise e end; end

class <%= permission_class %>sControllerTest < Test::Unit::TestCase
  fixtures :<%= group_plural %>, :<%= user_plural %>, :<%= membership_plural %>, :<%= permission_plural %>, :cats, :dogs, :robots

  def setup
    @controller = <%= permission_class %>sController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as(:admin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:<%= permission_plural %>)
  end

  def test_should_get_index_for_<%= group_singular %>
    get :index, :<%= group_singular %>_id => '22'
    assert_response :success
    assert assigns(:<%= permission_plural %>)
    assert_equal 6, assigns(:<%= permission_plural %>).length
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_get_new_for_<%= group_singular %>
    get :new, :<%= group_singular %>_id => '22'
    assert_response :success
  end
  
  def test_should_create_controller_<%= permission_singular %>
    assert_difference <%= permission_class %>, :count do
      post :create, :<%= permission_singular %> => { :<%= group_singular %>_id => '2', :controller => 'cats', :resource_type => 'Controller', :can_read => true }
    end
    
    assert_nil assigns(:<%= permission_singular %>).resource_type
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>))
  end

  def test_should_create_controller_<%= permission_singular %>_for_<%= group_singular %>
    assert_difference <%= permission_class %>, :count do
      post :create, :<%= group_singular %>_id => '2', :<%= permission_singular %> => { :controller => 'cats', :resource_type => 'Controller', :can_read => true }
    end
    
    assert_equal 2, assigns(:<%= permission_singular %>).<%= group_singular %>_id
    assert_nil assigns(:<%= permission_singular %>).resource_type
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>))
  end

  def test_should_create_resource_<%= permission_singular %>
    assert_difference <%= permission_class %>, :count do
      post :create, :<%= permission_singular %> => { :<%= group_singular %>_id => '2', :resource_id => '1', :resource_type => 'Cat', :can_read => true }
    end
    
    assert_equal cats(:fluffy), assigns(:<%= permission_singular %>).resource
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>))
  end

  def test_should_create_resource_<%= permission_singular %>_for_<%= group_singular %>
    assert_difference <%= permission_class %>, :count do
      post :create, :<%= group_singular %>_id => '2', :<%= permission_singular %> => { :resource_id => '1', :resource_type => 'Cat', :can_read => true }
    end
    
    assert_equal 2, assigns(:<%= permission_singular %>).<%= group_singular %>_id
    assert_equal cats(:fluffy), assigns(:<%= permission_singular %>).resource
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>))
  end

  def test_should_show_<%= permission_singular %>
    get :show, :id => '1'
    assert_response :success
  end

  def test_should_show_<%= permission_singular %>_for_<%= group_singular %>
    get :show, :<%= group_singular %>_id => '2', :id => '1'
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_get_edit_for_<%= group_singular %>
    get :edit, :<%= group_singular %>_id => '2', :id => '1'
    assert_response :success
  end
  
  def test_should_update_<%= permission_singular %>
    put :update, :id => 1, :<%= permission_singular %> => { :can_read => false, :can_write => true, :is_sticky => true }
    deny   assigns(:<%= permission_singular %>).can_read
    assert assigns(:<%= permission_singular %>).can_write
    assert assigns(:<%= permission_singular %>).is_sticky
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>)), assigns(:<%= permission_singular %>).errors.full_messages.to_sentence
  end
  
  def test_should_update_<%= permission_singular %>_for_<%= group_singular %>
    put :update, :id => '1', :<%= group_singular %>_id => '2', :<%= permission_singular %> => { :can_read => false, :can_write => true, :is_sticky => true }
    deny   assigns(:<%= permission_singular %>).can_read
    assert assigns(:<%= permission_singular %>).can_write
    assert assigns(:<%= permission_singular %>).is_sticky
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>)), assigns(:<%= permission_singular %>).errors.full_messages.to_sentence
  end
  
  def test_should_remove_extra_attributes_on_update
    put :update, :id => 1, :<%= permission_singular %> => { :<%= group_singular %> => <%= group_plural %>(:empty), :controller => 'dogs', :resource => dogs(:mr_pants) }
    assert_equal <%= group_plural %>(:robots_r), assigns(:<%= permission_singular %>).<%= group_singular %>
    assert_equal 'robots', assigns(:<%= permission_singular %>).controller
    assert_nil   assigns(:<%= permission_singular %>).resource
    assert_redirected_to <%= permission_singular %>_path(assigns(:<%= permission_singular %>)), assigns(:<%= permission_singular %>).errors.full_messages.to_sentence
  end
  
  def test_should_destroy_<%= permission_singular %>
    assert_difference <%= permission_class %>, :count, -1 do
      delete :destroy, :id => '1'
    end
    
    assert_redirected_to <%= permission_plural %>_path
  end

  def test_should_destroy_<%= permission_singular %>_for_<%= group_singular %>
    assert_difference <%= permission_class %>, :count, -1 do
      delete :destroy, :<%= group_singular %>_id => '2', :id => '1'
    end
    
    assert_redirected_to <%= permission_plural %>_path
  end
end
