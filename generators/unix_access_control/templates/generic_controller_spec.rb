require File.dirname(__FILE__) + '/../spec_helper'

describe "requesting /<%= thing_plural %>/* when no one is logged in" do
  controller_name :<%= thing_plural %>

  it "should redirect to /<%= session_plural %>/new on GET to index" do
    get :index
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on GET to new" do
    get :new
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on GET to show" do
    get :show, :id => "1"
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on GET to edit" do
    get :edit, :id => "1"
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on POST to create" do
    post :create
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on PUT to update" do
    put :update, :id => "1"
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on DELETE to destroy" do
    delete :destroy, :id => "1"
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end
end

describe "GET /<%= thing_plural %> as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    <%= thing_class %>.stub!(:find).and_return([])

    get :index
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= thing_plural %>" do
    assigns[:<%= thing_plural %>].should == [] 
  end
end

describe "GET /<%= thing_plural %>/1 as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= thing_singular %> = mock_model(<%= thing_class %>)
    <%= thing_class %>.stub!(:find).and_return(@<%= thing_singular %>)

    get :show, :id => "1"
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= thing_singular %>" do
    assigns[:<%= thing_singular %>].should == @<%= thing_singular %>
  end
end

describe "GET /<%= thing_plural %>/new as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= thing_singular %> = mock_model(<%= thing_class %>)
    <%= thing_class %>.stub!(:new).and_return(@<%= thing_singular %>)

    get :new
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= thing_singular %>" do
    assigns[:<%= thing_singular %>].should == @<%= thing_singular %>
  end
end

describe "GET /<%= thing_plural %>/1;edit as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= thing_singular %> = mock_model(<%= thing_class %>)
    <%= thing_class %>.stub!(:find).and_return(@<%= thing_singular %>)

    get :edit, :id => "1"
  end

  it "should GET /<%= thing_plural %>/1;edit successfully" do
    response.should be_success
  end

  it "should have a @<%= thing_singular %> after GET /<%= thing_plural %>/1;edit" do
    assigns[:<%= thing_singular %>].should == @<%= thing_singular %>
  end
end

describe "POST /<%= thing_plural %> as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= thing_singular %> = mock_model(<%= thing_class %>)
    <%= thing_class %>.stub!(:new).and_return(@<%= thing_singular %>)
    @<%= thing_singular %>.stub!(:save).and_return(true)
  end

  it "should redirect to /<%= thing_plural %>/:id when valid" do
    post :create
    response.should redirect_to(<%= thing_singular %>_url(@<%= thing_singular %>))
  end

  it "should render 'new' when invalid" do
    @<%= thing_singular %>.stub!(:save).and_return(false)
    post :create
    response.should render_template("new")
  end

  it "should set @<%= thing_singular %>" do
    post :create
    assigns[:<%= thing_singular %>].should == @<%= thing_singular %>
  end
end

describe "PUT /<%= thing_plural %>/1 as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= thing_singular %> = mock_model(<%= thing_class %>)
    <%= thing_class %>.stub!(:find).and_return(@<%= thing_singular %>)
    @<%= thing_singular %>.stub!(:update_attributes).and_return(true)
  end

  it "should redirect to /<%= thing_plural %>/:id when valid" do
    put :update, :id => '1'
    response.should redirect_to(<%= thing_singular %>_url(@<%= thing_singular %>))
  end

  it "should render 'edit' when invalid" do
    @<%= thing_singular %>.stub!(:update_attributes).and_return(false)
    put :update, :id => '1'
    response.should render_template("edit")
  end

  it "should set @<%= thing_singular %>" do
    put :update, :id => '1'
    assigns[:<%= thing_singular %>].should == @<%= thing_singular %>
  end
end

describe "DELETE /<%= thing_plural %>/1 as admin" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= thing_singular %> = mock_model(<%= thing_class %>)
    <%= thing_class %>.stub!(:find).and_return(@<%= thing_singular %>)
    @<%= thing_singular %>.stub!(:destroy).and_return(@<%= thing_singular %>)

    delete :destroy, :id => '1'
  end

  it "should redirect to /<%= thing_plural %>" do
    response.should redirect_to(<%= thing_plural %>_url)
  end

  it "should set @<%= thing_singular %>" do
    assigns[:<%= thing_singular %>].should == @<%= thing_singular %>
  end
end
