require File.dirname(__FILE__) + '/../spec_helper'

describe "requesting /<%= membership_plural %>/* when not logged in" do
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

describe "requesting /<%= membership_plural %>/* as admin" do
  controller_name :<%= membership_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @member     = mock_model(<%= membership_class %>)
    @collection = [@member]

    <%= membership_class %>.stub!(:new).and_return(@member)
    <%= membership_class %>.stub!(:find).and_return(@member)
    <%= user_class %>.stub!(:find).and_return([])
    <%= group_class %>.stub!(:find).and_return([])
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

  it "should have @<%= user_plural %> after GET /<%= membership_plural %>/new" do
    get :new
    assigns[:<%= user_plural %>].should == []
  end

  it "should have @<%= group_plural %> after GET /<%= membership_plural %>/new" do
    get :new
    assigns[:<%= group_plural %>].should == []
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

describe "requesting /<%= group_plural %>/1/<%= membership_plural %>/* as admin" do
  controller_name :<%= membership_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= membership_singular %> = mock_model(<%= membership_class %>)
    @<%= membership_plural %> = [@<%= membership_singular %>]
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= membership_singular %>_association = stub("association", :find => @<%= membership_singular %>, :build => @<%= membership_singular %>)

    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
    <%= user_class %>.stub!(:find).and_return([])
    @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)
    @<%= membership_singular %>.stub!(:save).and_return(true)
    @<%= membership_singular %>.stub!(:update_attributes).and_return(true)
    @<%= membership_singular %>.stub!(:destroy).and_return(@<%= membership_singular %>)
  end

  it "should GET /<%= group_plural %>/1/<%= membership_plural %> successfully" do
    @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_plural %>)

    get :index, :<%= group_singular %>_id => "1"
    response.should be_success
  end

  it "should have @<%= membership_plural %> after GET /<%= group_plural %>/1/<%= membership_plural %>" do
    @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_plural %>)

    get :index, :<%= group_singular %>_id => "1"
    assigns[:<%= membership_plural %>].should == @<%= membership_plural %>
  end

  it "should have a @<%= group_singular %> after GET /<%= group_plural %>/1/<%= membership_plural %>" do
    @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_plural %>)

    get :index, :<%= group_singular %>_id => "1"
    assigns[:<%= group_singular %>].should == <%= group_plural %>(:admin) 
  end

  it "should GET /<%= group_plural %>/1/<%= membership_plural %>/1 successfully" do
    get :show, :id => "1", :<%= group_singular %>_id => "1"
    response.should be_success
  end

  it "should have a @<%= membership_singular %> after GET /<%= group_plural %>/1/<%= membership_plural %>/1" do
    get :show, :id => "1", :<%= group_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= group_singular %> after GET /<%= group_plural %>/1/<%= membership_plural %>/1" do
    get :show, :id => "1", :<%= group_singular %>_id => "1"
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end

  it "should GET /<%= group_plural %>/1/<%= membership_plural %>/new successfully" do
    get :new, :<%= group_singular %>_id => "1"
    response.should be_success
  end

  it "should have a @<%= membership_singular %> after GET /<%= group_plural %>/1/<%= membership_plural %>/new" do
    get :new, :<%= group_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= group_singular %> after GET /<%= group_plural %>/1/<%= membership_plural %>/new" do
    get :new, :<%= group_singular %>_id => "1"
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end

  it "should have @<%= user_plural %> after GET /<%= group_plural %>/1/<%= membership_plural %>/new" do
    get :new, :<%= group_singular %>_id => "1"
    assigns[:<%= user_plural %>].should == [] 
  end

  it "should redirect to /<%= group_plural %>/:id/<%= membership_plural %>/:id on valid POST to /<%= group_plural %>/1/<%= membership_plural %>" do
    post :create, :<%= group_singular %>_id => "1"
    response.should redirect_to(<%= group_singular %>_<%= membership_singular %>_url(@<%= group_singular %>, @<%= membership_singular %>))
  end

  it "should render 'new' on invalid POST to /<%= group_plural %>/1/<%= membership_plural %>" do
    @<%= membership_singular %>.stub!(:save).and_return(false)

    post :create, :<%= group_singular %>_id => "1"
    response.should render_template("new")
  end

  it "should have a @<%= membership_singular %> on POST to /<%= group_plural %>/1/<%= membership_plural %>" do
    post :create, :<%= group_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= group_singular %> on POST to /<%= group_plural %>/1/<%= membership_plural %>" do
    get :new, :<%= group_singular %>_id => "1"
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end

  it "should have @<%= user_plural %> on POST to /<%= group_plural %>/1/<%= membership_plural %>" do
    get :new, :<%= group_singular %>_id => "1"
    assigns[:<%= user_plural %>].should == [] 
  end

  it "should redirect to /<%= group_plural %>/1/<%= membership_plural %> on DELETE to /<%= group_plural %>/1/<%= membership_plural %>/1" do
    delete :destroy, :id => '1', :<%= group_singular %>_id => "1"
    response.should redirect_to(<%= group_singular %>_<%= membership_plural %>_url(@<%= group_singular %>))
  end

  it "should have a @<%= membership_singular %> on DELETE to /<%= group_plural %>/1/<%= membership_plural %>/1" do
    delete :destroy, :id => '1', :<%= group_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= group_singular %> on DELETE to /<%= group_plural %>/1/<%= membership_plural %>/1" do
    delete :destroy, :id => '1', :<%= group_singular %>_id => "1"
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end
end

