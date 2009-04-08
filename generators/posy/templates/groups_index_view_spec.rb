require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= group_plural %>/index" do
  before do
    @<%= group_singular %> = mock_model(<%= group_class %>, {
      :name => "foo", :description => "the foo <%= group_singular %>", :permanent => false
    })
    assigns[:<%= group_plural %>] = Array.new(3) { |i| @<%= group_singular %> }
  end

  it "should not raise an error" do
    lambda { render '<%= group_plural %>/index' }.should_not raise_error
  end
end
