require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= group_plural %>/show" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, {
      :name => "foo", :description => "the foo <%= group_singular %>", :permanent => false,
      :created_at => Time.now, :updated_at => Time.now, :creator => nil, :updater => nil
    })

    @<%= user_singular %> = mock_model(<%= user_class %>, :login => 'dude', :email => 'guy@dudes.com')
    @<%= user_plural %> = Array.new(3, @<%= user_singular %>)
    @<%= group_singular %>.stub(:<%= user_plural %>).and_return(@<%= user_plural %>)

    @pocky = Pocky.new
    @resource_<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :can_read => true, :can_write => false, :is_sticky => true,
      :controller => nil, :resource => @pocky
    })
    @controller_<%= permission_singular %> = mock_model(<%= permission_class %>, {
      :can_read => true, :can_write => false, :is_sticky => true,
      :controller => "pockies"
    })
    @<%= permission_plural %> = [@resource_<%= permission_singular %>, @controller_<%= permission_singular %>]
    @<%= group_singular %>.stub(:<%= permission_plural %>).and_return(@<%= permission_plural %>)

    assigns[:<%= group_singular %>] = @<%= group_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= group_plural %>/show' }.should_not raise_error
  end
end
