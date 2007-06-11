require File.dirname(__FILE__) + '/../spec_helper'
require 'pp'

module <%= user_class %>Helpers
  def create_<%= user_singular %>(options = {})
    <%= user_class %>.create({
      :login => "alucard",
      :email => "vampires@rock.com",
      :password => "immortal",
      :password_confirmation => "immortal"
    }.update(options))
  end
end

describe <%= user_class %> do
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>

  it "should create a new <%= user_singular %>" do
    <%= user_singular %> = create_<%= user_singular %>
    <%= user_singular %>.should_not be_a_new_record
  end

  it "should require a login on creation" do
    <%= user_singular %> = create_<%= user_singular %>(:login => nil)
    <%= user_singular %>.errors[:login].should_not be_nil
  end

  it "should require a password on creation" do
    <%= user_singular %> = create_<%= user_singular %>(:password => nil)
    <%= user_singular %>.errors[:password].should_not be_nil
  end

  it "should require a password confirmation on creation" do
    <%= user_singular %> = create_<%= user_singular %>(:password_confirmation => nil)
    <%= user_singular %>.errors[:password_confirmation].should_not be_nil
  end

  it "should require an email on creation" do
    <%= user_singular %> = create_<%= user_singular %>(:email => nil)
    <%= user_singular %>.errors[:email].should_not be_nil
  end

  it "should authenticate a <%= user_singular %> with a correct password" do
    <%= user_class %>.authenticate('admin', 'test').should == <%= user_plural %>(:admin)
  end
end

describe "a non-new <%= user_singular %>" do
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= user_singular %> = create_<%= user_singular %>
  end

  it "should be valid" do
    @<%= user_singular %>.should be_valid
  end

  it "should reset its password" do
    @<%= user_singular %>.update_attributes(:password => "blood", :password_confirmation => "blood")
    <%= user_class %>.authenticate('alucard', 'blood').should == @<%= user_singular %>
  end

  it "should not rehash its password if not changing it" do
    @<%= user_singular %>.update_attribute(:login, 'arucard')
    <%= user_class %>.authenticate('arucard', 'immortal').should == @<%= user_singular %>
  end

  it "should get <%= group_plural %> not in" do
    @<%= user_singular %>.should have_at_least(1).<%= group_plural %>_not_in
  end

  it "should belong to a creator" do
    @<%= user_singular %>.creator.should == <%= user_plural %>(:admin)
  end

  it "should belong to an updater" do
    @<%= user_singular %>.updater.should == <%= user_plural %>(:admin)
  end

  it "should not be an admin" do
    @<%= user_singular %>.should_not be_an_admin
  end
end

describe "a <%= user_singular %> that belongs in a <%= group_singular %> with one <%= permission_singular %>" do
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>

  before(:all) do
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)

    @<%= user_singular %> = create_<%= user_singular %>
    @<%= group_singular %> = <%= group_class %>.create(:name => 'vampires')
    @<%= user_singular %>.<%= group_plural %> << @<%= group_singular %>
    @perm = @<%= group_singular %>.<%= permission_plural %>.create(:controller => 'vampires', :can_read => true, :can_write => true)
  end

  it "should have one <%= membership_singular %>" do
    @<%= user_singular %>.should have(1).<%= membership_plural %>
  end

  it "should have one <%= group_singular %>" do
    @<%= user_singular %>.should have(1).<%= group_plural %>
  end

  it "should have one <%= permission_singular %>" do
    @<%= user_singular %>.should have(1).<%= permission_plural %>
  end

  it "should delete its <%= membership_plural %> on destroy" do
    @<%= user_singular %>.destroy
    <%= membership_class %>.find_all_by_<%= user_singular %>_id(@<%= user_singular %>.id).should be_empty
  end
end

