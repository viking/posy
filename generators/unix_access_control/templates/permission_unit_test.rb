require File.dirname(__FILE__) + '/../test_helper'

module <%= permission_class %>Helpers
  def create_<%= permission_singular %>(options)
    <%= permission_class %>.create({
      :can_read => true,
      :can_write => true,
      :is_sticky => false
    }.merge(options))
  end
end

class <%= permission_class %>Test < Test::Unit::TestCase
  include <%= permission_class %>Helpers
  fixtures :<%= group_plural %>, :<%= permission_plural %>

  def setup
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
  end

  def test_should_create_with_a_resource
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => Pocky.new)
    assert !<%= permission_singular %>.new_record?
  end

  def test_should_create_with_a_controller
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires")
    assert !<%= permission_singular %>.new_record?
  end

  def test_should_require_a_valid_controller_on_creation
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "dinosaurs")
    assert !<%= permission_singular %>.errors[:controller].nil?
  end

  def test_should_require_either_a_resource_or_a_controller_on_creation
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys))
    assert !<%= permission_singular %>.errors[:controller].nil?
    assert !<%= permission_singular %>.errors[:resource_id].nil?
  end

  def test_should_not_allow_both_a_resource_and_a_controller_on_creation
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires", :resource => Pocky.new)
    assert !<%= permission_singular %>.errors[:controller].nil?
    assert !<%= permission_singular %>.errors[:resource_id].nil?
  end

  def test_should_require_a_resource_type_when_there_s_a_resource_id
    <%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource_id => 1)
    assert !<%= permission_singular %>.errors[:resource_type].nil?
  end

  def test_should_require_a_<%= group_singular %>_on_creation
    <%= permission_singular %> = create_<%= permission_singular %>(:resource => Pocky.new)
    assert !<%= permission_singular %>.errors[:<%= group_singular %>_id].nil?
  end

  def test_should_not_allow_duplicate_resource_<%= permission_plural %>
    pocky = Pocky.new
    <%= permission_singular %>1 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => pocky)
    <%= permission_singular %>2 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => pocky)
    assert <%= permission_singular %>1.valid?
    assert !<%= permission_singular %>2.valid?
  end

  def test_should_not_allow_duplicate_controller_<%= permission_plural %>
    <%= permission_singular %>1 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires")
    <%= permission_singular %>2 = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => "vampires")
    assert <%= permission_singular %>1.valid?
    assert !<%= permission_singular %>2.valid?
  end
end

module AnExisting<%= permission_class %>Behavior
  def test_should_update
    assert @<%= permission_singular %>.update_attributes(:can_read => false, :can_write => true)
  end

  def test_should_belong_to_a_<%= group_singular %>
    assert_equal <%= group_plural %>(:weasleys), @<%= permission_singular %>.<%= group_singular %>
  end

  def test_should_belong_to_a_creator
    assert_equal <%= user_plural %>(:admin), @<%= permission_singular %>.creator
  end

  def test_should_belong_to_a_updater
    assert_equal <%= user_plural %>(:admin), @<%= permission_singular %>.updater
  end
end

class AnExistingResource<%= permission_class %>Test < Test::Unit::TestCase
  include <%= permission_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @pocky = Pocky.new
    @<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :resource => @pocky)
  end

  include AnExisting<%= permission_class %>Behavior

  def test_should_not_allow_duplicate_<%= permission_plural %>_on_update
    another_<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:malfoys), :resource => @pocky)
    assert !@<%= permission_singular %>.update_attributes(:<%= group_singular %> => <%= group_plural %>(:malfoys))
  end

  def test_should_belong_to_a_resource
    assert_equal @pocky, @<%= permission_singular %>.resource
  end
end

class AnExistingController<%= permission_class %>Test < Test::Unit::TestCase
  include <%= permission_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>

  def setup
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>

    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @controller = "vampires" 
    @<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:weasleys), :controller => @controller)
  end

  include AnExisting<%= permission_class %>Behavior

  def test_should_not_allow_duplicate_<%= permission_plural %>_on_update
    another_<%= permission_singular %> = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:malfoys), :controller => @controller)
    assert !@<%= permission_singular %>.update_attributes(:<%= group_singular %> => <%= group_plural %>(:malfoys))
  end
end
