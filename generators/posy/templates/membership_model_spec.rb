require File.dirname(__FILE__) + '/../spec_helper'

module <%= membership_class %>Helpers
  def create_<%= membership_singular %>(<%= user_singular %>, <%= group_singular %>)
    <%= membership_class %>.create({
      :<%= user_singular %>  => <%= user_singular %>,
      :<%= group_singular %> => <%= group_singular %>
    })
  end
end

describe <%= membership_class %> do
  include <%= membership_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:all) do
    Posy.send(:class_variable_set, "@@configuration", { 'controllers' => %w{vampires werewolves} })  # </hax>
  end

  it "should create" do
    <%= membership_singular %> = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_plural %>(:weasleys))
    <%= membership_singular %>.should_not be_a_new_record
  end

  it "should require <%= group_singular %> on creation" do
    <%= membership_singular %> = create_<%= membership_singular %>(<%= user_plural %>(:fred), nil)
    <%= membership_singular %>.errors[:<%= group_singular %>_id].should_not be_nil
  end

  it "should require <%= user_singular %> on creation" do
    <%= membership_singular %> = create_<%= membership_singular %>(nil, <%= group_plural %>(:weasleys))
    <%= membership_singular %>.errors[:<%= user_singular %>_id].should_not be_nil
  end

  it "should not allow duplicate <%= membership_plural %>" do
    <%= membership_singular %>1 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_plural %>(:weasleys))
    <%= membership_singular %>2 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_plural %>(:weasleys))
    <%= membership_singular %>1.should be_valid
    <%= membership_singular %>2.should_not be_valid
  end

  it "should not allow <%= user_plural %> to join <%= group_plural %> with overlapping <%= permission_plural %>" do
    <%= group_singular %>1 = <%= group_class %>.create(:name => "uber")
    <%= group_singular %>2 = <%= group_class %>.create(:name => "leet")
    <%= group_singular %>1.<%= permission_plural %>.create(:controller => "vampires", :can_read  => true)
    <%= group_singular %>2.<%= permission_plural %>.create(:controller => "vampires", :can_write => true)

    <%= membership_singular %>1 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_singular %>1)
    <%= membership_singular %>2 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_singular %>2)
    <%= membership_singular %>1.should be_valid
    <%= membership_singular %>2.should_not be_valid
  end
end

describe "a non-new <%= membership_singular %>" do
  include <%= membership_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= membership_singular %> = create_<%= membership_singular %>(<%= user_plural %>(:george), <%= group_plural %>(:weasleys))
  end

  it "should belong to a <%= user_singular %>" do
    @<%= membership_singular %>.<%= user_singular %>.should eql(<%= user_plural %>(:george))
  end

  it "should belong to a <%= group_singular %>" do
    @<%= membership_singular %>.<%= group_singular %>.should eql(<%= group_plural %>(:weasleys))
  end

  it "should belong to a creator" do
    @<%= membership_singular %>.creator.should eql(<%= user_plural %>(:admin))
  end

  it "should belong to an updater" do
    @<%= membership_singular %>.updater.should eql(<%= user_plural %>(:admin))
  end
end
