require File.dirname(__FILE__) + '/../test_helper'

class <%= permission_class %>Test < Test::Unit::TestCase
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>, :cats, :dogs, :robots
  include AuthenticatedTestHelper

  def setup
    login_as :admin
  end

  def test_should_create_with_resource
    perm = nil
    assert_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>
      assert !perm.new_record?, "#{perm.errors.full_messages.to_sentence}"
    end

    assert_equal <%= user_plural %>(:admin).id, perm.created_by
  end

  def test_should_create_with_controller
    perm = nil
    assert_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:resource => nil, :controller => 'dogs')
      assert !perm.new_record?, "#{perm.errors.full_messages.to_sentence}"
    end

    assert_equal <%= user_plural %>(:admin).id, perm.created_by
  end

  def test_should_require_valid_controller
    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:resource => nil, :controller => 'foo')
      assert perm.errors.on(:controller)
    end
  end

  def test_should_require_either_resource_or_controller_but_not_both
    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:resource => nil, :controller => nil)
      assert perm.errors.on(:controller)
      assert perm.errors.on(:resource_id)
    end

    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:controller => 'dogs')
      assert perm.errors.on(:controller)
      assert perm.errors.on(:resource_id)
    end
  end

  def test_should_require_resource_type
    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:resource => nil, :resource_id => 1, :resource_type => nil)
      assert perm.errors.on(:resource_type)
    end
  end

  def test_should_require_<%= group_singular %>
    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:<%= group_singular %> => nil)
      assert perm.errors.on(:<%= group_singular %>_id)
    end
  end

  def test_should_require_unique_<%= permission_plural %>
    # duplicate <%= group_singular %>/resource
    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:ottoman_r), :resource => dogs(:ottoman))
      assert perm.errors.on(:resource_id)
    end

    # duplicate <%= group_singular %>/controller
    assert_no_difference <%= permission_class %>, :count do
      perm = create_<%= permission_singular %>(:<%= group_singular %> => <%= group_plural %>(:dogs_r), :controller => 'dogs', :resource => nil)
      assert perm.errors.on(:controller)
    end
  end

  def test_should_update_<%= permission_singular %>
    perm = <%= permission_plural %>(:one)
    assert update_<%= permission_singular %>(perm, {}), perm.errors.full_messages.to_sentence 
  end

  def test_should_require_unique_<%= permission_plural %>_on_update
    # duplicate <%= group_singular %>/resource; change dogs(:ottoman) to cats(:fluffy), which exists
    perm = <%= permission_plural %>(:thirty_one)
    update_<%= permission_singular %>(perm, :resource => cats(:fluffy))
    assert perm.errors.on(:resource_id)

    # duplicate <%= group_singular %>/controller; change dogs to cats, which exists
    perm = <%= permission_plural %>(:twenty_two)
    update_<%= permission_singular %>(perm, :controller => 'cats')
    assert perm.errors.on(:controller)
  end

  def test_<%= group_singular %>_association
    assert_equal <%= group_plural %>(:robots_r).id, <%= permission_plural %>(:one).<%= group_singular %>.id
    assert_equal <%= group_plural %>(:robots_w).id, <%= permission_plural %>(:two).<%= group_singular %>.id
  end

  def test_resource_association
    assert       <%= permission_plural %>(:ten).resource.is_a?(Dog)
    assert_equal dogs(:ottoman).id, <%= permission_plural %>(:ten).resource.id
    assert       <%= permission_plural %>(:thirteen).resource.is_a?(Cat)
    assert_equal cats(:fluffy).id, <%= permission_plural %>(:thirteen).resource.id
  end

  def test_should_belong_to_creator
    assert_equal <%= user_plural %>(:admin).id, <%= permission_plural %>(:one).creator.id
  end

  def test_should_belong_to_updater
    assert_equal <%= user_plural %>(:admin).id, <%= permission_plural %>(:one).updater.id
  end

  protected
    def create_<%= permission_singular %>(options = {})
      <%= permission_class %>.create({
        :<%= group_singular %> => <%= group_plural %>(:empty),
        :resource => cats(:merle),
        :can_read => true,
        :can_write => true,
        :is_sticky => false
      }.update(options))
    end

    def update_<%= permission_singular %>(<%= permission_singular %>, options)
      <%= permission_singular %> = <%= permission_plural %>(<%= permission_singular %>)  if <%= permission_singular %>.is_a?(Symbol)
      <%= permission_singular %>.update_attributes(options)
    end
end
