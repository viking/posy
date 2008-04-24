require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= user_plural %>/show" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, {
      :name => 'dudes', :description => 'a <%= group_singular %> for dudes', :permanent => false
    })
    @<%= group_plural %> = Array.new(3, @<%= group_singular %>)
    @<%= user_singular %> = mock_model(<%= user_class %>, {
      :login => "foo", :email => "foo@bar.com", :created_at => Time.now, 
      :updated_at => Time.now, :creator => @<%= user_singular %>, :updater => @<%= user_singular %>, :<%= group_plural %> => @<%= group_plural %>
    })
    assigns[:<%= user_singular %>] = @<%= user_singular %>
  end
  
  it "should not raise an error" do
    lambda { render '<%= user_plural %>/show' }.should_not raise_error
  end
end
