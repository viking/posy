require File.dirname(__FILE__) + '/../test_helper'

class <%= group_class %>Test < Test::Unit::TestCase
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>, :cats, :dogs, :robots
  include AuthenticatedTestHelper

  def setup
    login_as(:admin)
  end

  def test_should_create
    g = nil
    assert_difference <%= group_class %>, :count do
      g = create_<%= group_singular %>
      assert !g.new_record?, "#{g.errors.full_messages.to_sentence}"
    end

    assert_equal <%= user_plural %>(:admin)['id'], g.created_by
  end

  def test_should_require_name
    assert_no_difference <%= group_class %>, :count do
      g = create_<%= group_singular %>(:name => nil)
      assert g.errors.on(:name)
    end
  end

  def test_should_require_unique_name
    assert_no_difference <%= group_class %>, :count do
      g = create_<%= group_singular %>(:name => 'admin')
      assert g.errors.on(:name)
    end
  end

  def test_should_update
    assert update_<%= group_singular %>(:empty, :description => "I'm hollow")
    assert_equal "I'm hollow", <%= group_plural %>(:empty).description

    assert_equal <%= user_plural %>(:admin).id, <%= group_plural %>(:empty).updated_by
  end

  def test_should_not_update
    # can't update permanent <%= group_plural %>
    assert_raises(RuntimeError) { update_<%= group_singular %>(:admin, :name => 'foo') }
  end

  def test_should_destroy
    g = <%= group_plural %>(:empty)
    assert_difference(<%= group_class %>, :count, -1) { g.destroy }
    assert <%= membership_class %>.find(:all, :conditions => ['<%= group_singular %>_id = ?', g.id]).empty?
    assert <%= permission_class %>.find(:all, :conditions => ['<%= group_singular %>_id = ?', g.id]).empty?
  end

  def test_should_not_destroy
    g = <%= group_plural %>(:admin)
    assert_raises(RuntimeError) { g.destroy }
  end

  def test_include?
    g = <%= group_plural %>(:admin)
    assert g.include?(<%= user_plural %>(:admin))
    assert g.include?(1)
    assert !g.include?(2)
    assert_raises(TypeError) { g.include?('foo') }
  end

  def test_<%= membership_singular %>_association
    assert !<%= group_plural %>(:admin).<%= membership_plural %>.empty?
    assert !<%= group_plural %>(:robots_r).<%= membership_plural %>.empty?
  end

  def test_<%= user_singular %>_association
    # has_many :<%= user_plural %>, :through => :<%= membership_plural %>
    assert <%= group_plural %>(:admin).<%= user_plural %>.collect { |u| u.id }.include?(<%= user_plural %>(:admin).id)
    assert <%= group_plural %>(:robots_r).<%= user_plural %>.collect { |u| u.id }.include?(<%= user_plural %>(:robot_reader).id)
  end

  def test_<%= permission_singular %>_association
    assert !<%= group_plural %>(:robots_r).<%= permission_plural %>.empty?
    assert !<%= group_plural %>(:cats_r).<%= permission_plural %>.empty?
    assert <%= group_plural %>(:ottoman_w).<%= permission_plural %>.for(dogs(:ottoman))
    assert <%= group_plural %>(:dogs_rw).<%= permission_plural %>.for('dogs')
    assert_nil <%= group_plural %>(:cats_rw).<%= permission_plural %>.for(dogs(:mr_pants))
  end

  def test_should_belong_to_creator
    assert_equal <%= user_plural %>(:admin).id, <%= group_plural %>(:admin).creator.id
  end

  def test_should_belong_to_updater
    assert_equal <%= user_plural %>(:admin).id, <%= group_plural %>(:admin).updater.id
  end

  def test_should_get_<%= user_plural %>_not_in
    assert (<%= group_plural %>(:admin).<%= user_plural %> & <%= group_plural %>(:admin).<%= user_plural %>_not_in).empty?
    assert (<%= group_plural %>(:cats_w).<%= user_plural %> & <%= group_plural %>(:cats_w).<%= user_plural %>_not_in).empty?
    assert_equal <%= user_class %>.count, <%= group_plural %>(:empty).<%= user_plural %>_not_in.length
  end

  protected
    def create_<%= group_singular %>(options = {})
      <%= group_class %>.create({:name => 'foo', :description => 'the foo <%= group_singular %>', :permanent => false}.merge(options))
    end

    def update_<%= group_singular %>(<%= group_singular %>, options)
      <%= group_plural %>(<%= group_singular %>).update_attributes(options)
    end
end
