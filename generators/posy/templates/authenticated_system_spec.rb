require File.dirname(__FILE__) + '/../spec_helper'

describe "a controller that uses AuthenticatedSystem" do
  before(:all) do
    @@counter = 1
  end

  before(:each) do
    klass_name = "FooTest#{@@counter}Controller"
    eval <<-EOF
      class #{klass_name} < ActionController::Base
        include AuthenticatedSystem
      end
    EOF
    @klass = klass_name.constantize
    @@counter += 1
  end

  it "should have default action_<%= permission_plural %>" do
    @klass.action_<%= permission_plural %>.should == AuthenticatedSystem::DEFAULT_ACTION_PERMISSIONS
  end

  it "should update action_<%= permission_plural %>" do
    @klass.action_<%= permission_plural %>({'r' => %w{index}})
    @klass.action_<%= permission_plural %>['r'].should == %w{index}
  end

  it "should have default resource_actions" do
    @klass.resource_actions.should == AuthenticatedSystem::DEFAULT_RESOURCE_ACTIONS
  end

  it "should add resource_actions" do
    @klass.resource_actions(:foo, :bar, :blah)
    @klass.resource_actions[-3..-1].should == %w{foo bar blah}
  end

  it "should remove resource_actions" do
    @klass.remove_resource_actions(:show, :edit)
    @klass.resource_actions.should == AuthenticatedSystem::DEFAULT_RESOURCE_ACTIONS - %w{show edit}
  end

  it "should have a resource_model_name" do
    @klass.resource_model_name.should == @klass.controller_name.singularize.classify
  end

  it "should change its resource_model_name" do
    @klass.resource_model_name(:monkey)
    @klass.resource_model_name.should == "Monkey"
  end

  it "should have default sticky_actions" do
    @klass.sticky_actions.should == AuthenticatedSystem::DEFAULT_STICKY_ACTIONS
  end

  it "should add sticky_actions" do
    @klass.sticky_actions(:foo, :bar, :blah)
    @klass.sticky_actions[-3..-1].should == %w{foo bar blah}
  end

  it "should remove sticky_actions" do
    @klass.remove_sticky_actions(:edit, :update)
    @klass.sticky_actions.should == AuthenticatedSystem::DEFAULT_STICKY_ACTIONS - %w{edit update}
  end

  describe "#access_hierarchies" do
    it "should be empty by default" do
      @klass.access_hierarchies.should == []
    end

    it "should change when given arguments" do
      @klass.access_hierarchies([:foo, :bar], [:baz, :boof])
      @klass.access_hierarchies.should == [%w{foo bar}, %w{baz boof}]
    end
  end
end

class BarTestController < ActionController::Base
  include AuthenticatedSystem

  action_<%= permission_plural %>('r' => %w{index})
  resource_actions(:foo, :bar)
  sticky_actions(:tro<%= user_plural %>, :pants)
end


describe "a subclass of a controller that uses AuthenticatedSystem" do
  before(:all) do
    @@counter = 100
  end

  before(:each) do
    klass_name = "FooTest#{@@counter}Controller"
    eval <<-EOF
      class #{klass_name} < BarTestController
        include AuthenticatedSystem
      end
    EOF
    @klass = klass_name.constantize
    @@counter += 1
  end

  it "should inherit its super's action_<%= permission_plural %>" do
    @klass.action_<%= permission_plural %>['r'].should == %w{index}
  end

  it "should change its own action_<%= permission_plural %> without changing its super's action_<%= permission_plural %>" do
    @klass.action_<%= permission_plural %>('w' => %w{fufuberry})
    BarTestController.action_<%= permission_plural %>['w'].should_not == %w{fufuberry}
  end

  it "should inherit its super's resource_actions" do
    @klass.resource_actions.should == AuthenticatedSystem::DEFAULT_RESOURCE_ACTIONS + %w{foo bar}
  end

  it "should add its own resource_actions without changing its super's resource_actions" do
    @klass.resource_actions(:fufuberry)
    BarTestController.resource_actions[-1].should_not == "fufuberry"
  end

  it "should remove_resource_actions without changing its super's resource_actions" do
    @klass.remove_resource_actions(:show)
    BarTestController.resource_actions.should include("show")
  end

  it "should not inherit its super's resource_model_name" do
    @klass.resource_model_name.should_not == BarTestController.resource_model_name
  end

  it "should inherit its super's sticky_actions" do
    @klass.sticky_actions.should == AuthenticatedSystem::DEFAULT_STICKY_ACTIONS + %w{tro<%= user_plural %> pants}
  end

  it "should add its own sticky_actions without changing its super's sticky_actions" do
    @klass.sticky_actions(:fufuberry)
    BarTestController.sticky_actions[-1].should_not == "fufuberry"
  end

  it "should remove_sticky_actions without changing its super's sticky_actions" do
    @klass.remove_sticky_actions(:edit)
    BarTestController.sticky_actions.should include("edit")
  end
