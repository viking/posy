require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= permission_plural %>/edit for a controller <%= permission_singular %>" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => "vampires", :can_read => true,
      :can_write => true, :is_sticky => false
    })
    assigns[:<%= permission_singular %>] = @<%= permission_singular %>
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/edit' }.should_not raise_error
  end

  it "should show a resource type of 'Controller'" do
    render '/<%= permission_plural %>/edit'
    response.should have_tag("p", /Controller/) do
      with_tag("b", "Resource Type")
    end
  end

  it "should show the controller name" do
    render '/<%= permission_plural %>/edit'
    response.should have_tag("p", /vampires/) do
      with_tag("b", "Controller")
    end
  end
end

describe "rendering /<%= permission_plural %>/edit for a resource <%= permission_singular %>" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @pocky = Pocky.new
    @pocky.stub!(:name).and_return("teh p0cky")
    @<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :resource => @pocky, :resource_type => 'Pocky', :can_read => true,
      :can_write => true, :is_sticky => false, :controller => nil
    })
    assigns[:<%= permission_singular %>] = @<%= permission_singular %>
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/edit' }.should_not raise_error
  end

  it "should show a resource type of 'Pocky'" do
    render '/<%= permission_plural %>/edit'
    response.should have_tag("p", /Pocky/) do
      with_tag("b", "Resource Type")
    end
  end

  it "should show the resource name" do
    render '/<%= permission_plural %>/edit'
    response.should have_tag("p", /teh p0cky/) do
      with_tag("b", "Resource")
    end
  end
end
