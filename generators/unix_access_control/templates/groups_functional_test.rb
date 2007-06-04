require File.dirname(__FILE__) + '/../test_helper'
require '<%= group_plural %>_controller'

# Re-raise errors caught by the controller.
class <%= group_class %>sController; def rescue_action(e) raise e end; end

class <%= group_class %>sControllerTest < Test::Unit::TestCase
  fixtures :<%= group_plural %>, :<%= user_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  def setup
    @controller = <%= group_class %>sController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as(:admin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:<%= group_plural %>)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_<%= group_singular %>
    old_count = <%= group_class %>.count
    post :create, :<%= group_singular %> => { :name => 'monkey', :description => 'the monkey <%= group_singular %>' }
    assert_equal old_count+1, <%= group_class %>.count
    
    assert_redirected_to <%= group_singular %>_path(assigns(:<%= group_singular %>))
  end

  def test_should_show_<%= group_singular %>
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_<%= group_singular %>
    put :update, :id => 2, :<%= group_singular %> => { }
    assert_redirected_to <%= group_singular %>_path(assigns(:<%= group_singular %>))
  end
  
  def test_should_destroy_<%= group_singular %>
    old_count = <%= group_class %>.count
    delete :destroy, :id => 2
    assert_equal old_count-1, <%= group_class %>.count
    
    assert_redirected_to <%= group_plural %>_path
  end
end
