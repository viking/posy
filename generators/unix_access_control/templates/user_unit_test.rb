require File.dirname(__FILE__) + '/../test_helper'

class <%= user_class %>Test < Test::Unit::TestCase
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>, :cats, :dogs, :robots
  include AuthenticatedTestHelper

  def test_should_create_<%= user_singular %>
    login_as :admin
    <%= user_singular %> = nil
    assert_difference(<%= user_class %>, :count) do
      <%= user_singular %> = create_<%= user_singular %>
      assert !<%= user_singular %>.new_record?, "#{<%= user_singular %>.errors.full_messages.to_sentence}"
    end

    assert_equal <%= user_plural %>(:admin).id, <%= user_singular %>.created_by
  end

  def test_should_require_login
    assert_no_difference <%= user_class %>, :count do
      u = create_<%= user_singular %>(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference <%= user_class %>, :count do
      u = create_<%= user_singular %>(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference <%= user_class %>, :count do
      u = create_<%= user_singular %>(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference <%= user_class %>, :count do
      u = create_<%= user_singular %>(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    update_<%= user_singular %>(:admin, :password => 'new password', :password_confirmation => 'new password')
    assert_equal <%= user_plural %>(:admin), <%= user_class %>.authenticate('admin', 'new password')
  end

  def test_should_not_rehash_password
    update_<%= user_singular %>(:admin, :login => 'admin2')
    assert_equal <%= user_plural %>(:admin), <%= user_class %>.authenticate('admin2', 'test')
  end

  def test_should_authenticate_<%= user_singular %>
    assert_equal <%= user_plural %>(:admin), <%= user_class %>.authenticate('admin', 'test')
  end

  def test_should_destroy_<%= user_singular %>
    u = <%= user_plural %>(:robot_reader)
    assert_difference(<%= user_class %>, :count, -1) { u.destroy }
    assert <%= membership_class %>.find(:all, :conditions => ['<%= user_singular %>_id = ?', u.id]).empty?
  end

  def test_<%= membership_singular %>_association
    assert !<%= user_plural %>(:admin).<%= membership_plural %>.empty?
    assert !<%= user_plural %>(:robot_reader).<%= membership_plural %>.empty?
  end

  def test_<%= group_singular %>_association
    # has_many :<%= group_plural %>, :through => :<%= membership_plural %>
    assert <%= user_plural %>(:admin).<%= group_plural %>.collect { |g| g.id }.include?(<%= group_plural %>(:admin).id)
    assert <%= user_plural %>(:robot_reader).<%= group_plural %>.collect { |g| g.id }.include?(<%= group_plural %>(:robots_r).id)
  end

  def test_should_get_<%= permission_plural %>
    assert (perms = <%= user_plural %>(:robot_reader).<%= permission_plural %>)
    assert_equal 2, perms.length

    # make sure we get reload
    <%= user_plural %>(:robot_reader).<%= membership_plural %>.create(:<%= group_singular %> => <%= group_plural %>(:cats_r))
    assert_equal 3, <%= user_plural %>(:robot_reader).<%= permission_plural %>(true).length
  end

  def test_should_get_controller_<%= permission_plural %>
    assert (perms = <%= user_plural %>(:robot_reader).controller_<%= permission_plural %>)
    assert_equal 1, perms.length
  end

  def test_should_get_resource_<%= permission_plural %>
    assert (perms = <%= user_plural %>(:robot_reader).resource_<%= permission_plural %>)
    assert_equal 1, perms.length
  end

  def test_method_admin?
    assert <%= user_plural %>(:admin).admin?
    assert !<%= user_plural %>(:robot_reader).admin?
    assert <%= user_class %>.admin?(<%= user_plural %>(:admin))
  end

  def test_method_can_access?
    # implicit access for admins
    assert <%= user_plural %>(:admin).can_access?('cats', 'rw')
    assert <%= user_plural %>(:admin).can_access?(robots(:bender), 'rw')

    # bad input
    assert_raise(RuntimeError) { <%= user_plural %>(:admin).can_access?(123, 'rw') }
    assert_raise(RuntimeError) { <%= user_plural %>(:admin).can_access?('dogs', 'crap') }

    # explicit access through <%= group_singular %> <%= permission_plural %>
    assert <%= user_plural %>(:robot_reader).can_access?('robots', 'r')
    assert <%= user_plural %>(:dog_writer).can_access?('dogs', 'w')
    assert <%= user_plural %>(:cat_admin).can_access?('cats', 'rw')
    assert <%= user_plural %>(:dog_reader).can_access?(dogs(:ottoman), 'r')
    assert <%= user_plural %>(:cat_writer).can_access?(cats(:fluffy), 'w')
    assert <%= user_plural %>(:robot_admin).can_access?(robots(:robo), 'rw')

    # explicit access denial
    deny <%= user_plural %>(:robot_reader).can_access?('robots', 'w')
    deny <%= user_plural %>(:dog_writer).can_access?('dogs', 'r')
    deny <%= user_plural %>(:robot_reader).can_access?(robots(:robo), 'w')
    deny <%= user_plural %>(:cat_writer).can_access?(cats(:fluffy), 'r')
  end

  def test_method_can_read?
    assert <%= user_plural %>(:robot_reader).can_read?(robots(:robo))
    deny <%= user_plural %>(:cat_writer).can_read?('cats')
  end

  def test_method_can_write?
    assert <%= user_plural %>(:dog_writer).can_write?('dogs')
    deny <%= user_plural %>(:robot_reader).can_write?(robots(:robo))
  end

  def test_method_can_read_and_write?
    assert <%= user_plural %>(:cat_admin).can_read_and_write?(cats(:fluffy))
    deny <%= user_plural %>(:dog_reader).can_read_and_write?('dogs')
  end

  def test_should_belong_to_creator
    assert_equal <%= user_plural %>(:admin).id, <%= user_plural %>(:cat_reader).creator.id
  end

  def test_should_belong_to_updater
    assert_equal <%= user_plural %>(:admin).id, <%= user_plural %>(:cat_reader).updater.id
  end

  def test_should_get_<%= group_plural %>_not_in
    assert (<%= user_plural %>(:admin).<%= group_plural %> & <%= user_plural %>(:admin).<%= group_plural %>_not_in).empty?
    assert (<%= user_plural %>(:cat_admin).<%= group_plural %> & <%= user_plural %>(:cat_admin).<%= group_plural %>_not_in).empty?
    assert_equal <%= group_class %>.count, <%= user_plural %>(:hercule).<%= group_plural %>_not_in.length
  end

  protected
    def create_<%= user_singular %>(options = {})
      <%= user_class %>.create({
        :login => "arucard",
        :email => "vampires@rock.com",
        :password => "immortal",
        :password_confirmation => "immortal"
      }.update(options))
    end

    def update_<%= user_singular %>(<%= user_singular %>, options)
      <%= user_plural %>(<%= user_singular %>).update_attributes(options)
    end
end
