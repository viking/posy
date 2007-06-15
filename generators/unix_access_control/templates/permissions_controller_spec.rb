require File.dirname(__FILE__) + '/../spec_helper'

describe "requesting /<%= permission_plural %>/* when not logged in" do
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

describe "GET /<%= permission_plural %>/ as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    <%= permission_class %>.stub!(:find).and_return([])

    get :index
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= permission_plural %>" do
    assigns[:<%= permission_plural %>].should == []
  end
end

describe "GET /<%= permission_plural %>/1 as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    <%= permission_class %>.stub!(:find).and_return(@<%= permission_singular %>)

    get :show, :id => "1"
  end

  it "should be successfully" do
    response.should be_success
  end

  it "should set @<%= permission_singular %>" do
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end
end

describe "GET /<%= permission_plural %>/1;edit as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    <%= permission_class %>.stub!(:find).and_return(@<%= permission_singular %>)

    get :edit, :id => "1"
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= permission_singular %>" do
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end
end

describe "GET /<%= permission_plural %>/new as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @resource_types = %w{Lion Tiger Bear}
    <%= permission_class %>.stub!(:new).and_return(@<%= permission_singular %>)
    <%= group_class %>.stub!(:find).and_return([])
    UnixAccessControl.stub!(:models).and_return(@resource_types)
  end

  it "should be successful" do
    get :new
    response.should be_success
  end

  it "should render template 'new'" do
    get :new
    response.should render_template('new')
  end

  it "should set @<%= permission_singular %>" do
    get :new
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_plural %>" do
    get :new
    assigns[:<%= group_plural %>].should == [] 
  end

  it "should set @resource_types" do
    get :new
    assigns[:resource_types].should == ['Controller'] + @resource_types
  end

  it "should call UnixAccessControl.models" do
    UnixAccessControl.should_receive(:models).and_return(@resource_types)
    get :new
  end
end

describe "GET /<%= permission_plural %>/new.js as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)

    <%= permission_class %>.stub!(:new).and_return(@<%= permission_singular %>)
    <%= group_class %>.stub!(:find).and_return([])
  end

  it "should be successful" do
    get :new, :format => 'js'
    response.should be_success
  end

  it "should render template 'new.rjs'" do
    get :new, :format => 'js'
    response.should render_template('new.rjs')
  end

  it "should set @controllers when params[:value] is 'Controller'" do
    UnixAccessControl.stub!(:controllers).and_return(%w{vampires})
    
    get :new, :format => 'js', :value => 'Controller'
    assigns[:controllers].should == %w{vampires}
  end

  it "should set @resources when params[:value] is 'Pocky'" do
    @pockys = Array.new(5) { |i| Pocky.new(i+1) }
    Pocky.stub!(:find).and_return(@pockys)

    get :new, :format => 'js', :value => 'Pocky'
    assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
  end
end

describe "POST /<%= permission_plural %>/ as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)

    <%= permission_class %>.stub!(:new).and_return(@<%= permission_singular %>)
    <%= group_class %>.stub!(:find).and_return([])
    @<%= permission_singular %>.stub!(:save).and_return(true)
    @<%= permission_singular %>.stub!(:controller).and_return(nil)
  end
  
  it "should redirect to /<%= permission_plural %>/:id when valid" do
    post :create
    response.should redirect_to(<%= permission_singular %>_url(@<%= permission_singular %>))
  end

  it "should render 'new' when invalid" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    post :create
    response.should render_template("new")
  end

  it "should set @<%= permission_singular %>" do
    post :create
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_plural %>" do
    post :create
    assigns[:<%= group_plural %>].should == [] 
  end

  it "should set @<%= permission_singular %>'s resource_type to nil when @<%= permission_singular %>.controller exists" do
    @<%= permission_singular %>.stub!(:controller).and_return("vampires")

    @<%= permission_singular %>.should_receive(:resource_type=).with(nil)
    post :create
  end
end

