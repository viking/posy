require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= user_plural %>/new" do
  before do
    @<%= user_singular %> = mock_model(<%= user_class %>, {
      :login => "foo", :email => "foo@bar.com", 
      :password => nil, :password_confirmation => nil
    })
    assigns[:<%= user_singular %>] = @<%= user_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= user_plural %>/new' }.should_not raise_error
  end

  it "should have div#errorExplanation when @<%= user_singular %> has errors" do
    errors = stub("errors", :count => 1, :full_messages => ["Login can't be blank"])
    @<%= user_singular %>.stub!(:errors).and_return(errors)
    render '<%= user_plural %>/new'
    response.should have_tag("div#errorExplanation")
  end
end
