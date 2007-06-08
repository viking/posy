require File.dirname(__FILE__) + '/../test_helper'

module <%= membership_class %>Helpers
  def create_<%= membership_singular %>(<%= user_singular %>, <%= group_singular %>)
    <%= membership_class %>.create({
      :<%= user_singular %>  => <%= user_singular %>,
      :<%= group_singular %> => <%= group_singular %>
    })
  end
end

class <%= membership_class %>Test < Test::Unit::TestCase
  include <%= membership_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  def setup
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => %w{vampires werewolves} })  # </hax>
  end

  def test_should_create
    <%= membership_singular %> = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_plural %>(:weasleys))
    assert !<%= membership_singular %>.new_record?
  end

  def test_should_require_<%= group_singular %>_on_creation
    <%= membership_singular %> = create_<%= membership_singular %>(<%= user_plural %>(:fred), nil)
    assert !<%= membership_singular %>.errors[:<%= group_singular %>_id].nil?
  end

  def test_should_require_<%= user_singular %>_on_creation
    <%= membership_singular %> = create_<%= membership_singular %>(nil, <%= group_plural %>(:weasleys))
    assert !<%= membership_singular %>.errors[:<%= user_singular %>_id].nil?
  end

  def test_should_not_allow_duplicate_<%= membership_plural %>
    <%= membership_singular %>1 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_plural %>(:weasleys))
    <%= membership_singular %>2 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_plural %>(:weasleys))
    assert <%= membership_singular %>1.valid?
    assert !<%= membership_singular %>2.valid?
  end

  def test_should_not_allow_<%= user_plural %>_to_join_<%= group_plural %>_with_overlapping_<%= permission_plural %>
    <%= group_singular %>1 = <%= group_class %>.create(:name => "uber")
    <%= group_singular %>2 = <%= group_class %>.create(:name => "leet")
    <%= group_singular %>1.<%= permission_plural %>.create(:controller => "vampires", :can_read  => true)
    <%= group_singular %>2.<%= permission_plural %>.create(:controller => "vampires", :can_write => true)

    <%= membership_singular %>1 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_singular %>1)
    <%= membership_singular %>2 = create_<%= membership_singular %>(<%= user_plural %>(:fred), <%= group_singular %>2)
    assert <%= membership_singular %>1.valid?
    assert !<%= membership_singular %>2.valid?
  end
end

class AnExisting<%= membership_class %>Test < Test::Unit::TestCase
  include <%= membership_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= membership_singular %> = create_<%= membership_singular %>(<%= user_plural %>(:george), <%= group_plural %>(:weasleys))
  end

  def test_should_belong_to_a_<%= user_singular %>
    assert_equal <%= user_plural %>(:george), @<%= membership_singular %>.<%= user_singular %>
  end

  def test_should_belong_to_a_<%= group_singular %>
    assert_equal <%= group_plural %>(:weasleys), @<%= membership_singular %>.<%= group_singular %>
  end

  def test_should_belong_to_a_creator
    assert_equal <%= user_plural %>(:admin), @<%= membership_singular %>.creator
  end

  def test_should_belong_to_an_updater
    assert_equal <%= user_plural %>(:admin), @<%= membership_singular %>.updater
  end
end
