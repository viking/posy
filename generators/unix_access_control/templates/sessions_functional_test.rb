require File.dirname(__FILE__) + '/../test_helper'
require '<%= session_plural %>_controller'

# Re-raise errors caught by the controller.
class <%= session_class %>sController; def rescue_action(e) raise e end; end

class <%= session_class %>sControllerTest < Test::Unit::TestCase
  fixtures :<%= user_plural %>

  def setup
    @controller = <%= session_class %>sController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :create, :login => 'admin', :password => 'test'
    assert <%= session_singular %>[:<%= user_singular %>]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'admin', :password => 'bad password'
    assert_nil <%= session_singular %>[:<%= user_singular %>]
    assert_response :success
  end

  def test_should_logout
    login_as :admin
    get :destroy
    assert_nil <%= session_singular %>[:<%= user_singular %>]
    assert_response :redirect
  end
end
