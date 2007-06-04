require File.dirname(__FILE__) + '/../test_helper'
require '<%= membership_plural %>_controller'

# Re-raise errors caught by the controller.
class <%= membership_class %>sController; def rescue_action(e) raise e end; end

class <%= membership_class %>sControllerTest < Test::Unit::TestCase
  fixtures :<%= group_plural %>, :<%= user_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  def setup
    @controller = <%= membership_class %>sController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as(:admin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:<%= membership_plural %>)
  end

  def test_should_get_index_for_<%= group_singular %>
    get :index, :<%= group_singular %>_id => '2'
    assert_response :success
    assert assigns(:<%= membership_plural %>)
    assert_equal 1, assigns(:<%= membership_plural %>).length
  end

  def test_should_get_index_for_<%= user_singular %>
    get :index, :<%= user_singular %>_id => '2'
    assert_response :success
    assert assigns(:<%= membership_plural %>)
    assert_equal 2, assigns(:<%= membership_plural %>).length
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_get_new_for_<%= group_singular %>
    get :new, :<%= group_singular %>_id => '2'
    assert_response :success
    assert_equal 2, assigns(:<%= membership_singular %>).<%= group_singular %>_id
  end

  def test_should_get_new_for_<%= user_singular %>
    get :new, :<%= user_singular %>_id => '2'
    assert_response :success
    assert_equal 2, assigns(:<%= membership_singular %>).<%= user_singular %>_id
  end
  
  def test_should_create_<%= membership_singular %>
    assert_difference <%= membership_class %>, :count do
      post :create, :<%= membership_singular %> => { :<%= group_singular %>_id => '2', :<%= user_singular %>_id => '5' }
      assert !assigns(:<%= membership_singular %>).new_record?, "#{assigns(:<%= membership_singular %>).errors.full_messages.to_sentence}"
    end
    
    assert_redirected_to <%= membership_singular %>_path(assigns(:<%= membership_singular %>))
  end

  def test_should_create_<%= membership_singular %>_for_<%= group_singular %>
    old_count = <%= membership_class %>.count
    post :create, :<%= group_singular %>_id => '2', :<%= membership_singular %> => { :<%= user_singular %>_id => '5' }
    assert_equal old_count+1, <%= membership_class %>.count
    
    assert_equal 2, assigns(:<%= membership_singular %>).<%= group_singular %>_id
    assert_redirected_to <%= membership_singular %>_path(assigns(:<%= membership_singular %>))
  end

  def test_should_create_<%= membership_singular %>_for_<%= user_singular %>
    old_count = <%= membership_class %>.count
    post :create, :<%= user_singular %>_id => '5', :<%= membership_singular %> => { :<%= group_singular %>_id => '2' }
    assert_equal old_count+1, <%= membership_class %>.count
    
    assert_equal 5, assigns(:<%= membership_singular %>).<%= user_singular %>_id
    assert_redirected_to <%= membership_singular %>_path(assigns(:<%= membership_singular %>))
  end

  def test_should_show_<%= membership_singular %>
    get :show, :id => '1'
    assert_response :success
  end

  def test_should_show_<%= membership_singular %>_for_<%= group_singular %>
    get :show, :id => '2', :<%= group_singular %>_id => '2'
    assert_response :success
  end

  def test_should_show_<%= membership_singular %>_for_<%= user_singular %>
    get :show, :id => '2', :<%= user_singular %>_id => '2'
    assert_response :success
  end

  def test_should_destroy_<%= membership_singular %>
    old_count = <%= membership_class %>.count
    delete :destroy, :id => 1
    assert_equal old_count-1, <%= membership_class %>.count
    
    assert_redirected_to <%= membership_plural %>_path
  end

  def test_should_destroy_<%= membership_singular %>_for_<%= group_singular %>
    old_count = <%= membership_class %>.count
    delete :destroy, :id => '2', :<%= group_singular %>_id => '2'
    assert_equal old_count-1, <%= membership_class %>.count
    
    assert_redirected_to <%= membership_plural %>_path
  end

  def test_should_destroy_<%= membership_singular %>_for_<%= user_singular %>
    old_count = <%= membership_class %>.count
    delete :destroy, :id => '2', :<%= user_singular %>_id => '2'
    assert_equal old_count-1, <%= membership_class %>.count
    
    assert_redirected_to <%= membership_plural %>_path
  end
end