describe "a <%= user_singular %> that belongs in a <%= group_singular %> with many <%= permission_plural %>" do
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>

  before(:all) do
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => %w{vampires werewolves unicorns} })  # </hax>
  end

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)

    @<%= user_singular %> = create_<%= user_singular %>
    <%= group_singular %> = <%= group_class %>.create(:name => 'vampires')
    <%= group_singular %>.<%= permission_plural %>.create(:controller => 'vampires',   :can_read => true, :can_write => true)
    <%= group_singular %>.<%= permission_plural %>.create(:controller => 'werewolves', :can_read => true, :can_write => false)
    <%= group_singular %>.<%= permission_plural %>.create(:controller => 'unicorns',   :can_read => false, :can_write => true)

    @pocky = Array.new(3) { |i| Pocky.new(i+1) }
    <%= group_singular %>.<%= permission_plural %>.create(:resource => @pocky[0], :can_read => true, :can_write => true)
    <%= group_singular %>.<%= permission_plural %>.create(:resource => @pocky[1], :can_read => true, :can_write => false)
    <%= group_singular %>.<%= permission_plural %>.create(:resource => @pocky[2], :can_read => false, :can_write => true)
    @<%= user_singular %>.<%= group_plural %> << <%= group_singular %>
  end

  it "should have six <%= permission_plural %>" do
    @<%= user_singular %>.should have(6).<%= permission_plural %>
  end

  it "should have three controller <%= permission_plural %>" do
    @<%= user_singular %>.should have(3).controller_<%= permission_plural %>
  end

  it "should have three resource <%= permission_plural %>" do
    @<%= user_singular %>.should have(3).resource_<%= permission_plural %>
  end

  # can't have too many tests =)
  it "should have read and write access to the vampires controller" do
    @<%= user_singular %>.should have_access_to("vampires", "rw")
    @<%= user_singular %>.should have_read_and_write_access_to("vampires")
  end

  it "should have read access to the werewolves controller" do
    @<%= user_singular %>.should have_access_to("werewolves", "r")
    @<%= user_singular %>.should have_read_access_to("werewolves")
  end

  it "should not have write access to the werewolves controller" do
    @<%= user_singular %>.should_not have_access_to("werewolves", "w")
    @<%= user_singular %>.should_not have_write_access_to("werewolves")
  end

  it "should not have read and write access to the werewolves controller" do
    @<%= user_singular %>.should_not have_access_to("werewolves", "rw")
    @<%= user_singular %>.should_not have_read_and_write_access_to("werewolves")
  end

  it "should have write access to the unicorns controller" do
    @<%= user_singular %>.should have_access_to("unicorns", "w")
    @<%= user_singular %>.should have_write_access_to("unicorns")
  end

  it "should not have read access to the unicorns controller" do
    @<%= user_singular %>.should_not have_access_to("unicorns", "r")
    @<%= user_singular %>.should_not have_read_access_to("unicorns")
  end

  it "should not have read and write access to the unicorns controller" do
    @<%= user_singular %>.should_not have_access_to("unicorns", "rw")
    @<%= user_singular %>.should_not have_read_and_write_access_to("unicorns")
  end

  it "should have read and write access to pocky #1" do
    @<%= user_singular %>.should have_access_to(@pocky[0], "rw")
    @<%= user_singular %>.should have_read_and_write_access_to(@pocky[0])
  end

  it "should have read access to pocky #2" do
    @<%= user_singular %>.should have_access_to(@pocky[1], "r")
    @<%= user_singular %>.should have_read_access_to(@pocky[1])
  end

  it "should not have write access to pocky #2" do
    @<%= user_singular %>.should_not have_access_to(@pocky[1], "w")
    @<%= user_singular %>.should_not have_write_access_to(@pocky[1])
  end

  it "should not have read and write access to pocky #2" do
    @<%= user_singular %>.should_not have_access_to(@pocky[1], "rw")
    @<%= user_singular %>.should_not have_read_and_write_access_to(@pocky[1])
  end

  it "should have write access to pocky #3" do
    @<%= user_singular %>.should have_access_to(@pocky[2], "w")
    @<%= user_singular %>.should have_write_access_to(@pocky[2])
  end

  it "should not have read access to pocky #3" do
    @<%= user_singular %>.should_not have_access_to(@pocky[2], "r")
    @<%= user_singular %>.should_not have_read_access_to(@pocky[2])
  end

  it "should not have read and write access to pocky #3" do
    @<%= user_singular %>.should_not have_access_to(@pocky[2], "rw")
    @<%= user_singular %>.should_not have_read_and_write_access_to(@pocky[2])
  end
end

describe "a <%= user_singular %> in the admin <%= group_singular %>" do
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= user_singular %> = create_<%= user_singular %>
    @<%= user_singular %>.<%= membership_plural %>.create(:<%= group_singular %> => <%= group_plural %>(:admin))
  end

  it "should be an admin" do
    @<%= user_singular %>.should be_an_admin
  end
end