end

describe "calling chmod in a controller that uses AuthenticatedSystem" do
  before(:all) do
    @@counter = 200
  end

  before(:each) do
    klass_name = "FooTest#{@@counter}Controller"
    eval <<-EOF
      class #{klass_name} < ActionController::Base
        include AuthenticatedSystem
      end
    EOF
    @klass = klass_name.constantize
    @@counter += 1
  end

  it "should raise an error for malformed <%= permission_singular %> strings" do
    lambda { @klass.chmod("foo", :pants) }.should raise_error
  end

  it "should set <%= permission_plural %> for 'foo'" do
    @klass.chmod("rw", :foo)
    @klass.action_<%= permission_plural %>['r'].should include('foo')
    @klass.action_<%= permission_plural %>['w'].should include('foo')
    @klass.action_<%= permission_plural %>['b'].should_not include('foo')
  end

  it "should add <%= permission_plural %> for 'foo'" do
    @klass.chmod("+wb", :foo)
    @klass.action_<%= permission_plural %>['w'].should include('foo')
    @klass.action_<%= permission_plural %>['b'].should include('foo')
  end

  it "should remove <%= permission_plural %> for 'index'" do
    @klass.chmod("-r", :index)
    @klass.action_<%= permission_plural %>['r'].should_not include('index')
  end

  it "should add and remove <%= permission_plural %> for 'index'" do
    @klass.chmod("-r+wb", :index)
    @klass.action_<%= permission_plural %>['r'].should_not include('index')
    @klass.action_<%= permission_plural %>['w'].should include('index')
    @klass.action_<%= permission_plural %>['b'].should include('index')
  end

  it "should set <%= permission_plural %> for 'index' while ignoring <%= permission_plural %> to add or remove" do
    @klass.chmod("rw-r+b", :index)
    @klass.action_<%= permission_plural %>['r'].should include('index')
    @klass.action_<%= permission_plural %>['w'].should include('index')
    @klass.action_<%= permission_plural %>['b'].should_not include('index')
  end
end

class PockyTestController < ActionController::Base
  include AuthenticatedSystem
  resource_model_name :pocky
  before_filter :login_required, :only => :foo

  def foo
  end

  def bar
  end

  def redirect_back
    redirect_back_or_default('/pocky_test/bar')
  end
end

