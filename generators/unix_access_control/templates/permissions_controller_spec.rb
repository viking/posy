require File.dirname(__FILE__) + '/../spec_helper'

describe "the <%= permission_plural %> controller when no one is logged in" do
  controller_name :<%= permission_plural %>

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

describe "the <%= permission_plural %> controller when an admin is logged in" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @member     = mock_model(<%= permission_class %>)
    @collection = [@<%= permission_singular %>]

    <%= permission_class %>.stub!(:new).and_return(@member)
    <%= permission_class %>.stub!(:find).and_return(@member)
    @member.stub!(:save).and_return(true)
    @member.stub!(:update_attributes).and_return(true)
    @member.stub!(:destroy).and_return(@member)
    @member.stub!(:controller).and_return(nil)
  end

  it "should GET /<%= permission_plural %> successfully" do
    <%= permission_class %>.stub!(:find).and_return(@collection)
    get :index
    response.should be_success
  end

  it "should have @<%= permission_plural %> after GET /<%= permission_plural %>" do
    <%= permission_class %>.stub!(:find).and_return(@collection)
    get :index
    assigns[:<%= permission_plural %>].should == @collection
  end

  it "should GET /<%= permission_plural %>/1 successfully" do
    get :show, :id => "1"
    response.should be_success
  end

  it "should have a @<%= permission_singular %> after GET /<%= permission_plural %>/1" do
    get :show, :id => "1"
    assigns[:<%= permission_singular %>].should == @member
  end

  it "should GET /<%= permission_plural %>/new successfully" do
    get :new
    response.should be_success
  end

  it "should have a @<%= permission_singular %> after GET /<%= permission_plural %>/new" do
    get :new
    assigns[:<%= permission_singular %>].should == @member
  end

  it "should GET /<%= permission_plural %>/1;edit successfully" do
    get :show, :id => "1"
    response.should be_success
  end

  it "should have a @<%= permission_singular %> after GET /<%= permission_plural %>/1;edit" do
    get :show, :id => "1"
    assigns[:<%= permission_singular %>].should == @member
  end

  it "should redirect to /<%= permission_plural %>/:id on valid POST to /<%= permission_plural %>" do
    post :create
    response.should redirect_to(:action => 'show', :id => @member.id)
  end

  it "should render 'new' on invalid POST to /<%= permission_plural %>" do
    @member.stub!(:save).and_return(false)
    post :create
    response.should render_template("new")
  end

  it "should have a @<%= permission_singular %> on POST to /<%= permission_plural %>" do
    post :create
    assigns[:<%= permission_singular %>].should == @member
  end

  it "should redirect to /<%= permission_plural %>/:id on valid PUT to /<%= permission_plural %>/1" do
    put :update, :id => '1', :<%= permission_singular %> => { }
    response.should redirect_to(:action => 'show', :id => @member.id)
  end

  it "should render 'edit' on invalid PUT to /<%= permission_plural %>/1" do
    @member.stub!(:update_attributes).and_return(false)
    put :update, :id => '1', :<%= permission_singular %> => { }
    response.should render_template("edit")
  end

  it "should have a @<%= permission_singular %> on PUT to /<%= permission_plural %>/1" do
    put :update, :id => '1', :<%= permission_singular %> => { }
    assigns[:<%= permission_singular %>].should == @member
  end

  it "should redirect to /<%= permission_plural %> on DELETE to /<%= permission_plural %>/1" do
    delete :destroy, :id => '1'
    response.should redirect_to("/<%= permission_plural %>")
  end

  it "should have a @<%= permission_singular %> on DELETE to /<%= permission_plural %>/1" do
    delete :destroy, :id => '1'
    assigns[:<%= permission_singular %>].should == @member
  end
end
