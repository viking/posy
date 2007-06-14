require File.dirname(__FILE__) + '/../spec_helper'

describe <%= group_class %>sHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the <%= group_class %>sHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(<%= group_class %>sHelper)
  end
  
end
