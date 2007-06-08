require File.dirname(__FILE__) + '/../test_helper'

module <%= group_class %>Helpers
  def create_<%= group_singular %>(options = {})
    <%= group_class %>.create({
      :name => 'foo', 
      :description => 'the foo <%= group_singular %>', 
      :permanent => false
    }.merge(options))
  end
end

class <%= group_class %>Test < Test::Unit::TestCase
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  def test_should_create_a_new_<%= group_singular %>
    <%= group_singular %> = create_<%= group_singular %>
    assert !<%= group_singular %>.new_record?
  end

  def test_should_require_name_on_creation
    <%= group_singular %> = create_<%= group_singular %>(:name => nil)
    assert !<%= group_singular %>.errors[:name].nil?
  end

  def test_should_require_a_unique_name_on_creation
    <%= group_singular %>1 = create_<%= group_singular %>
    <%= group_singular %>2 = create_<%= group_singular %>
    assert <%= group_singular %>1.errors[:name].nil?
    assert !<%= group_singular %>2.errors[:name].nil?
  end

  def test_should_belong_to_creator
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    <%= group_singular %> = create_<%= group_singular %>
    assert_equal <%= user_plural %>(:admin), <%= group_singular %>.creator
  end
end

module AnExisting<%= group_class %>Behavior
  def test_should_belong_to_creator
    assert_equal <%= user_plural %>(:admin), @<%= group_singular %>.creator
  end
end

class ANonPermanent<%= group_class %>Test < Test::Unit::TestCase
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>
  end

  include AnExisting<%= group_class %>Behavior

  def test_should_update
    assert @<%= group_singular %>.update_attribute(:description, "1337 h4x0rz")
  end

  def test_should_belong_to_updater_after_updating
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %>.update_attribute(:description, "1337 h4x0rz")
    assert_equal <%= user_plural %>(:admin), @<%= group_singular %>.updater
  end

  def test_should_destroy
    old_count = <%= group_class %>.count
    @<%= group_singular %>.destroy
    assert <%= group_class %>.count < old_count
  end
end

class APermanent<%= group_class %>Test < Test::Unit::TestCase
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>(:permanent => true)
  end

  include AnExisting<%= group_class %>Behavior

  def test_should_raise_an_error_when_trying_to_update
    assert_raises(RuntimeError) do
      assert @<%= group_singular %>.update_attribute(:description, "1337 h4x0rz")
    end
  end

  def test_should_raise_an_error_when_trying_to_destroy
    assert_raises(RuntimeError) do
      @<%= group_singular %>.destroy
    end
  end
end

class A<%= group_class %>WithTwo<%= user_class %>sTest < Test::Unit::TestCase
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>
    @<%= group_singular %>.<%= user_plural %> << <%= user_plural %>(:fred)
    @<%= group_singular %>.<%= user_plural %> << <%= user_plural %>(:george)
  end

  include AnExisting<%= group_class %>Behavior

  def test_should_include_the_first_<%= user_singular %>
    assert @<%= group_singular %>.include?(<%= user_plural %>(:fred))
  end

  def test_should_include_the_first_<%= user_singular %>_s_id
    assert @<%= group_singular %>.include?(<%= user_plural %>(:fred).id)
  end

  def test_should_not_include_a_<%= user_singular %>_not_in_the_<%= group_singular %>
    assert !@<%= group_singular %>.include?(<%= user_plural %>(:draco))
  end

  def test_should_have_two_<%= membership_plural %>
    assert_equal 2, @<%= group_singular %>.<%= membership_plural %>.length
  end

  def test_should_have_two_<%= user_plural %>
    assert_equal 2, @<%= group_singular %>.<%= user_plural %>.length
  end


  def test_should_have_excluded_<%= user_plural %>
    assert @<%= group_singular %>.<%= user_plural %>_not_in.length >= 1
  end
end

class A<%= group_class %>WithOne<%= permission_class %>Test < Test::Unit::TestCase
  include <%= group_class %>Helpers
  fixtures :<%= group_plural %>, :<%= user_plural %>, :<%= permission_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= group_singular %> = create_<%= group_singular %>
    @perm = @<%= group_singular %>.<%= permission_plural %>.create(:resource => <%= user_plural %>(:admin))
  end

  include AnExisting<%= group_class %>Behavior

  def test_should_have_that_<%= permission_singular %>
    assert_equal @perm, @<%= group_singular %>.<%= permission_plural %>[0]
  end
end
