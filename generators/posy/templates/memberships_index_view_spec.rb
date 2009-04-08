require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= membership_plural %>/index" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => "dude")
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= membership_singular %> = mock_model(<%= membership_class %>, :<%= user_singular %> => @<%= user_singular %>, :<%= group_singular %> => @<%= group_singular %>)
    @<%= membership_plural %> = Array.new(3, @<%= membership_singular %>)
    assigns[:<%= membership_plural %>] = @<%= membership_plural %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/index' }.should_not raise_error
  end
end

describe "rendering /<%= membership_plural %>/index when @<%= user_singular %> is set" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => "dude")
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= membership_singular %> = mock_model(<%= membership_class %>, :<%= user_singular %> => @<%= user_singular %>, :<%= group_singular %> => @<%= group_singular %>)
    @<%= membership_plural %> = Array.new(3, @<%= membership_singular %>)
    assigns[:<%= membership_plural %>] = @<%= membership_plural %>
    assigns[:<%= user_singular %>] = @<%= user_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/index' }.should_not raise_error
  end

  it "should have a back link to <%= user_singular %>_url(@<%= user_singular %>)" do
    render '<%= membership_plural %>/index'
    url = "/<%= user_plural %>/#{@<%= user_singular %>.id}"
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

describe "rendering /<%= membership_plural %>/index when @<%= group_singular %> is set" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => "dude")
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= membership_singular %> = mock_model(<%= membership_class %>, :<%= user_singular %> => @<%= user_singular %>, :<%= group_singular %> => @<%= group_singular %>)
    @<%= membership_plural %> = Array.new(3, @<%= membership_singular %>)
    assigns[:<%= membership_plural %>] = @<%= membership_plural %>
    assigns[:<%= group_singular %>] = @<%= group_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/index' }.should_not raise_error
  end

  it "should have a back link to <%= group_singular %>_url(@<%= group_singular %>)" do
    render '<%= membership_plural %>/index'
    url = "/<%= group_plural %>/#{@<%= group_singular %>.id}"
    response.should have_tag("a[href=#{url}]", "Back")
  end
end
