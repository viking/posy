require File.dirname(__FILE__) + '/../spec_helper'

describe <%= membership_class %>sHelper, "#link_to_index" do

  it "should return <%= user_singular %> link when @<%= user_singular %> exists" do
    @<%= user_singular %> = mock_model(<%= user_class %>)
    link_to_index("foo").should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'index', :<%= user_singular %>_id => @<%= user_singular %>.id, :only_path => true)
  end

  it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
    @<%= group_singular %> = mock_model(<%= group_class %>)
    link_to_index("foo").should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'index', :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
  end

  it "should return normal link when neither @<%= user_singular %> or @<%= group_singular %> exists" do
    link_to_index("foo").should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'index', :only_path => true)
  end
end

describe <%= membership_class %>sHelper, "#link_to_new" do

  it "should return <%= user_singular %> link when @<%= user_singular %> exists" do
    @<%= user_singular %> = mock_model(<%= user_class %>)
    link_to_new("foo").should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'new', :<%= user_singular %>_id => @<%= user_singular %>.id, :only_path => true)
  end

  it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
    @<%= group_singular %> = mock_model(<%= group_class %>)
    link_to_new("foo").should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'new', :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
  end

  it "should return normal link when neither @<%= user_singular %> or @<%= group_singular %> exists" do
    link_to_new("foo").should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'new', :only_path => true)
  end
end

describe <%= membership_class %>sHelper, "#link_to_show" do

  before(:each) do
    @<%= membership_singular %> = mock_model(<%= membership_class %>)
  end

  it "should return <%= user_singular %> link when @<%= user_singular %> exists" do
    @<%= user_singular %> = mock_model(<%= user_class %>)
    link_to_show("foo", @<%= membership_singular %>).should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'show', :<%= user_singular %>_id => @<%= user_singular %>.id, :id => @<%= membership_singular %>.id, :only_path => true)
  end

  it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
    @<%= group_singular %> = mock_model(<%= group_class %>)
    link_to_show("foo", @<%= membership_singular %>).should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'show', :<%= group_singular %>_id => @<%= group_singular %>.id, :id => @<%= membership_singular %>.id, :only_path => true)
  end

  it "should return normal link when neither @<%= user_singular %> or @<%= group_singular %> exists" do
    link_to_show("foo", @<%= membership_singular %>).should == 
      link_to("foo", :controller => '<%= membership_plural %>', :action => 'show', :id => @<%= membership_singular %>.id, :only_path => true)
  end
end

describe <%= membership_class %>sHelper, "#link_to_destroy" do

  before(:each) do
    @<%= membership_singular %> = mock_model(<%= membership_class %>)
  end

  it "should return <%= user_singular %> link when @<%= user_singular %> exists" do
    @<%= user_singular %> = mock_model(<%= user_class %>)
    link_to_destroy("foo", @<%= membership_singular %>).should == 
      link_to("foo", { :controller => '<%= membership_plural %>', :action => 'destroy', :<%= user_singular %>_id => @<%= user_singular %>.id, :id => @<%= membership_singular %>.id, :only_path => true }, :method => :delete)
  end

  it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
    @<%= group_singular %> = mock_model(<%= group_class %>)
    link_to_destroy("foo", @<%= membership_singular %>).should == 
      link_to("foo", { :controller => '<%= membership_plural %>', :action => 'destroy', :<%= group_singular %>_id => @<%= group_singular %>.id, :id => @<%= membership_singular %>.id, :only_path => true }, :method => :delete)
  end

  it "should return normal link when neither @<%= user_singular %> or @<%= group_singular %> exists" do
    link_to_destroy("foo", @<%= membership_singular %>).should == 
      link_to("foo", { :controller => '<%= membership_plural %>', :action => 'destroy', :id => @<%= membership_singular %>.id, :only_path => true }, :method => :delete)
  end
end

describe <%= membership_class %>sHelper, "#url_for_create" do

  it "should return <%= user_singular %> url when @<%= user_singular %> exists" do
    @<%= user_singular %> = mock_model(<%= user_class %>)
    url_for_create.should == url_for(:controller => '<%= membership_plural %>', :action => 'create', :<%= user_singular %>_id => @<%= user_singular %>.id, :only_path => true)
  end

  it "should return <%= group_singular %> url when @<%= group_singular %> exists" do
    @<%= group_singular %> = mock_model(<%= group_class %>)
    url_for_create.should == url_for(:controller => '<%= membership_plural %>', :action => 'create', :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
  end

  it "should return normal url when neither @<%= user_singular %> or @<%= group_singular %> exists" do
    url_for_create.should == url_for(:controller => '<%= membership_plural %>', :action => 'create', :only_path => true)
  end
end
