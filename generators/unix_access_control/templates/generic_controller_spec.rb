require File.dirname(__FILE__) + '/../spec_helper'

describe "the <%= thing_plural %> controller when no one is logged in" do
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

describe "the <%= thing_plural %> controller when an admin is logged in" do
  controller_name :<%= thing_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @member     = mock_model(<%= thing_class %>)
    @collection = [@<%= thing_singular %>]

    <%= thing_class %>.stub!(:new).and_return(@member)
    <%= thing_class %>.stub!(:find).and_return(@member)
    @member.stub!(:save).and_return(true)
    @member.stub!(:update_attributes).and_return(true)
    @member.stub!(:destroy).and_return(@member)
  end

  it "should GET /<%= thing_plural %> successfully" do
    <%= thing_class %>.stub!(:find).and_return(@collection)
    get :index
    response.should be_success
  end

  it "should have @<%= thing_plural %> after GET /<%= thing_plural %>" do
    <%= thing_class %>.stub!(:find).and_return(@collection)
    get :index
    assigns[:<%= thing_plural %>].should == @collection
  end

  it "should GET /<%= thing_plural %>/1 successfully" do
    get :show, :id => "1"
    response.should be_success
  end

  it "should have a @<%= thing_singular %> after GET /<%= thing_plural %>/1" do
    get :show, :id => "1"
    assigns[:<%= thing_singular %>].should == @member
  end

  it "should GET /<%= thing_plural %>/new successfully" do
    get :new
    response.should be_success
  end

  it "should have a @<%= thing_singular %> after GET /<%= thing_plural %>/new" do
    get :new
    assigns[:<%= thing_singular %>].should == @member
  end

  it "should GET /<%= thing_plural %>/1;edit successfully" do
    get :show, :id => "1"
    response.should be_success
  end

  it "should have a @<%= thing_singular %> after GET /<%= thing_plural %>/1;edit" do
    get :show, :id => "1"
    assigns[:<%= thing_singular %>].should == @member
  end

  it "should redirect to /<%= thing_plural %>/:id on valid POST to /<%= thing_plural %>" do
    post :create
    response.should redirect_to(:action => 'show', :id => @member.id)
  end

  it "should render 'new' on invalid POST to /<%= thing_plural %>" do
    @member.stub!(:save).and_return(false)
    post :create
    response.should render_template("new")
  end

  it "should have a @<%= thing_singular %> on POST to /<%= thing_plural %>" do
    post :create
    assigns[:<%= thing_singular %>].should == @member
  end

  it "should redirect to /<%= thing_plural %>/:id on valid PUT to /<%= thing_plural %>/1" do
    put :update, :id => '1'
    response.should redirect_to(:action => 'show', :id => @member.id)
  end

  it "should render 'edit' on invalid PUT to /<%= thing_plural %>/1" do
    @member.stub!(:update_attributes).and_return(false)
    put :update, :id => '1'
    response.should render_template("edit")
  end

  it "should have a @<%= thing_singular %> on PUT to /<%= thing_plural %>/1" do
    put :update, :id => '1'
    assigns[:<%= thing_singular %>].should == @member
  end

  it "should redirect to /<%= thing_plural %> on DELETE to /<%= thing_plural %>/1" do
    delete :destroy, :id => '1'
    response.should redirect_to("/<%= thing_plural %>")
  end

  it "should have a @<%= thing_singular %> on DELETE to /<%= thing_plural %>/1" do
    delete :destroy, :id => '1'
    assigns[:<%= thing_singular %>].should == @member
  end
end
