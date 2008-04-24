require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= group_plural %>/new" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, {
      :name => nil, :description => nil, :permanent => nil
    })
    assigns[:<%= group_singular %>] = @<%= group_singular %>
  end

  it "should not raise an error" do
    lambda { render '<%= group_plural %>/new' }.should_not raise_error
  end

  it "should have div#errorExplanation when @<%= group_singular %> has errors" do
    errors = stub("errors", :count => 1, :full_messages => ["Name can't be blank"])
    @<%= group_singular %>.stub!(:errors).and_return(errors)
    render '<%= group_plural %>/new'
    response.should have_tag("div#errorExplanation")
  end
end
