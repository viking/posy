require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= permission_plural %>/index" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @pocky = Pocky.new
    @pocky.stub(:name).and_return('teh p0cky')
    @controller_<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => "vampires", :can_read => true,
      :can_write => true, :is_sticky => false
    })
    @resource_<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => nil, :resource => @pocky,
      :can_read => true, :can_write => true, :is_sticky => false
    })
    @<%= permission_plural %> = [@controller_<%= permission_singular %>, @resource_<%= permission_singular %>]
    assigns[:<%= permission_plural %>] = @<%= permission_plural %>
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/index' }.should_not raise_error
  end

  it "should call resource_link twice" do
    @controller.template.should_receive(:resource_link).exactly(2).times
    render '/<%= permission_plural %>/index'
  end
end

describe "rendering /<%= permission_plural %>/index when @<%= group_singular %> is set" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, :name => "dudes")
    @pocky = Pocky.new
    @pocky.stub(:name).and_return('teh p0cky')
    @controller_<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => "vampires", :can_read => true,
      :can_write => true, :is_sticky => false
    })
    @resource_<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :<%= group_singular %> => @<%= group_singular %>, :controller => nil, :resource => @pocky,
      :can_read => true, :can_write => true, :is_sticky => false
    })
    @<%= permission_plural %> = [@controller_<%= permission_singular %>, @resource_<%= permission_singular %>]
    assigns[:<%= permission_plural %>] = @<%= permission_plural %>
    assigns[:<%= group_singular %>] = @<%= group_singular %>
  end

  it "should not raise an error" do
    lambda { render '/<%= permission_plural %>/index' }.should_not raise_error
  end

  it "should have a back link to <%= group_singular %>_path(@<%= group_singular %>)" do
    render '/<%= permission_plural %>/index'
    url = <%= group_singular %>_path(@<%= group_singular %>)
    response.should have_tag("a[href=#{url}]", "Back")
  end
end