describe PockyTestController, :type => :controller do
  before(:each) do
    @<%= user_singular %> = mock_model(<%= user_class %>)
    @pocky = Pocky.new
    <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
  end

  it "should have a current_<%= user_singular %> when <%= session_singular %>[:<%= user_singular %>] is set" do
    <%= session_singular %>[:<%= user_singular %>] = @<%= user_singular %>.id
    @controller.current_<%= user_singular %>.should == @<%= user_singular %>
  end

  it "should have a :false current_<%= user_singular %> when <%= session_singular %>[:<%= user_singular %>] is not set" do
    @controller.current_<%= user_singular %>.should == :false
  end

  it "should have a nil current_resource when params[:id] is not set" do
    @controller.params = {}
    @controller.send(:current_resource).should be_nil
  end

  it "should call Pocky.find_by_id in current_resource when params[:id] is set" do
    Pocky.stub!(:find_by_id).and_return(@pocky)
    @controller.params = {:id => "123"}
    @controller.send(:current_resource)
  end

  it "should raise an error if current_resource is called with a bad resource_model_name" do
    @controller.stub!(:resource_model_name).and_return("NonExistentClass")
    @controller.params = {:id => "123"}
    lambda { @controller.send(:current_resource) }.should raise_error
  end

  it "should have a nil current_resource when params[:id] refers to a non-existent model" do
    Pocky.stub!(:find_by_id).and_return(nil)
    @controller.params = {:id => "123"}
    @controller.send(:current_resource).should be_nil
  end

  it "should have a nil current_<%= permission_singular %> when <%= session_singular %>[:<%= user_singular %>] is not set" do
    @controller.send(:current_<%= permission_singular %>).should be_nil
  end

  it "should set <%= session_singular %>[:<%= user_singular %>] if argument to current_<%= user_singular %>= is not a symbol" do
    @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
    @controller.<%= session_singular %>[:<%= user_singular %>].should == @<%= user_singular %>.id
  end

  it "should unset <%= session_singular %>[:<%= user_singular %>] if argument to current_<%= user_singular %>= is a symbol" do
    @controller.send(:current_<%= user_singular %>=, :some_symbol)
    @controller.<%= session_singular %>[:<%= user_singular %>].should be_nil
  end

  it "should unset <%= session_singular %>[:<%= user_singular %>] if argument to current_<%= user_singular %>= is nil" do
    @controller.send(:current_<%= user_singular %>=, nil)
    @controller.<%= session_singular %>[:<%= user_singular %>].should be_nil
  end

  it "should render errors/denied if logged in and unauthorized" do
    @controller.stub!(:logged_in?).and_return(true)
    @controller.stub!(:authorized?).and_return(false)
    get :foo
    response.should render_template('errors/denied')
  end

  it "should redirect to /<%= session_plural %>/new if not logged in" do
    @controller.stub!(:logged_in?).and_return(false)
    get :foo
    response.should redirect_to('/<%= session_plural %>/new')
  end

  it "should render text if not logged in and requesting XML" do
    @controller.stub!(:logged_in?).and_return(false)
    get :foo, :format => "xml"
    response.should have_text("Couldn't authenticate you")
  end

  it "should render text if not authorized and requesting XML" do
    @controller.stub!(:logged_in?).and_return(true)
    @controller.stub!(:authorized?).and_return(false)
    get :foo, :format => "xml"
    response.should have_text("Couldn't authenticate you")
  end

  describe "#current_<%= permission_singular %>" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      @pocky = Pocky.new
      <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
      @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
      @controller.stub!(:action_name).and_return("show")
    end

    it "should always return a resource <%= permission_singular %> if it exists" do
      @controller.stub!(:current_resource).and_return(@pocky)
      <%= permission_singular %> = mock_model(<%= permission_class %>, :resource => @pocky, :parent => nil)
      @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([<%= permission_singular %>])

      @controller.send(:current_<%= permission_singular %>).should == <%= permission_singular %>
    end

    it "should return a controller <%= permission_singular %> if a resource <%= permission_singular %> doesn't exist" do
      @controller.stub!(:current_resource).and_return(nil)
      <%= permission_singular %> = mock_model(<%= permission_class %>, :controller => "pocky_test", :resource => nil, :parent => nil)
      @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([<%= permission_singular %>])

      @controller.send(:current_<%= permission_singular %>).should == <%= permission_singular %>
    end

    it "should not even look for a resource <%= permission_singular %> if the action is not included in resource_actions" do
      @controller.stub!(:action_name).and_return("index")   # index is not in resource_actions
      @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([])

      @controller.should_not_receive(:current_resource)
      @controller.send(:current_<%= permission_singular %>)
    end

    it "should return nil if the current <%= user_singular %> has no related <%= permission_plural %>" do
      @controller.stub!(:current_resource).and_return(@pocky)
      @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([])

      @controller.send(:current_<%= permission_singular %>).should be_nil
    end
  end

  describe "#<%= user_singular %>_can_read?" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      @pocky = Pocky.new
      <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
    end

    it "should call <%= permission_class %>#can_read when current_<%= permission_singular %> is not nil" do
      <%= permission_singular %> = mock_model(<%= permission_class %>)
      <%= permission_singular %>.should_receive(:can_read).and_return(true)
      @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

      @controller.send(:<%= user_singular %>_can_read?).should be_true
    end

    it "should be false if current_<%= permission_singular %> is nil" do
      @controller.stub!(:current_<%= permission_singular %>).and_return(nil)
      @controller.send(:<%= user_singular %>_can_read?).should be_false
    end
  end

  describe "#<%= user_singular %>_can_write?" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      @pocky = Pocky.new
      <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
    end

    it "should call <%= permission_class %>#can_write when current_<%= permission_singular %> is not nil" do
      <%= permission_singular %> = mock_model(<%= permission_class %>)
      <%= permission_singular %>.should_receive(:can_write).and_return(true)
      @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

      @controller.send(:<%= user_singular %>_can_write?).should be_true
    end

    it "should be false if current_<%= permission_singular %> is nil" do
      @controller.stub!(:current_<%= permission_singular %>).and_return(nil)
      @controller.send(:<%= user_singular %>_can_write?).should be_false
    end
  end

  describe "#<%= user_singular %>_can_read_and_write?" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      @pocky = Pocky.new
      <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
    end

    it "should call <%= permission_class %>#can_read and can_write when current_<%= permission_singular %> is not nil" do
      <%= permission_singular %> = mock_model(<%= permission_class %>)
      <%= permission_singular %>.should_receive(:can_read).and_return(true)
      <%= permission_singular %>.should_receive(:can_write).and_return(false)
      @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

      @controller.send(:<%= user_singular %>_can_read_and_write?).should be_false
    end

    it "should be false if current_<%= permission_singular %> is nil" do
      @controller.stub!(:current_<%= permission_singular %>).and_return(nil)
      @controller.send(:<%= user_singular %>_can_read_and_write?).should be_false
    end
  end

  describe "#logged_in?" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      @pocky = Pocky.new
      <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
    end

    it "should be true if current_<%= user_singular %> is not :false" do
      @controller.stub!(:current_<%= user_singular %>).and_return("blah")
      @controller.send(:logged_in?).should be_true
    end

    it "should be false if current_<%= user_singular %> is :false" do
      @controller.stub!(:current_<%= user_singular %>).and_return(:false)
      @controller.send(:logged_in?).should be_false
    end
  end

  describe "#authorized?" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      @<%= permission_singular %> = mock_model(<%= permission_class %>)
      @controller.stub!(:action_name).and_return('foo')
      @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
      @controller.stub!(:current_<%= permission_singular %>).and_return(@<%= permission_singular %>)
    end

    it "should return true if controller_name is '<%= session_plural %>'" do
      @controller.stub!(:controller_name).and_return('<%= session_plural %>')
      @controller.send(:authorized?).should be_true
    end

    it "should return true if current <%= user_singular %> is an admin" do
      @<%= user_singular %>.stub!(:admin?).and_return(true)

      @controller.send(:authorized?).should be_true
    end

    it "should return true if flash[:allow] is true" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:flash).and_return({:allow => true})

      @controller.send(:authorized?).should be_true
    end

    it "should return false if current_<%= permission_singular %> is nil" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:current_<%= permission_singular %>).and_return(nil)

      @controller.send(:authorized?).should be_false
    end

    it "should call action_<%= permission_plural %>" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)

      @controller.should_receive(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => [], 'b' => []})
      @controller.send(:authorized?)
    end

    it "should return false if action_<%= permission_plural %> doesn't know about the action" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => [], 'b' => []})

      @controller.send(:authorized?).should be_false
    end

    it "should call <%= user_singular %>_can_read? if the action requires read <%= permission_plural %>" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})

      @controller.should_receive(:<%= user_singular %>_can_read?).and_return(false)
      @controller.send(:authorized?)
    end

    it "should call <%= user_singular %>_can_write? if the action requires write <%= permission_plural %>" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => ['foo'], 'b' => []})

      @controller.should_receive(:<%= user_singular %>_can_write?).and_return(false)
      @controller.send(:authorized?)
    end

    it "should call <%= user_singular %>_can_read_and_write? if the action requires read and write <%= permission_plural %>" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => [], 'b' => ['foo']})

      @controller.should_receive(:<%= user_singular %>_can_read_and_write?).and_return(false)
      @controller.send(:authorized?)
    end

    it "should call sticky_actions if preliminary access is granted" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)

      @controller.should_receive(:sticky_actions).and_return([])
      @controller.send(:authorized?)
    end

    it "should call <%= permission_singular %>_is_sticky? if preliminary access is granted and sticky_actions includes the requested action" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
      @controller.stub!(:sticky_actions).and_return(['foo'])

      @controller.should_receive(:<%= permission_singular %>_is_sticky?).and_return(false)
      @controller.send(:authorized?)
    end

    it "should return true if preliminary access is granted and the action is not sticky" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
      @controller.stub!(:sticky_actions).and_return([])

      @controller.send(:authorized?).should be_true
    end

    it "should call current_resource if preliminary access is granted and the action is sticky" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
      @controller.stub!(:sticky_actions).and_return(['foo'])
      @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)

      @controller.should_receive(:current_resource).and_return(nil)
      @controller.send(:authorized?)
    end

    it "should be false if current_resource is nil" do
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
      @controller.stub!(:sticky_actions).and_return(['foo'])
      @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)
      @controller.stub!(:current_resource).and_return(nil)

      @controller.send(:authorized?).should be_false
    end

    it "should be true if the current resource's creator is the current <%= user_singular %>" do
      pocky = Pocky.new
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
      @controller.stub!(:sticky_actions).and_return(['foo'])
      @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)
      @controller.stub!(:current_resource).and_return(pocky)
      pocky.stub!(:created_by).and_return(@<%= user_singular %>.id)

      @controller.send(:authorized?).should be_true
    end

    it "should be false if the current resource's creator is not the current <%= user_singular %>" do
      pocky = Pocky.new
      @<%= user_singular %>.stub!(:admin?).and_return(false)
      @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
      @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
      @controller.stub!(:sticky_actions).and_return(['foo'])
      @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)
      @controller.stub!(:current_resource).and_return(pocky)
      pocky.stub!(:created_by).and_return(@<%= user_singular %>.id + 1)

      @controller.send(:authorized?).should be_false
    end
  end

  describe "#login_required" do
    before(:each) do
      @<%= user_singular %> = mock_model(<%= user_class %>)
      <%= user_class %>.stub!(:find_by_id).and_return(@<%= user_singular %>)
    end

    it "should call get_auth_data" do
      @controller.should_receive(:get_auth_data).and_return([nil, nil])
      @controller.stub!(:access_denied)
      @controller.send(:login_required)
    end

    it "should set current_<%= user_singular %> if get_auth_data returns a valid <%= user_singular %>name and password" do
      @controller.stub!(:get_auth_data).and_return(['foo', 'bar'])
      @controller.stub!(:authorized?).and_return(true)
      <%= user_class %>.stub!(:authenticate).and_return(@<%= user_singular %>)
      @controller.send(:login_required)

      @controller.current_<%= user_singular %>.should == @<%= user_singular %>
    end

    it "should set current_<%= user_singular %> to :false if get_auth_data returns an invalid <%= user_singular %>name and password" do
      @controller.stub!(:get_auth_data).and_return(['foo', 'bar'])
      @controller.stub!(:access_denied)
      <%= user_class %>.stub!(:authenticate).and_return(false)
      @controller.send(:login_required)

      @controller.current_<%= user_singular %>.should == :false
    end

    it "should not set current_<%= user_singular %> get_auth_data returns no <%= user_singular %>name or password" do
      @controller.stub!(:get_auth_data).and_return([nil, nil])
      @controller.stub!(:access_denied)
      @controller.should_not_receive(:current_<%= user_singular %>=)
      @controller.send(:login_required)
    end

    it "should not call get_auth_data if current_<%= user_singular %> is set" do
      @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
      @controller.stub!(:authorized?).and_return(true)
      @controller.should_not_receive(:get_auth_data)
      @controller.send(:login_required)
    end

    it "should not call authorized? if logged_in? is false" do
      @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
      @controller.stub!(:logged_in?).and_return(false)
      @controller.stub!(:access_denied)

      @controller.should_not_receive(:authorized?)
      @controller.send(:login_required)
    end

    it "should call access_denied if <%= user_singular %> is unauthorized" do
      @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
      @controller.stub!(:authorized?).and_return(false)

      @controller.should_receive(:access_denied)
      @controller.send(:login_required)
    end

    it "should return true if <%= user_singular %> is authorized" do
      @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
      @controller.stub!(:authorized?).and_return(true)
      @controller.send(:login_required).should be_true
    end
  end

  describe "#store_location" do

    it "should set <%= session_singular %>[:return_to] to request_uri" do
      get :bar
      @controller.send(:store_location)
      @controller.<%= session_singular %>[:return_to].should == request.request_uri
    end
  end

  describe "#redirect_back_or_default" do

    it "should redirect to the url in <%= session_singular %>[:return_to] if it exists" do
      @controller.<%= session_singular %>[:return_to] = '/pocky_test/foo'
      get :redirect_back
      response.should redirect_to('/pocky_test/foo')
    end

    it "should redirect to a default if <%= session_singular %>[:return_to] doesn't exist" do
      get :redirect_back
      response.should redirect_to('/pocky_test/bar')
    end

    it "should unset <%= session_singular %>[:return_to]" do
      @controller.<%= session_singular %>[:return_to] = '/pocky_test/foo'
      get :redirect_back
      @controller.<%= session_singular %>[:return_to].should be_nil
    end
  end

  describe "#get_auth_data" do

    it "should decode auth string in X-HTTP_AUTHORIZATION" do
      get :bar
      request.env['X-HTTP_AUTHORIZATION'] = "Basic YWRtaW46dGVzdA=="  # admin:test
      @controller.send(:get_auth_data).should == %w{admin test}
    end

    it "should decode auth string in HTTP_AUTHORIZATION" do
      get :bar
      request.env['HTTP_AUTHORIZATION'] = "Basic YWRtaW46dGVzdA=="  # admin:test
      @controller.send(:get_auth_data).should == %w{admin test}
    end

    it "should decode auth string in Authorization" do
      get :bar
      request.env['Authorization'] = "Basic YWRtaW46dGVzdA=="  # admin:test
      @controller.send(:get_auth_data).should == %w{admin test}
    end
  end
