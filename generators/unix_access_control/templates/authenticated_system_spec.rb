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
end

describe "a subclass of a controller that uses AuthenticatedSystem" do
  before(:all) do
    class BarTestController < ActionController::Base
      include AuthenticatedSystem
    end

    BarTestController.action_<%= permission_plural %>('r' => %w{index})
    BarTestController.resource_actions(:foo, :bar)
    BarTestController.sticky_actions(:tro<%= user_plural %>, :pants)
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

describe PockyTestController, :behaviour_type => :controller do
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

  # this is named funnily, but I don't care
  it "current_<%= permission_singular %> should always return a resource <%= permission_singular %> if it exists" do
    @controller.stub!(:action_name).and_return("show")
    @controller.stub!(:current_resource).and_return(@pocky)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    <%= permission_singular %> = mock_model(<%= permission_class %>, :resource => @pocky)
    @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([<%= permission_singular %>])

    @controller.send(:current_<%= permission_singular %>).should == <%= permission_singular %>
  end

  it "current_<%= permission_singular %> should return a controller <%= permission_singular %> if a resource <%= permission_singular %> doesn't exist" do
    @controller.stub!(:action_name).and_return("show")
    @controller.stub!(:current_resource).and_return(nil)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    <%= permission_singular %> = mock_model(<%= permission_class %>, :controller => "pocky_test", :resource => nil)
    @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([<%= permission_singular %>])

    @controller.send(:current_<%= permission_singular %>).should == <%= permission_singular %>
  end

  it "current_<%= permission_singular %> should not even look for a resource <%= permission_singular %> if the action is not included in resource_actions" do
    @controller.stub!(:action_name).and_return("index")   # index is not in resource_actions
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([])

    @controller.should_not_receive(:current_resource)
    @controller.send(:current_<%= permission_singular %>)
  end

  it "current_<%= permission_singular %> should return nil if the current <%= user_singular %> has no related <%= permission_plural %>" do
    @controller.stub!(:action_name).and_return("show")
    @controller.stub!(:current_resource).and_return(@pocky)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @<%= user_singular %>.stub!(:<%= permission_plural %>).and_return([])

    @controller.send(:current_<%= permission_singular %>).should be_nil
  end

  it "<%= user_singular %>_can_read? should call <%= permission_class %>#can_read when current_<%= permission_singular %> is not nil" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    <%= permission_singular %>.should_receive(:can_read).and_return(true)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

    @controller.send(:<%= user_singular %>_can_read?).should be_true
  end

  it "<%= user_singular %>_can_read? should be false if current_<%= permission_singular %> is nil" do
    @controller.stub!(:current_<%= permission_singular %>).and_return(nil)
    @controller.send(:<%= user_singular %>_can_read?).should be_false
  end

  it "<%= user_singular %>_can_write? should call <%= permission_class %>#can_write when current_<%= permission_singular %> is not nil" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    <%= permission_singular %>.should_receive(:can_write).and_return(true)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

    @controller.send(:<%= user_singular %>_can_write?).should be_true
  end

  it "<%= user_singular %>_can_write? should be false if current_<%= permission_singular %> is nil" do
    @controller.stub!(:current_<%= permission_singular %>).and_return(nil)
    @controller.send(:<%= user_singular %>_can_write?).should be_false
  end

  it "<%= user_singular %>_can_read_and_write? should call <%= permission_class %>#can_read and can_write when current_<%= permission_singular %> is not nil" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    <%= permission_singular %>.should_receive(:can_read).and_return(true)
    <%= permission_singular %>.should_receive(:can_write).and_return(false)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

    @controller.send(:<%= user_singular %>_can_read_and_write?).should be_false
  end

  it "<%= user_singular %>_can_read_and_write? should be false if current_<%= permission_singular %> is nil" do
    @controller.stub!(:current_<%= permission_singular %>).and_return(nil)
    @controller.send(:<%= user_singular %>_can_read_and_write?).should be_false
  end

  it "logged_in? should be true if current_<%= user_singular %> is not :false" do
    @controller.stub!(:current_<%= user_singular %>).and_return("blah")
    @controller.send(:logged_in?).should be_true
  end

  it "logged_in? should be false if current_<%= user_singular %> is :false" do
    @controller.stub!(:current_<%= user_singular %>).and_return(:false)
    @controller.send(:logged_in?).should be_false
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

  it "authorized? should return true if controller_name is '<%= session_plural %>'" do
    @controller.stub!(:controller_name).and_return('<%= session_plural %>')
    @controller.send(:authorized?).should be_true
  end

  it "authorized? should return true if current <%= user_singular %> is an admin" do
    @<%= user_singular %>.stub!(:admin?).and_return(true)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)

    @controller.send(:authorized?).should be_true
  end

  it "authorized? should return true if flash[:allow] is true" do
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:flash).and_return({:allow => true})

    @controller.send(:authorized?).should be_true
  end

  it "authorized? should return false if current_<%= permission_singular %> is nil" do
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(nil)

    @controller.send(:authorized?).should be_false
  end

  it "authorized? should call action_<%= permission_plural %>" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)

    @controller.should_receive(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => [], 'b' => []})
    @controller.send(:authorized?)
  end

  it "authorized? should return false if action_<%= permission_plural %> doesn't know about the action" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')

    @controller.send(:authorized?).should be_false
  end

  it "authorized? should call <%= user_singular %>_can_read? if the action requires read <%= permission_plural %>" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    
    @controller.should_receive(:<%= user_singular %>_can_read?).and_return(false)
    @controller.send(:authorized?)
  end

  it "authorized? should call <%= user_singular %>_can_write? if the action requires write <%= permission_plural %>" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => ['foo'], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    
    @controller.should_receive(:<%= user_singular %>_can_write?).and_return(false)
    @controller.send(:authorized?)
  end

  it "authorized? should call <%= user_singular %>_can_read_and_write? if the action requires read and write <%= permission_plural %>" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => [], 'w' => [], 'b' => ['foo']})
    @controller.stub!(:action_name).and_return('foo')
    
    @controller.should_receive(:<%= user_singular %>_can_read_and_write?).and_return(false)
    @controller.send(:authorized?)
  end

  it "authorized? should call sticky_actions if preliminary access is granted" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)

    @controller.should_receive(:sticky_actions).and_return([])
    @controller.send(:authorized?)
  end

  it "authorized? should call <%= permission_singular %>_is_sticky? if preliminary access is granted and sticky_actions includes the requested action" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
    @controller.stub!(:sticky_actions).and_return(['foo'])

    @controller.should_receive(:<%= permission_singular %>_is_sticky?).and_return(false)
    @controller.send(:authorized?)
  end

  it "authorized? should return true if preliminary access is granted and the action is not sticky" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
    @controller.stub!(:sticky_actions).and_return([])

    @controller.send(:authorized?).should be_true
  end

  it "authorized? should call current_resource if preliminary access is granted and the action is sticky" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
    @controller.stub!(:sticky_actions).and_return(['foo'])
    @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)

    @controller.should_receive(:current_resource).and_return(nil)
    @controller.send(:authorized?)
  end

  it "authorized? should be false if current_resource is nil" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
    @controller.stub!(:sticky_actions).and_return(['foo'])
    @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)
    @controller.stub!(:current_resource).and_return(nil)

    @controller.send(:authorized?).should be_false
  end

  it "authorized? should be true if the current resource's creator is the current <%= user_singular %>" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
    @controller.stub!(:sticky_actions).and_return(['foo'])
    @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)
    @controller.stub!(:current_resource).and_return(@pocky)
    @pocky.stub!(:created_by).and_return(@<%= user_singular %>.id)

    @controller.send(:authorized?).should be_true
  end

  it "authorized? should be false if the current resource's creator is not the current <%= user_singular %>" do
    <%= permission_singular %> = mock_model(<%= permission_class %>)
    @<%= user_singular %>.stub!(:admin?).and_return(false)
    @controller.stub!(:current_<%= user_singular %>).and_return(@<%= user_singular %>)
    @controller.stub!(:current_<%= permission_singular %>).and_return(<%= permission_singular %>)
    @controller.stub!(:action_<%= permission_plural %>).and_return({'r' => ['foo'], 'w' => [], 'b' => []})
    @controller.stub!(:action_name).and_return('foo')
    @controller.stub!(:<%= user_singular %>_can_read?).and_return(true)
    @controller.stub!(:sticky_actions).and_return(['foo'])
    @controller.stub!(:<%= permission_singular %>_is_sticky?).and_return(true)
    @controller.stub!(:current_resource).and_return(@pocky)
    @pocky.stub!(:created_by).and_return(@<%= user_singular %>.id + 1)

    @controller.send(:authorized?).should be_false
  end

  it "login_required should call get_auth_data" do
    @controller.should_receive(:get_auth_data).and_return([nil, nil])
    @controller.stub!(:access_denied)
    @controller.send(:login_required)
  end

  it "login_required should set current_<%= user_singular %> if get_auth_data returns a valid <%= user_singular %>name and password" do
    @controller.stub!(:get_auth_data).and_return(['foo', 'bar'])
    @controller.stub!(:authorized?).and_return(true)
    <%= user_class %>.stub!(:authenticate).and_return(@<%= user_singular %>)
    @controller.send(:login_required)

    @controller.current_<%= user_singular %>.should == @<%= user_singular %>
  end

  it "login_required should set current_<%= user_singular %> to :false if get_auth_data returns an invalid <%= user_singular %>name and password" do
    @controller.stub!(:get_auth_data).and_return(['foo', 'bar'])
    @controller.stub!(:access_denied)
    <%= user_class %>.stub!(:authenticate).and_return(false)
    @controller.send(:login_required)

    @controller.current_<%= user_singular %>.should == :false
  end

  it "login_required should not set current_<%= user_singular %> get_auth_data returns no <%= user_singular %>name or password" do
    @controller.stub!(:get_auth_data).and_return([nil, nil])
    @controller.stub!(:access_denied)
    @controller.should_not_receive(:current_<%= user_singular %>=)
    @controller.send(:login_required)
  end

  it "login_required should not call get_auth_data if current_<%= user_singular %> is set" do
    @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
    @controller.stub!(:authorized?).and_return(true)
    @controller.should_not_receive(:get_auth_data)
    @controller.send(:login_required)
  end

  it "login_required should not call authorized? if logged_in? is false" do
    @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
    @controller.stub!(:logged_in?).and_return(false)
    @controller.stub!(:access_denied)

    @controller.should_not_receive(:authorized?)
    @controller.send(:login_required)
  end

  it "login_required should call access_denied if <%= user_singular %> is unauthorized" do
    @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
    @controller.stub!(:authorized?).and_return(false)

    @controller.should_receive(:access_denied)
    @controller.send(:login_required)
  end

  it "login_required should return true if <%= user_singular %> is authorized" do
    @controller.send(:current_<%= user_singular %>=, @<%= user_singular %>)
    @controller.stub!(:authorized?).and_return(true)
    @controller.send(:login_required).should be_true
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

  it "store_location should set <%= session_singular %>[:return_to] to request_uri" do
    get :bar
    @controller.send(:store_location)
    @controller.<%= session_singular %>[:return_to].should == request.request_uri
  end

  it "redirect_back_or_default should redirect to the url in <%= session_singular %>[:return_to] if it exists" do
    @controller.<%= session_singular %>[:return_to] = '/pocky_test/foo'
    get :redirect_back
    response.should redirect_to('/pocky_test/foo')
  end

  it "redirect_back_or_default should redirect to a default if <%= session_singular %>[:return_to] doesn't exist" do
    get :redirect_back
    response.should redirect_to('/pocky_test/bar')
  end

  it "redirect_back_or_default should unset <%= session_singular %>[:return_to]" do
    @controller.<%= session_singular %>[:return_to] = '/pocky_test/foo'
    get :redirect_back
    @controller.<%= session_singular %>[:return_to].should be_nil
  end

  it "get_auth_data should decoded auth string in X-HTTP_AUTHORIZATION" do
    get :bar
    request.env['X-HTTP_AUTHORIZATION'] = "Basic YWRtaW46dGVzdA=="  # admin:test
    @controller.send(:get_auth_data).should == %w{admin test}
  end

  it "get_auth_data should decoded auth string in HTTP_AUTHORIZATION" do
    get :bar
    request.env['HTTP_AUTHORIZATION'] = "Basic YWRtaW46dGVzdA=="  # admin:test
    @controller.send(:get_auth_data).should == %w{admin test}
  end

  it "get_auth_data should decoded auth string in Authorization" do
    get :bar
    request.env['Authorization'] = "Basic YWRtaW46dGVzdA=="  # admin:test
    @controller.send(:get_auth_data).should == %w{admin test}
  end
end
