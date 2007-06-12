require File.dirname(__FILE__) + '/../spec_helper'

describe <%= session_class %>sController do
  fixtures :<%= user_plural %>

  it "should successfully GET /<%= session_plural %>/new" do
    get :new
    response.should be_success
  end

  it "should redirect on valid POST to /<%= session_plural %>" do
    post :create, :login => 'admin', :password => 'test'
    response.should be_redirect
  end

  it "should set <%= session_singular %>[:<%= user_singular %>] on valid POST to /<%= session_plural %>" do
    post :create, :login => 'admin', :password => 'test'
    <%= session_singular %>[:<%= user_singular %>].should == <%= user_plural %>(:admin).id
  end

  it "should not redirect on invalid POST to /<%= session_plural %>" do
    post :create, :login => 'admin', :password => 'bad password'
    response.should be_success
  end

  it "should not set <%= session_singular %>[:<%= user_singular %>] on invalid POST to /<%= session_plural %>" do
    post :create, :login => 'admin', :password => 'bad password'
    <%= session_singular %>[:<%= user_singular %>].should be_nil 
  end

  it "should redirect on DELETE to /<%= session_plural %>" do
    delete :destroy
    response.should be_redirect
  end

  it "should unset <%= session_singular %>[:<%= user_singular %>] on DELETE to /<%= session_plural %>" do
    delete :destroy
    <%= session_singular %>[:<%= user_singular %>].should be_nil
  end
end
