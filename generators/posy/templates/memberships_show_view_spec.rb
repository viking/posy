require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= membership_plural %>/show" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => 'dude')
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => 'dudes')
    @<%= membership_singular %> = mock_model(<%= membership_class %>, {
      :<%= user_singular %> => @<%= user_singular %>, :<%= group_singular %> => @<%= group_singular %>, :created_at => Time.now, :updated_at => Time.now,
      :creator => @<%= user_singular %>, :updater => @<%= user_singular %>
    })
    assigns[:<%= membership_singular %>] = @<%= membership_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/show' }.should_not raise_error
  end

  it "should have a link to <%= group_singular %>_url(@<%= membership_singular %>.<%= group_singular %>)" do
    render '<%= membership_plural %>/show'
    url = <%= group_singular %>_url(@<%= membership_singular %>.<%= group_singular %>)
    response.should have_tag("a[href=#{url}]", @<%= group_singular %>.name)
  end

  it "should have a link to <%= user_singular %>_url(@<%= membership_singular %>.<%= user_singular %>)" do
    render '<%= membership_plural %>/show'
    url = <%= user_singular %>_url(@<%= membership_singular %>.<%= user_singular %>)
    response.should have_tag("a[href=#{url}]", @<%= user_singular %>.login)
  end

  it "should have a back link to <%= membership_plural %>_path" do
    render '<%= membership_plural %>/show'
    url = "/<%= membership_plural %>"
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

describe "rendering /<%= membership_plural %>/show when @<%= user_singular %> is set" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => 'dude')
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => 'dudes')
    @<%= membership_singular %> = mock_model(<%= membership_class %>, {
      :<%= user_singular %> => @<%= user_singular %>, :<%= group_singular %> => @<%= group_singular %>, :created_at => Time.now, :updated_at => Time.now,
      :creator => @<%= user_singular %>, :updater => @<%= user_singular %>
    })
    assigns[:<%= membership_singular %>] = @<%= membership_singular %>
    assigns[:<%= user_singular %>] = @<%= user_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/show' }.should_not raise_error
  end

  it "should have a back link to <%= user_singular %>_<%= membership_plural %>_path(@<%= user_singular %>)" do
    render '<%= membership_plural %>/show'
    url = "/<%= user_plural %>/#{@<%= user_singular %>.id}/<%= membership_plural %>"
    response.should have_tag("a[href=#{url}]", "Back")
  end
end

describe "rendering /<%= membership_plural %>/show when @<%= group_singular %> is set" do
  before do
    @<%= user_singular %>  = mock_model(<%= user_class %>, :login => 'dude')
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => 'dudes')
    @<%= membership_singular %> = mock_model(<%= membership_class %>, {
      :<%= user_singular %> => @<%= user_singular %>, :<%= group_singular %> => @<%= group_singular %>, :created_at => Time.now, :updated_at => Time.now,
      :creator => @<%= user_singular %>, :updater => @<%= user_singular %>
    })
    assigns[:<%= membership_singular %>] = @<%= membership_singular %>
    assigns[:<%= group_singular %>] = @<%= group_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= membership_plural %>/show' }.should_not raise_error
  end

  it "should have a back link to <%= group_singular %>_<%= membership_plural %>_path(@<%= group_singular %>)" do
    render '<%= membership_plural %>/show'
    url = "/<%= group_plural %>/#{@<%= group_singular %>.id}/<%= membership_plural %>"
    response.should have_tag("a[href=#{url}]", "Back")
  end
end
