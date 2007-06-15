require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= membership_plural %>/new" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => "dude")
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= membership_singular %> = mock_model(<%= membership_class %>, :<%= user_singular %> => nil, :<%= group_singular %> => nil)
    @<%= user_plural %>  = Array.new(3, @<%= user_singular %>)
    @<%= group_plural %> = Array.new(3, @<%= group_singular %>)
    assigns[:<%= user_plural %>]  = @<%= user_plural %>
    assigns[:<%= group_plural %>] = @<%= group_plural %>
  end
  
  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/new' }.should_not raise_error
  end

  it "should have a <%= group_plural %> select box" do
    render '<%= membership_plural %>/new'
    response.should have_tag("select#<%= membership_singular %>_<%= group_singular %>_id")
  end

  it "should have a <%= user_plural %> select box" do
    render '<%= membership_plural %>/new'
    response.should have_tag("select#<%= membership_singular %>_<%= user_singular %>_id")
  end
end

describe "rendering /<%= membership_plural %>/new when @<%= user_singular %> is set" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => "dude")
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= membership_singular %> = mock_model(<%= membership_class %>, :<%= user_singular %> => nil, :<%= group_singular %> => nil)
    @<%= group_plural %> = Array.new(3, @<%= group_singular %>)
    assigns[:<%= user_singular %>]   = @<%= user_singular %>
    assigns[:<%= group_plural %>] = @<%= group_plural %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/new' }.should_not raise_error
  end

  it "should not have a <%= user_plural %> select box" do
    render '<%= membership_plural %>/new'
    response.should_not have_tag("select#<%= membership_singular %>_<%= user_singular %>_id")
  end
end

describe "rendering /<%= membership_plural %>/new when @<%= group_singular %> is set" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => "dude")
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= membership_singular %> = mock_model(<%= membership_class %>, :<%= user_singular %> => nil, :<%= group_singular %> => nil)
    @<%= user_plural %> = Array.new(3, @<%= user_singular %>)
    assigns[:<%= user_plural %>] = @<%= user_plural %>
    assigns[:<%= group_singular %>] = @<%= group_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/new' }.should_not raise_error
  end

  it "should not have a <%= group_plural %> select box" do
    render '<%= membership_plural %>/new'
    response.should_not have_tag("select#<%= membership_singular %>_<%= group_singular %>_id")
  end
end
