require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= permission_plural %>/new" do
  before do
    @<%= group_plural %> = Array.new(3) { |i| mock_model(<%= group_class %>, :name => "<%= group_singular %>-#{i}") }
    @resource_types = %w{Controller Pocky}
    @<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %>_id => nil, :resource_type => nil, :can_read => nil,
      :can_write => nil, :is_sticky => nil
    })
    assigns[:<%= group_plural %>] = @<%= group_plural %>
    assigns[:resource_types] = @resource_types
    assigns[:<%= permission_singular %>] = @<%= permission_singular %>
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/new' }.should_not raise_error
  end

  it "should have a <%= group_plural %> select box with 3 options" do
    render '/<%= permission_plural %>/new'
    response.should have_tag("select#<%= permission_singular %>_<%= group_singular %>_id option", :count => 3)
  end

  it "should have a resource type select box with 3 options (including one blank)" do
    render '/<%= permission_plural %>/new'
    response.should have_tag("select#<%= permission_singular %>_resource_type option", :count => 3)
  end
end

describe "rendering /<%= permission_plural %>/new when @<%= group_singular %> is set" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @resource_types = %w{Controller Pocky}
    @<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %>_id => nil, :resource_type => nil, :can_read => nil,
      :can_write => nil, :is_sticky => nil
    })
    assigns[:<%= group_singular %>] = @<%= group_singular %>
    assigns[:resource_types] = @resource_types
    assigns[:<%= permission_singular %>] = @<%= permission_singular %>
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/new' }.should_not raise_error
  end

  it "should not have a <%= group_plural %> select box" do
    render '/<%= permission_plural %>/new'
    response.should_not have_tag("select#<%= permission_singular %>_<%= group_singular %>_id")
  end
end

describe "rendering /<%= permission_plural %>/new.rjs" do
  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/new.rjs' }.should_not raise_error
  end

  it "should clear resource_select" do
    render '/<%= permission_plural %>/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do |elements|
      elements.should be_empty
    end
  end
end

describe "rendering /<%= permission_plural %>/new.rjs when @resources is set" do
  before(:each) do
    @resources = [["pocky-1", 1], ["pocky-2", 2], ["pocky-3", 3]]
    assigns[:resources] = @resources
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/new.rjs' }.should_not raise_error
  end

  it "should replace resource_select with a resource_id select box that has 4 options (including a blank)" do
    render '/<%= permission_plural %>/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do
      with_tag("b", "Resource")
      with_tag("select#<%= permission_singular %>_resource_id option", :count => 4)
    end
  end
end

describe "rendering /<%= permission_plural %>/new.rjs when @controllers is set" do
  before(:each) do
    @controllers = %w{lions tigers bears}   # oh my!
    assigns[:controllers] = @controllers
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/new.rjs' }.should_not raise_error
  end

  it "should replace resource_select with a controller select box that has 4 options (including a blank)" do
    render '/<%= permission_plural %>/new.rjs'
    response.should have_rjs(:replace_html, :resource_select) do
      with_tag("b", "Controller")
      with_tag("select#<%= permission_singular %>_controller option", :count => 4)
    end
  end
end
