require File.dirname(__FILE__) + '/../spec_helper'

describe <%= user_class %>sHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the <%= user_class %>sHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(<%= user_class %>sHelper)
  end
  
end
