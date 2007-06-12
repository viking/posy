require File.dirname(__FILE__) + '/../spec_helper'

describe "the <%= membership_plural %> controller when no one is logged in" do
  controller_name :<%= membership_plural %>

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

  it "should redirect to /<%= session_plural %>/new on POST to create" do
    post :create
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end

  it "should redirect to /<%= session_plural %>/new on DELETE to destroy" do
    delete :destroy, :id => "1"
    response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
  end
end

describe "the <%= membership_plural %> controller when an admin is logged in" do
  controller_name :<%= membership_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @member     = mock_model(<%= membership_class %>)
    @collection = [@<%= membership_singular %>]

    <%= membership_class %>.stub!(:new).and_return(@member)
    <%= membership_class %>.stub!(:find).and_return(@member)
    @member.stub!(:save).and_return(true)
    @member.stub!(:update_attributes).and_return(true)
    @member.stub!(:destroy).and_return(@member)
  end

  it "should GET /<%= membership_plural %> successfully" do
    <%= membership_class %>.stub!(:find).and_return(@collection)
    get :index
    response.should be_success
  end

  it "should have @<%= membership_plural %> after GET /<%= membership_plural %>" do
    <%= membership_class %>.stub!(:find).and_return(@collection)
    get :index
    assigns[:<%= membership_plural %>].should == @collection
  end

  it "should GET /<%= membership_plural %>/1 successfully" do
    get :show, :id => "1"
    response.should be_success
  end

  it "should have a @<%= membership_singular %> after GET /<%= membership_plural %>/1" do
    get :show, :id => "1"
    assigns[:<%= membership_singular %>].should == @member
  end

  it "should GET /<%= membership_plural %>/new successfully" do
    get :new
    response.should be_success
  end

  it "should have a @<%= membership_singular %> after GET /<%= membership_plural %>/new" do
    get :new
    assigns[:<%= membership_singular %>].should == @member
  end

  it "should redirect to /<%= membership_plural %>/:id on valid POST to /<%= membership_plural %>" do
    post :create
    response.should redirect_to(:action => 'show', :id => @member.id)
  end

  it "should render 'new' on invalid POST to /<%= membership_plural %>" do
    @member.stub!(:save).and_return(false)
    post :create
    response.should render_template("new")
  end

  it "should have a @<%= membership_singular %> on POST to /<%= membership_plural %>" do
    post :create
    assigns[:<%= membership_singular %>].should == @member
  end

  it "should redirect to /<%= membership_plural %> on DELETE to /<%= membership_plural %>/1" do
    delete :destroy, :id => '1'
    response.should redirect_to("/<%= membership_plural %>")
  end

  it "should have a @<%= membership_singular %> on DELETE to /<%= membership_plural %>/1" do
    delete :destroy, :id => '1'
    assigns[:<%= membership_singular %>].should == @member
  end
end
