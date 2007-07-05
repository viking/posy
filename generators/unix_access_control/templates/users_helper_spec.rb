require File.dirname(__FILE__) + '/../spec_helper'

describe <%= user_plural_class %>Helper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the <%= user_plural_class %>Helper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(<%= user_plural_class %>Helper)
  end
  
end
