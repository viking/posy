require File.dirname(__FILE__) + '/../test_helper'
require '<%= user_plural %>_controller'

# Re-raise errors caught by the controller.
class <%= user_class %>sController; def rescue_action(e) raise e end; end

class <%= user_class %>sControllerTest < Test::Unit::TestCase
  fixtures :<%= group_plural %>, :<%= user_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  def setup
    @controller = <%= user_class %>sController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as(:admin)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:<%= user_plural %>)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_<%= user_singular %>
    assert_difference <%= user_class %>, :count do
      create_<%= user_singular %>
    end
    
    assert_redirected_to <%= user_singular %>_path(assigns(:<%= user_singular %>))
  end

  def test_should_require_login_on_create
    assert_no_difference <%= user_class %>, :count do
      create_<%= user_singular %>(:login => nil)
      assert assigns(:<%= user_singular %>).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_create
    assert_no_difference <%= user_class %>, :count do
      create_<%= user_singular %>(:password => nil)
      assert assigns(:<%= user_singular %>).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_create
    assert_no_difference <%= user_class %>, :count do
      create_<%= user_singular %>(:password_confirmation => nil)
      assert assigns(:<%= user_singular %>).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_create
    assert_no_difference <%= user_class %>, :count do
      create_<%= user_singular %>(:email => nil)
      assert assigns(:<%= user_singular %>).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_show_<%= user_singular %>
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_<%= user_singular %>
    put :update, :id => 1, :<%= user_singular %> => { }
    assert_redirected_to <%= user_singular %>_path(assigns(:<%= user_singular %>))
  end
  
  def test_should_destroy_<%= user_singular %>
    assert_difference <%= user_class %>, :count, -1 do
      delete :destroy, :id => 1
    end
    
    assert_redirected_to <%= user_plural %>_path
  end

  protected
    def create_<%= user_singular %>(options = {})
      post :create, :<%= user_singular %> => { :login => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
