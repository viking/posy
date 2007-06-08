require File.dirname(__FILE__) + '/../spec_helper'

module <%= permission_class %>Helpers
  def create_<%= permission_singular %>(options)
    <%= permission_class %>.create({
      :can_read => true,
      :can_write => true,
      :is_sticky => false
    }.merge(options))
  end
end

describe <%= permission_class %> do
  include <%= permission_class %>Helpers
  fixtures :<%= group_plural %>, :<%= permission_plural %>

  before(:all) do
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  it "should create with a resource" do
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => Pocky.new)
    <%= permission_singular %>.should_not be_a_new_record
  end

  it "should create with a controller" do
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires")
    <%= permission_singular %>.should_not be_a_new_record
  end

  it "should require a valid controller on creation" do
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "dinosaurs")
    <%= permission_singular %>.errors[:controller].should_not be_nil
  end

  it "should require either a resource or a controller on creation" do
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys))
    <%= permission_singular %>.errors[:controller].should_not be_nil
    <%= permission_singular %>.errors[:resource_id].should_not be_nil
  end

  it "should not allow both a resource and a controller on creation" do
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires", :resource => Pocky.new)
    <%= permission_singular %>.errors[:controller].should_not be_nil
    <%= permission_singular %>.errors[:resource_id].should_not be_nil
  end

  it "should require a resource_type when there's a resource_id" do
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource_id => 1)
    <%= permission_singular %>.errors[:resource_type].should_not be_nil
  end

  it "should require a <%= group_singular %> on creation" do
    <%= permission_singular %> = create_<%= permission_singular %>(:resource => Pocky.new)
    <%= permission_singular %>.errors[:<%= group_singular %>_id].should_not be_nil
  end

  it "should not allow duplicate resource <%= permission_plural %>" do
    pocky = Pocky.new
    <%= permission_singular %>1 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => pocky)
    <%= permission_singular %>2 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => pocky)
    <%= permission_singular %>1.should be_valid
    <%= permission_singular %>2.should_not be_valid
  end

  it "should not allow duplicate controller <%= permission_plural %>" do
    <%= permission_singular %>1 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires")
    <%= permission_singular %>2 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires")
    <%= permission_singular %>1.should be_valid
    <%= permission_singular %>2.should_not be_valid
  end
end

describe "an existing <%= permission_singular %>", :shared => true do
  it "should update" do
    @<%= permission_singular %>.update_attributes(:can_read => false, :can_write => true).should be_true
  end

  it "should belong to a <%= group_singular %>" do
    @<%= permission_singular %>.<%= group_singular %>.should eql(<%= group_plural %>(:weasleys))
  end

  it "should belong to a creator" do
    @<%= permission_singular %>.creator.should eql(<%= user_plural %>(:admin))
  end

  it "should belong to a updater" do
    @<%= permission_singular %>.updater.should eql(<%= user_plural %>(:admin))
  end
end

describe "an existing resource <%= permission_singular %>" do
  include <%= permission_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @pocky = Pocky.new
    @<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => @pocky)
  end

  it_should_behave_like "an existing <%= permission_singular %>"

  it "should not allow duplicate <%= permission_plural %> on update" do
    another_<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:malfoys), :resource => @pocky)
    @<%= permission_singular %>.update_attributes(:<%= group_singular %> => <%= group_plural %>(:malfoys)).should be_false
  end

  it "should belong to a resource" do
    @<%= permission_singular %>.resource.should == @pocky
  end
end

describe "an existing controller <%= permission_singular %>" do
  include <%= permission_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>

  before(:all) do
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  before(:each) do
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @controller = "vampires" 
    @<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => @controller)
  end

  it_should_behave_like "an existing <%= permission_singular %>"

  it "should not allow duplicate <%= permission_plural %> on update" do
    another_<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:malfoys), :controller => @controller)
    @<%= permission_singular %>.update_attributes(:<%= group_singular %> => <%= group_plural %>(:malfoys)).should be_false
  end
end
