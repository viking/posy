require File.dirname(__FILE__) + '/../test_helper'

class <%= membership_class %>Test < Test::Unit::TestCase
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>, :cats, :dogs, :robots
  include AuthenticatedTestHelper

  def setup
    login_as :admin
  end

  def test_should_create
    m = nil
    assert_difference <%= membership_class %>, :count do
      m = create_<%= membership_singular %>
      assert !m.new_record?, "#{m.errors.full_messages.to_sentence}"
    end

    assert_equal <%= user_plural %>(:admin).id, m.created_by
  end

  def test_should_require_<%= group_singular %>
    assert_no_difference <%= membership_class %>, :count do
      m = create_<%= membership_singular %>(:<%= group_singular %> => nil)
      assert m.errors.on(:<%= group_singular %>_id)
    end
  end

  def test_should_require_<%= user_singular %>
    assert_no_difference <%= membership_class %>, :count do
      m = create_<%= membership_singular %>(:<%= user_singular %> => nil)
      assert m.errors.on(:<%= user_singular %>_id)
    end
  end

  def test_should_deny_duplicate_<%= membership_singular %>
    assert_no_difference <%= membership_class %>, :count do
      # robot_reader is already in <%= group_singular %> 'robots_r'
      m = create_<%= membership_singular %>(:<%= group_singular %> => <%= group_plural %>(:robots_r), :<%= user_singular %> => <%= user_plural %>(:robot_reader))
      assert m.errors.on(:<%= group_singular %>_id)
    end
  end

  def test_should_require_unique_<%= permission_plural %>
    assert_no_difference <%= membership_class %>, :count do
      # robot_reader already has <%= permission_plural %> on the 'robots' controller
      m = create_<%= membership_singular %>(:<%= group_singular %> => <%= group_plural %>(:robots_w), :<%= user_singular %> => <%= user_plural %>(:robot_reader))
      assert m.errors.on(:<%= group_singular %>_id)
    end
  end

  def test_<%= group_singular %>_association
    assert <%= membership_plural %>(:one).<%= group_singular %>.is_a?(<%= group_class %>)
    assert <%= membership_plural %>(:two).<%= group_singular %>.is_a?(<%= group_class %>)
  end

  def test_<%= user_singular %>_association
    assert <%= membership_plural %>(:one).<%= user_singular %>.is_a?(<%= user_class %>)
    assert <%= membership_plural %>(:two).<%= user_singular %>.is_a?(<%= user_class %>)
  end

  def test_should_belong_to_creator
    assert_equal <%= user_plural %>(:admin).id, <%= membership_plural %>(:one).creator.id
  end

  def test_should_belong_to_updater
    assert_equal <%= user_plural %>(:admin).id, <%= membership_plural %>(:one).updater.id
  end

  protected
    def create_<%= membership_singular %>(options = {})
      <%= membership_class %>.create({
        :<%= group_singular %> => <%= group_plural %>(:empty),
        :<%= user_singular %>  => <%= user_plural %>(:robot_reader)
      }.update(options))
    end

    def update_<%= membership_singular %>(<%= membership_singular %>, options)
      <%= membership_plural %>(<%= membership_singular %>).update_attributes(options)
    end
end
