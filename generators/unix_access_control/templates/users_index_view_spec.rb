require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= user_plural %>/index" do
  before do
    @<%= user_singular %> = mock_model(<%= user_class %>, :login => "foo", :email => "foo@bar.com")
    assigns[:<%= user_plural %>] = Array.new(3, @<%= user_singular %>)
  end
 
  it "should not raise an error" do
    lambda { render '<%= user_plural %>/index' }.should_not raise_error
  end
end
