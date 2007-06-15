require File.dirname(__FILE__) + '/../../spec_helper'

describe "rendering /<%= session_plural %>/new" do
  it "should not raise an error" do
    lambda { render '<%= session_plural %>/new' }.should_not raise_error
  end

  it "should have a form with an action of /<%= session_plural %>" do
    render '<%= session_plural %>/new'
    response.should have_tag("form[action=/<%= session_plural %>]")
  end
end
