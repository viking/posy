require File.dirname(__FILE__) + '/../spec_helper'

describe <%= user_plural_class %>Controller, "when no one is logged in" do

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

describe <%= user_plural_class %>Controller, "handling GET /<%= user_plural %> as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    <%= user_class %>.stub!(:find).and_return([])

    get :index
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= user_plural %>" do
    assigns[:<%= user_plural %>].should == [] 
  end
end

describe <%= user_plural_class %>Controller, "handling GET /<%= user_plural %>/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= user_singular %> = mock_model(<%= user_class %>)
    <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)

    get :show, :id => "1"
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= user_singular %>" do
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end

describe <%= user_plural_class %>Controller, "handling GET /<%= user_plural %>/new as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= user_singular %> = mock_model(<%= user_class %>)
    <%= user_class %>.stub!(:new).and_return(@<%= user_singular %>)

    get :new
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= user_singular %>" do
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end

describe <%= user_plural_class %>Controller, "handling GET /<%= user_plural %>/1;edit as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= user_singular %> = mock_model(<%= user_class %>)
    <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)

    get :edit, :id => "1"
  end

  it "should GET /<%= user_plural %>/1;edit successfully" do
    response.should be_success
  end

  it "should have a @<%= user_singular %> after GET /<%= user_plural %>/1;edit" do
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end

describe <%= user_plural_class %>Controller, "handling POST /<%= user_plural %> as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= user_singular %> = mock_model(<%= user_class %>)
    <%= user_class %>.stub!(:new).and_return(@<%= user_singular %>)
    @<%= user_singular %>.stub!(:save).and_return(true)
  end

  it "should redirect to /<%= user_plural %>/:id when valid" do
    post :create
    response.should redirect_to(<%= user_singular %>_url(@<%= user_singular %>))
  end

  it "should render 'new' when invalid" do
    @<%= user_singular %>.stub!(:save).and_return(false)
    post :create
    response.should render_template("new")
  end

  it "should set @<%= user_singular %>" do
    post :create
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end

describe <%= user_plural_class %>Controller, "handling PUT /<%= user_plural %>/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= user_singular %> = mock_model(<%= user_class %>)
    <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
    @<%= user_singular %>.stub!(:update_attributes).and_return(true)
  end

  it "should redirect to /<%= user_plural %>/:id when valid" do
    put :update, :id => '1'
    response.should redirect_to(<%= user_singular %>_url(@<%= user_singular %>))
  end

  it "should render 'edit' when invalid" do
    @<%= user_singular %>.stub!(:update_attributes).and_return(false)
    put :update, :id => '1'
    response.should render_template("edit")
  end

  it "should set @<%= user_singular %>" do
    put :update, :id => '1'
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end

describe <%= user_plural_class %>Controller, "handling DELETE /<%= user_plural %>/1 as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= user_singular %> = mock_model(<%= user_class %>)
    <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
    @<%= user_singular %>.stub!(:destroy).and_return(@<%= user_singular %>)

    delete :destroy, :id => '1'
  end

  it "should redirect to /<%= user_plural %>" do
    response.should redirect_to(<%= user_plural %>_url)
  end

  it "should set @<%= user_singular %>" do
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end