end

class ModelOne < FakeModel; end
class ModelTwo < FakeModel; end
class ModelThree < FakeModel; end

class OneTestController < ActionController::Base
  include AuthenticatedSystem
  resource_model_name :model_one
end

class TwoTestController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required
  resource_model_name :model_two
  access_hierarchies [:one_test]

  def index; end
  def new; end
  def create; end
  def show; end
  def edit; end
  def update; end
  def destroy; end
end

class ThreeTestController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required
  resource_model_name :model_three
  access_hierarchies [:one_test, :two_test], [:one_test]

  def index; end
  def new; end
  def create; end
  def show; end
  def edit; end
  def update; end
  def destroy; end
end

describe "controller structure with an access hierarchy", :type => :controller do
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>
  include AuthenticatedTestHelper

  before(:each) do
    Posy.stub!(:controllers).and_return(%w{one_test two_test three_test})
    @<%= user_singular %> = <%= user_class %>.create({
      :login => "test_<%= user_singular %>", :email => "test_<%= user_singular %>@example.com",
      :password => "test", :password_confirmation => "test"
    })
    @<%= group_singular %> = <%= group_class %>.create(:name => "test_<%= group_singular %>")
    @<%= user_singular %>.<%= membership_plural %>.create(:<%= group_singular %> => @<%= group_singular %>)
  end

  describe TwoTestController do
    before(:each) do
      @one   = ModelOne.new(1)
      @two   = ModelTwo.new(1)
      @three = ModelThree.new(1)
      @parent = @<%= group_singular %>.<%= permission_plural %>.create(:resource => @one, :can_read => true)
      @child  = @<%= group_singular %>.<%= permission_plural %>.create({
        :controller => "two_test", :parent => @parent,
        :can_read => true, :can_write => true
      })
      login_as(@<%= user_singular %>)
    end

    describe "when params[:one_test_id] = 1" do
      before(:each) do
        @params = { :one_test_id => "1" }
      end

      describe "GET /two_test" do
        def do_get
          get :index, @params
        end

        it "should find the correct <%= permission_singular %>" do
          do_get
          @controller.send(:current_<%= permission_singular %>).should == @child
        end

        it "should be successful" do
          do_get
          response.should be_success
        end
      end

      describe "GET /two_test/1" do
        def do_get
          get :show, @params
        end

        before(:each) do
          @params[:id] = "1"
        end

        it "should be successful" do
          do_get
          response.should be_success
        end

        describe "#current_<%= permission_singular %>" do
          it "should be the child controller <%= permission_singular %>" do
            do_get
            @controller.send(:current_<%= permission_singular %>).should == @child
          end

          it "should be the child controller <%= permission_singular %> even if the <%= user_singular %> has 'direct' access to the resource" do
            @<%= group_singular %>.<%= permission_plural %>.create(:resource => @two, :can_read => true)
            do_get
            @controller.send(:current_<%= permission_singular %>).should == @child
          end

          it "should be the child resource <%= permission_singular %>" do
            perm = @<%= group_singular %>.<%= permission_plural %>.create(:resource => @two, :can_read => true, :parent => @parent)
            do_get
            @controller.send(:current_<%= permission_singular %>).should == perm
          end
        end
      end
    end

    describe "when params[:one_test_id] != 1" do
      it "should fail to GET index" do
        get :index, :one_test_id => "2"
        response.response_code.should == 401
      end

      it "should fail to GET show" do
        get :show, :one_test_id => "2", :id => "1"
        response.response_code.should == 401
      end
    end
  end

  describe ThreeTestController do
    before(:each) do
      @one   = ModelOne.new(1)
      @two   = ModelTwo.new(1)
      @three = ModelThree.new(1)
      @one_perm = @<%= group_singular %>.<%= permission_plural %>.create(:resource => @one, :can_read => true)
      login_as(@<%= user_singular %>)
    end

    describe do
      before(:each) do
        @params = { :one_test_id => "1" }
        @parent = @one_perm
        @child  = @<%= group_singular %>.<%= permission_plural %>.create({
          :controller => "three_test", :parent => @parent,
          :can_read => true, :can_write => true
        })
      end

      describe "GET /one_test/1/three_test" do
        def do_get
          get :index, @params
        end

        it "should find the correct <%= permission_singular %>" do
          do_get
          @controller.send(:current_<%= permission_singular %>).should == @child
        end

        it "should be successful" do
          do_get
          response.should be_success
        end
      end
    end

    describe do
      before(:each) do
        @params = { :one_test_id => "1", :two_test_id => "1" }
        @grandparent = @one_perm
        @parent = @<%= group_singular %>.<%= permission_plural %>.create({
          :resource => @two, :can_read => true,
          :parent => @grandparent
        })
        @child = @<%= group_singular %>.<%= permission_plural %>.create({
          :controller => "three_test", :parent => @parent,
          :can_read => true, :can_write => true
        })
      end

      describe "GET /one_test/1/two_test/2/three_test" do
        def do_get
          get :index, @params
        end

        it "should find the correct <%= permission_singular %>" do
          do_get
          @controller.send(:current_<%= permission_singular %>).should == @child
        end

        it "should be successful" do
          do_get
          response.should be_success
        end

        describe "when parent <%= permission_singular %> is a controller <%= permission_singular %>" do
          before(:each) do
            @parent.update_attributes(:resource => nil, :controller => "two_test")
          end

          it "should find the correct <%= permission_singular %>" do
            do_get
            @controller.send(:current_<%= permission_singular %>).should == @child
          end

          it "should be successful" do
            do_get
            response.should be_success
          end
        end
      end
    end
  end
end