describe "PUT /<%= permission_plural %>/1 as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)

    <%= permission_class %>.stub!(:find).and_return(@<%= permission_singular %>)
    <%= group_class %>.stub!(:find).and_return([])
    @<%= permission_singular %>.stub!(:update_attributes).and_return(true)
    @<%= permission_singular %>.stub!(:controller).and_return(nil)
  end
  
  it "should redirect to /<%= permission_plural %>/:id when valid" do
    put :update, :id => "1", :<%= permission_singular %> => { }
    response.should redirect_to(<%= permission_singular %>_url(@<%= permission_singular %>))
  end

  it "should render 'edit' when invalid" do
    @<%= permission_singular %>.stub!(:update_attributes).and_return(false)
    put :update, :id => "1", :<%= permission_singular %> => { }
    response.should render_template("edit")
  end

  it "should set @<%= permission_singular %>" do
    put :update, :id => "1", :<%= permission_singular %> => { }
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should remove all parameters except can_read, can_write, and is_sticky" do
    put :update, :id => "1", :<%= permission_singular %> => { 
      :partical => "man", 
      :triangle => "man", 
      :can_read => true, 
      :can_write => true, 
      :is_sticky => true
    }
    @controller.params[:<%= permission_singular %>].keys.sort.should == %w{can_read can_write is_sticky}
  end
end

describe "DELETE /<%= permission_plural %>/1 as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %>  = mock_model(<%= permission_class %>)

    <%= permission_class %>.stub!(:find).and_return(@<%= permission_singular %>)
    @<%= permission_singular %>.stub!(:destroy).and_return(@<%= permission_singular %>)
  end

  it "should redirect to /<%= permission_plural %>" do
    delete :destroy, :id => '1'
    response.should redirect_to(<%= permission_plural %>_url)
  end

  it "should set @<%= permission_singular %>" do
    delete :destroy, :id => '1'
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end
end

describe "GET /<%= group_plural %>/1/<%= permission_plural %>/ as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return([])
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)

    get :index, :<%= group_singular %>_id => '1'
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= permission_plural %>" do
    assigns[:<%= permission_plural %>].should == []
  end

  it "should set @<%= group_singular %>" do
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end
end

describe "GET /<%= group_plural %>/1/<%= permission_plural %>/1 as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :find => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)

    get :show, :id => "1", :<%= group_singular %>_id => '1'
  end

  it "should be successfully" do
    response.should be_success
  end

  it "should set @<%= permission_singular %>" do
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_singular %>" do
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end
end

describe "GET /<%= group_plural %>/1/<%= permission_plural %>/1;edit as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :find => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)

    get :edit, :id => "1", :<%= group_singular %>_id => '1'
  end

  it "should be successful" do
    response.should be_success
  end

  it "should set @<%= permission_singular %>" do
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_singular %>" do
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end
end

describe "GET /<%= group_plural %>/1/<%= permission_plural %>/new as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :build => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)

    get :new, :<%= group_singular %>_id => '1'
  end

  it "should be successful" do
    response.should be_success
  end

  it "should render template 'new'" do
    response.should render_template('new')
  end

  it "should set @<%= permission_singular %>" do
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_singular %>" do
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end
end

describe "GET /<%= group_plural %>/1/<%= permission_plural %>/new.js as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :build => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
  end

  it "should be successful" do
    get :new, :format => 'js', :<%= group_singular %>_id => '1'
    response.should be_success
  end

  it "should render template 'new.rjs'" do
    get :new, :format => 'js', :<%= group_singular %>_id => '1'
    response.should render_template('new.rjs')
  end

  it "should set @controllers when params[:value] is 'Controller'" do
    UnixAccessControl.stub!(:controllers).and_return(%w{vampires})
    
    get :new, :format => 'js', :<%= group_singular %>_id => '1', :value => 'Controller'
    assigns[:controllers].should == %w{vampires}
  end

  it "should set @resources when params[:value] is 'Pocky'" do
    @pockys = Array.new(5) { |i| Pocky.new(i+1) }
    Pocky.stub!(:find).and_return(@pockys)

    get :new, :format => 'js', :<%= group_singular %>_id => '1', :value => 'Pocky'
    assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
  end
