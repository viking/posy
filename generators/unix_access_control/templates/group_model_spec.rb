require File.dirname(__FILE__) + '/../spec_helper'

module <%= group_class %>Helpers
  def create_<%= group_singular %>(options = {})
    <%= group_class %>.create({
      :name => 'foo', 
      :description => 'the foo <%= group_singular %>', 
      :permanent => false
    }.merge(options))
  end
end

describe <%= group_class %> do
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  it "should create a new <%= group_singular %>" do
    <%= group_singular %> = create_<%= group_singular %>
    <%= group_singular %>.should_not be_a_new_record
  end

  it "should require name on creation" do
    <%= group_singular %> = create_<%= group_singular %>(:name => nil)
    <%= group_singular %>.errors[:name].should_not be_nil
  end

  it "should require a unique name on creation" do
    <%= group_singular %>1 = create_<%= group_singular %>
    <%= group_singular %>2 = create_<%= group_singular %>
    <%= group_singular %>1.errors[:name].should be_nil
    <%= group_singular %>2.errors[:name].should_not be_nil
  end

  it "should belong to creator" do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    <%= group_singular %> = create_<%= group_singular %>
    <%= group_singular %>.creator.should eql(<%= user_plural %>(:admin))
  end
end

describe "an existing <%= group_singular %>", :shared => true do
  it "should belong to creator" do
    @<%= group_singular %>.creator.should eql(<%= user_plural %>(:admin))
  end
end

describe "a non-permanent <%= group_singular %>" do
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>
  end

  it_should_behave_like "an existing <%= group_singular %>"

  it "should update" do
    @<%= group_singular %>.update_attribute(:description, "1337 h4x0rz").should be_true
  end

  it "should belong to updater after updating" do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %>.update_attribute(:description, "1337 h4x0rz")
    @<%= group_singular %>.updater.should eql(<%= user_plural %>(:admin))
  end

  it "should destroy" do
    old_count = <%= group_class %>.count
    @<%= group_singular %>.destroy
    <%= group_class %>.count.should < old_count
  end
end

describe "a permanent <%= group_singular %>" do
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>(:permanent => true)
  end

  it_should_behave_like "an existing <%= group_singular %>"

  it "should raise an error when trying to update" do
    lambda do
      @<%= group_singular %>.update_attribute(:description, "1337 h4x0rz").should be_true
    end.should raise_error
  end

  it "should raise an error when trying to destroy" do
    lambda do
      @<%= group_singular %>.destroy
    end.should raise_error
  end
end

describe "a <%= group_singular %> with two <%= user_plural %>" do
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>
    @<%= group_singular %>.<%= user_plural %> << <%= user_plural %>(:fred)
    @<%= group_singular %>.<%= user_plural %> << <%= user_plural %>(:george)
  end

  it_should_behave_like "an existing <%= group_singular %>"

  it "should include the first <%= user_singular %>" do
    @<%= group_singular %>.should include(<%= user_plural %>(:fred))
  end

  it "should include the first <%= user_singular %>'s id" do
    @<%= group_singular %>.should include(<%= user_plural %>(:fred).id)
  end

  it "should not include a <%= user_singular %> not in the <%= group_singular %>" do
    @<%= group_singular %>.should_not include(<%= user_plural %>(:draco))
  end

  it "should have two <%= membership_plural %>" do
    @<%= group_singular %>.should have(2).<%= membership_plural %>
  end

  it "should have two <%= user_plural %>" do
    @<%= group_singular %>.should have(2).<%= user_plural %>
  end


  it "should have excluded <%= user_plural %>" do
    @<%= group_singular %>.should have_at_least(1).<%= user_plural %>_not_in
  end
end

describe "a <%= group_singular %> with one <%= permission_singular %>" do
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>, :<%= permission_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>
    @perm = @<%= group_singular %>.<%= permission_plural %>.create(:resource => <%= user_plural %>(:admin))
  end

  it_should_behave_like "an existing <%= group_singular %>"

  it "should have that <%= permission_singular %>" do
    @<%= group_singular %>.<%= permission_plural %>[0].should eql(@perm)
  end
end
