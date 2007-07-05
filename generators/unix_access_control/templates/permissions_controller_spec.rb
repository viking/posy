require File.dirname(__FILE__) + '/../spec_helper'

describe <%= permission_plural_class %>Controller, "#route_for" do

  it "should map { :controller => '<%= permission_plural %>', :action => 'index' } to /<%= permission_plural %>" do
    route_for(:controller => "<%= permission_plural %>", :action => "index").should == "/<%= permission_plural %>"
  end
  
  it "should map { :controller => '<%= permission_plural %>', :action => 'new' } to /<%= permission_plural %>/new" do
    route_for(:controller => "<%= permission_plural %>", :action => "new").should == "/<%= permission_plural %>/new"
  end
  
  it "should map { :controller => '<%= permission_plural %>', :action => 'show', :id => 1 } to /<%= permission_plural %>/1" do
    route_for(:controller => "<%= permission_plural %>", :action => "show", :id => 1).should == "/<%= permission_plural %>/1"
  end
  
  it "should map { :controller => '<%= permission_plural %>', :action => 'edit', :id => 1 } to /<%= permission_plural %>/1;edit" do
    route_for(:controller => "<%= permission_plural %>", :action => "edit", :id => 1).should == "/<%= permission_plural %>/1;edit"
  end
  
  it "should map { :controller => '<%= permission_plural %>', :action => 'update', :id => 1} to /<%= permission_plural %>/1" do
    route_for(:controller => "<%= permission_plural %>", :action => "update", :id => 1).should == "/<%= permission_plural %>/1"
  end
  
  it "should map { :controller => '<%= permission_plural %>', :action => 'destroy', :id => 1} to /<%= permission_plural %>/1" do
    route_for(:controller => "<%= permission_plural %>", :action => "destroy", :id => 1).should == "/<%= permission_plural %>/1"
  end
  
end

describe <%= permission_plural_class %>Controller, "when not logged in" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= permission_plural %>/ as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= permission_plural %>/1 as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= permission_plural %>/1;edit as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= permission_plural %>/new as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= permission_plural %>/new.js as admin" do

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

  it "should set @controllers when params[:<%= permission_singular %>][:resource_type] is 'Controller'" do
    UnixAccessControl.stub!(:controllers).and_return(%w{vampires})
    
    get :new, :format => 'js', :<%= permission_singular %> => { :resource_type => 'Controller' }
    assigns[:controllers].should == %w{vampires}
  end

  it "should set @resources when params[:<%= permission_singular %>][:resource_type] is 'Pocky'" do
    @pockys = Array.new(5) { |i| Pocky.new(i+1) }
    Pocky.stub!(:find).and_return(@pockys)

    get :new, :format => 'js', :<%= permission_singular %> => { :resource_type => 'Pocky' }
    assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
  end
end

describe <%= permission_plural_class %>Controller, "handling POST /<%= permission_plural %>/ as admin" do

  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    login_as(:admin)
    @<%= permission_singular %> = mock_model(<%= permission_class %>)
    @resource_types = %w{Lion Tiger Bear}

    <%= permission_class %>.stub!(:new).and_return(@<%= permission_singular %>)
    <%= group_class %>.stub!(:find).and_return([])
    @<%= permission_singular %>.stub!(:save).and_return(true)
    @<%= permission_singular %>.stub!(:controller).and_return(nil)
    UnixAccessControl.stub!(:models).and_return(@resource_types)
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

  it "should set @resource_types when invalid" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    post :create
    assigns[:resource_types].should == ['Controller'] + @resource_types
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

  it "should set @controllers when invalid and params[:<%= permission_singular %>][:resource_type] is 'Controller'" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    UnixAccessControl.stub!(:controllers).and_return(%w{vampires})
    
    post :create, :<%= permission_singular %> => { :resource_type => 'Controller' }
    assigns[:controllers].should == %w{vampires}
  end

  it "should set @resources when invalid params[:<%= permission_singular %>][:resource_type] is 'Pocky'" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    @pockys = Array.new(5) { |i| Pocky.new(i+1) }
    Pocky.stub!(:find).and_return(@pockys)

    post :create, :<%= permission_singular %> => { :resource_type => 'Pocky' }
    assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
  end
end

describe <%= permission_plural_class %>Controller, "handling PUT /<%= permission_plural %>/1 as admin" do

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

describe <%= permission_plural_class %>Controller, "handling DELETE /<%= permission_plural %>/1 as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= group_plural %>/1/<%= permission_plural %>/ as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= group_plural %>/1/<%= permission_plural %>/1 as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= group_plural %>/1/<%= permission_plural %>/1;edit as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= group_plural %>/1/<%= permission_plural %>/new as admin" do

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

describe <%= permission_plural_class %>Controller, "handling GET /<%= group_plural %>/1/<%= permission_plural %>/new.js as admin" do

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

  it "should set @controllers when params[:<%= permission_singular %>][:resource_type] is 'Controller'" do
    UnixAccessControl.stub!(:controllers).and_return(%w{vampires})
    
    get :new, :format => 'js', :<%= group_singular %>_id => '1', :<%= permission_singular %> => { :resource_type => 'Controller' }
    assigns[:controllers].should == %w{vampires}
  end

  it "should set @resources when params[:<%= permission_singular %>][:resource_type] is 'Pocky'" do
    @pockys = Array.new(5) { |i| Pocky.new(i+1) }
    Pocky.stub!(:find).and_return(@pockys)

    get :new, :format => 'js', :<%= group_singular %>_id => '1', :<%= permission_singular %> => { :resource_type => 'Pocky' }
    assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
  end
end

describe <%= permission_plural_class %>Controller, "handling POST /<%= group_plural %>/1/<%= permission_plural %>/ as admin" do

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

  it "should set @controllers when invalid and params[:<%= permission_singular %>][:resource_type] is 'Controller'" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    UnixAccessControl.stub!(:controllers).and_return(%w{vampires})
    
    post :create, :<%= permission_singular %> => { :resource_type => 'Controller' }
    assigns[:controllers].should == %w{vampires}
  end

  it "should set @resources when invalid params[:<%= permission_singular %>][:resource_type] is 'Pocky'" do
    @<%= permission_singular %>.stub!(:save).and_return(false)
    @pockys = Array.new(5) { |i| Pocky.new(i+1) }
    Pocky.stub!(:find).and_return(@pockys)

    post :create, :<%= permission_singular %> => { :resource_type => 'Pocky' }
    assigns[:resources].should == @pockys.collect { |p| [p.name, p.id] }
  end
end

describe <%= permission_plural_class %>Controller, "handling PUT /<%= group_plural %>/1/<%= permission_plural %>/1 as admin" do

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

describe <%= permission_plural_class %>Controller, "handling DELETE /<%= group_plural %>/1/<%= permission_plural %>/1 as admin" do

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