describe "requesting /<%= user_plural %>/1/<%= membership_plural %>/* as admin" do
  controller_name :<%= membership_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= membership_singular %> = mock_model(<%= membership_class %>)
    @<%= membership_plural %> = [@<%= membership_singular %>]
    @<%= user_singular %> = mock_model(<%= user_class %>)
    @<%= membership_singular %>_association = stub("association", :find => @<%= membership_singular %>, :build => @<%= membership_singular %>)

    <%= group_class %>.stub!(:find).and_return([])
    <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
    @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)
    @<%= membership_singular %>.stub!(:save).and_return(true)
    @<%= membership_singular %>.stub!(:update_attributes).and_return(true)
    @<%= membership_singular %>.stub!(:destroy).and_return(@<%= membership_singular %>)
  end

  it "should GET /<%= user_plural %>/1/<%= membership_plural %> successfully" do
    @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_plural %>)

    get :index, :<%= user_singular %>_id => "1"
    response.should be_success
  end

  it "should have @<%= membership_plural %> after GET /<%= user_plural %>/1/<%= membership_plural %>" do
    @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_plural %>)

    get :index, :<%= user_singular %>_id => "1"
    assigns[:<%= membership_plural %>].should == @<%= membership_plural %>
  end

  it "should have a @<%= user_singular %> after GET /<%= user_plural %>/1/<%= membership_plural %>" do
    @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_plural %>)

    get :index, :<%= user_singular %>_id => "1"
    assigns[:<%= user_singular %>].should == @<%= user_singular %> 
  end

  it "should GET /<%= user_plural %>/1/<%= membership_plural %>/1 successfully" do
    get :show, :id => "1", :<%= user_singular %>_id => "1"
    response.should be_success
  end

  it "should have a @<%= membership_singular %> after GET /<%= user_plural %>/1/<%= membership_plural %>/1" do
    get :show, :id => "1", :<%= user_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= user_singular %> after GET /<%= user_plural %>/1/<%= membership_plural %>/1" do
    get :show, :id => "1", :<%= user_singular %>_id => "1"
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end

  it "should GET /<%= user_plural %>/1/<%= membership_plural %>/new successfully" do
    get :new, :<%= user_singular %>_id => "1"
    response.should be_success
  end

  it "should have a @<%= membership_singular %> after GET /<%= user_plural %>/1/<%= membership_plural %>/new" do
    get :new, :<%= user_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= user_singular %> after GET /<%= user_plural %>/1/<%= membership_plural %>/new" do
    get :new, :<%= user_singular %>_id => "1"
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end

  it "should have @<%= group_plural %> after GET /<%= user_plural %>/1/<%= membership_plural %>/new" do
    get :new, :<%= user_singular %>_id => "1"
    assigns[:<%= group_plural %>].should == [] 
  end

  it "should redirect to /<%= user_plural %>/:id/<%= membership_plural %>/:id on valid POST to /<%= user_plural %>/1/<%= membership_plural %>" do
    post :create, :<%= user_singular %>_id => "1"
    response.should redirect_to(<%= user_singular %>_<%= membership_singular %>_url(@<%= user_singular %>, @<%= membership_singular %>))
  end

  it "should render 'new' on invalid POST to /<%= user_plural %>/1/<%= membership_plural %>" do
    @<%= membership_singular %>.stub!(:save).and_return(false)

    post :create, :<%= user_singular %>_id => "1"
    response.should render_template("new")
  end

  it "should have a @<%= membership_singular %> on POST to /<%= user_plural %>/1/<%= membership_plural %>" do
    post :create, :<%= user_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= user_singular %> on POST to /<%= user_plural %>/1/<%= membership_plural %>" do
    get :new, :<%= user_singular %>_id => "1"
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end

  it "should have @<%= group_plural %> on POST to /<%= user_plural %>/1/<%= membership_plural %>" do
    get :new, :<%= user_singular %>_id => "1"
    assigns[:<%= group_plural %>].should == [] 
  end

  it "should redirect to /<%= user_plural %>/1/<%= membership_plural %> on DELETE to /<%= user_plural %>/1/<%= membership_plural %>/1" do
    delete :destroy, :id => '1', :<%= user_singular %>_id => "1"
    response.should redirect_to(<%= user_singular %>_<%= membership_plural %>_url(@<%= user_singular %>))
  end

  it "should have a @<%= membership_singular %> on DELETE to /<%= user_plural %>/1/<%= membership_plural %>/1" do
    delete :destroy, :id => '1', :<%= user_singular %>_id => "1"
    assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
  end

  it "should have a @<%= user_singular %> on DELETE to /<%= user_plural %>/1/<%= membership_plural %>/1" do
    delete :destroy, :id => '1', :<%= user_singular %>_id => "1"
    assigns[:<%= user_singular %>].should == @<%= user_singular %>
  end
end
