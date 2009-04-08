require File.dirname(__FILE__) + '/../spec_helper'

describe <%= permission_plural_class %>Helper do
  include <%= permission_plural_class %>Helper

  describe "#link_to_index" do

    it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
      @<%= group_singular %> = mock_model(<%= group_class %>)
      link_to_index("foo").should ==
        link_to("foo", :controller => '<%= permission_plural %>', :action => 'index', :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
    end

    it "should return normal link when @<%= group_singular %> doesn't exist" do
      link_to_index("foo").should ==
        link_to("foo", :controller => '<%= permission_plural %>', :action => 'index', :only_path => true)
    end
  end

  describe "#link_to_new" do

    it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
      @<%= group_singular %> = mock_model(<%= group_class %>)
      link_to_new("foo").should ==
        link_to("foo", :controller => '<%= permission_plural %>', :action => 'new', :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
    end

    it "should return normal link when @<%= group_singular %> doesn't exist" do
      link_to_new("foo").should ==
        link_to("foo", :controller => '<%= permission_plural %>', :action => 'new', :only_path => true)
    end
  end

  describe "#link_to_show" do

    before(:each) do
      @<%= permission_singular %> = mock_model(<%= permission_class %>)
    end

    it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
      @<%= group_singular %> = mock_model(<%= group_class %>)
      link_to_show("foo", @<%= permission_singular %>).should ==
        link_to("foo", :controller => '<%= permission_plural %>', :action => 'show', :<%= group_singular %>_id => @<%= group_singular %>.id, :id => @<%= permission_singular %>.id, :only_path => true)
    end

    it "should return normal link when @<%= group_singular %> doesn't exist" do
      link_to_show("foo", @<%= permission_singular %>).should ==
        link_to("foo", :controller => '<%= permission_plural %>', :action => 'show', :id => @<%= permission_singular %>.id, :only_path => true)
    end
  end

  describe "#link_to_destroy" do

    before(:each) do
      @<%= permission_singular %> = mock_model(<%= permission_class %>)
    end

    it "should return <%= group_singular %> link when @<%= group_singular %> exists" do
      @<%= group_singular %> = mock_model(<%= group_class %>)
      link_to_destroy("foo", @<%= permission_singular %>).should ==
        link_to("foo", { :controller => '<%= permission_plural %>', :action => 'destroy', :<%= group_singular %>_id => @<%= group_singular %>.id, :id => @<%= permission_singular %>.id, :only_path => true }, :method => :delete)
    end

    it "should return normal link when @<%= group_singular %> doesn't exist" do
      link_to_destroy("foo", @<%= permission_singular %>).should ==
        link_to("foo", { :controller => '<%= permission_plural %>', :action => 'destroy', :id => @<%= permission_singular %>.id, :only_path => true }, :method => :delete)
    end
  end

  describe "#url_for_create" do

    it "should return <%= group_singular %> url when @<%= group_singular %> exists" do
      @<%= group_singular %> = mock_model(<%= group_class %>)
      url_for_create.should == url_for(:controller => '<%= permission_plural %>', :action => 'create', :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
    end

    it "should return normal url when @<%= group_singular %> doesn't exist" do
      url_for_create.should == url_for(:controller => '<%= permission_plural %>', :action => 'create', :only_path => true)
    end
  end

  describe "#url_for_update" do

    before(:each) do
      @<%= permission_singular %> = mock_model(<%= permission_class %>)
    end

    it "should return <%= group_singular %> url when @<%= group_singular %> exists" do
      @<%= group_singular %> = mock_model(<%= group_class %>)
      url_for_update(@<%= permission_singular %>).should == url_for(:controller => '<%= permission_plural %>', :action => 'update', :id => @<%= permission_singular %>.id, :<%= group_singular %>_id => @<%= group_singular %>.id, :only_path => true)
    end

    it "should return normal url when @<%= group_singular %> doesn't exist" do
      url_for_update(@<%= permission_singular %>).should == url_for(:controller => '<%= permission_plural %>', :action => 'update', :id => @<%= permission_singular %>.id, :only_path => true)
    end
  end
end
