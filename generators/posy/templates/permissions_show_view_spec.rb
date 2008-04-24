require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= permission_plural %>/show for a controller <%= permission_singular %>" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => 'dudes')
    @<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => 'vampires', :can_read => true,
      :can_write => false, :is_sticky => false
    })
    assigns[:<%= permission_singular %>] = @<%= permission_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= permission_plural %>/show' }.should_not raise_error
  end

  it "should display the controller" do
    render '<%= permission_plural %>/show'
    response.should have_tag("p", /vampires/) do
      with_tag("b", "Controller:")
    end
  end
end

describe "rendering /<%= permission_plural %>/show for a resource <%= permission_singular %>" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => 'dudes')
    @pocky = Pocky.new
    @<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => nil, :resource => @pocky,
      :can_read => true, :can_write => false, :is_sticky => false
    })
    assigns[:<%= permission_singular %>] = @<%= permission_singular %>
    @controller.template.stub!(:resource_link).and_return('teh p0cky')
  end

  it "should not raise an error" do
    lambda { render '<%= permission_plural %>/show' }.should_not raise_error
  end

  it "should display the resource" do
    render '<%= permission_plural %>/show'
    response.should have_tag("p", /teh p0cky/) do
      with_tag("b", "Resource:")
    end
  end
end