end

describe "POST /<%= group_plural %>/1/<%= permission_plural %>/ as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :build => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
    @<%= permission_singular %>.stub!(:save).and_return(true)
    @<%= permission_singular %>.stub!(:controller).and_return(nil)
  end
  
  it "should redirect to /<%= group_plural %>/1/<%= permission_plural %>/:id when valid" do
    post :create, :<%= group_singular %>_id => '1'
    response.should redirect_to(<%= group_singular %>_<%= permission_singular %>_url(@<%= group_singular %>, @<%= permission_singular %>))
  end

  it "should render 'new' when invalid" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    post :create, :<%= group_singular %>_id => '1'
    response.should render_template("new")
  end

  it "should set @<%= permission_singular %>" do
    post :create, :<%= group_singular %>_id => '1'
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_singular %>" do
    post :create, :<%= group_singular %>_id => '1'
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end

  it "should set @<%= permission_singular %>'s resource_type to nil when @<%= permission_singular %>.controller exists" do
    @<%= permission_singular %>.stub!(:controller).and_return("vampires")

    @<%= permission_singular %>.should_receive(:resource_type=).with(nil)
    post :create, :<%= group_singular %>_id => '1'
  end
end

describe "PUT /<%= group_plural %>/1/<%= permission_plural %>/1 as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :find => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
    @<%= permission_singular %>.stub!(:update_attributes).and_return(true)
    @<%= permission_singular %>.stub!(:controller).and_return(nil)
  end
  
  it "should redirect to /<%= group_plural %>/1/<%= permission_plural %>/:id when valid" do
    put :update, :id => "1", :<%= group_singular %>_id => '1', :<%= permission_singular %> => { }
    response.should redirect_to(<%= group_singular %>_<%= permission_singular %>_url(@<%= group_singular %>, @<%= permission_singular %>))
  end

  it "should render 'edit' when invalid" do
    @<%= permission_singular %>.stub!(:update_attributes).and_return(false)
    put :update, :id => "1", :<%= group_singular %>_id => '1', :<%= permission_singular %> => { }
    response.should render_template("edit")
  end

  it "should set @<%= permission_singular %>" do
    put :update, :id => "1", :<%= group_singular %>_id => '1', :<%= permission_singular %> => { }
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_singular %>" do
    put :update, :id => "1", :<%= group_singular %>_id => '1', :<%= permission_singular %> => { }
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end

  it "should remove all parameters except can_read, can_write, and is_sticky" do
    put :update, :id => "1", :<%= group_singular %>_id => '1', :<%= permission_singular %> => { 
      :partical => "man", 
      :triangle => "man", 
      :can_read => true, 
      :can_write => true, 
      :is_sticky => true
    }
    @controller.params[:<%= permission_singular %>].keys.sort.should == %w{can_read can_write is_sticky}
  end
end

describe "DELETE /<%= group_plural %>/1/<%= permission_plural %>/1 as admin" do
  controller_name :<%= permission_plural %>

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= group_singular %> = mock_model(<%= group_class %>)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= permission_singular %>_association = stub("association", :find => @<%= permission_singular %>)
    @<%= group_singular %>.stub!(:<%= permission_plural %>).and_return(@<%= permission_singular %>_association)
    <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
    @<%= permission_singular %>.stub!(:destroy).and_return(@<%= permission_singular %>)

    delete :destroy, :id => '1', :<%= group_singular %>_id => '1'
  end

  it "should redirect to /<%= group_plural %>/1/<%= permission_plural %>" do
    response.should redirect_to(<%= group_singular %>_<%= permission_plural %>_url(@<%= group_singular %>))
  end

  it "should set @<%= permission_singular %>" do
    assigns[:<%= permission_singular %>].should == @<%= permission_singular %>
  end

  it "should set @<%= group_singular %>" do
    assigns[:<%= group_singular %>].should == @<%= group_singular %>
  end
end
