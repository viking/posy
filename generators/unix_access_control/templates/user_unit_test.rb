require File.dirname(__FILE__) + '/../test_helper'
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

class <%= user_class %>Test < Test::Unit::TestCase
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>

  def test_should_create_a_new_<%= user_singular %>
    <%= user_singular %> = create_<%= user_singular %>
    assert !<%= user_singular %>.new_record?
  end

  def test_should_require_a_login_on_creation
    <%= user_singular %> = create_<%= user_singular %>(:login => nil)
    assert !<%= user_singular %>.errors[:login].nil?
  end

  def test_should_require_a_password_on_creation
    <%= user_singular %> = create_<%= user_singular %>(:password => nil)
    assert !<%= user_singular %>.errors[:password].nil?
  end

  def test_should_require_a_password_confirmation_on_creation
    <%= user_singular %> = create_<%= user_singular %>(:password_confirmation => nil)
    assert !<%= user_singular %>.errors[:password_confirmation].nil?
  end

  def test_should_require_an_email_on_creation
    <%= user_singular %> = create_<%= user_singular %>(:email => nil)
    assert !<%= user_singular %>.errors[:email].nil?
  end

  def test_should_authenticate_a_<%= user_singular %>_with_a_correct_password
    assert_equal <%= user_plural %>(:admin), <%= user_class %>.authenticate('admin', 'test')
  end
end

class ANonNew<%= user_class %>Test < Test::Unit::TestCase
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= user_singular %> = create_<%= user_singular %>
  end

  def test_should_be_valid
    assert @<%= user_singular %>.valid?
  end

  def test_should_reset_its_password
    @<%= user_singular %>.update_attributes(:password => "blood", :password_confirmation => "blood")
    assert_equal @<%= user_singular %>, <%= user_class %>.authenticate('alucard', 'blood')
  end

  def test_should_not_rehash_its_password_if_not_changing_it
    @<%= user_singular %>.update_attribute(:login, 'arucard')
    assert_equal @<%= user_singular %>, <%= user_class %>.authenticate('arucard', 'immortal')
  end

  def test_should_get_<%= group_plural %>_not_in
    assert @<%= user_singular %>.<%= group_plural %>_not_in.length >= 1
  end

  def test_should_belong_to_a_creator
    assert_equal <%= user_plural %>(:admin), @<%= user_singular %>.creator
  end

  def test_should_belong_to_an_updater
    assert_equal <%= user_plural %>(:admin), @<%= user_singular %>.updater
  end

  def test_should_not_be_an_admin
    assert !@<%= user_singular %>.admin?
  end
end

class A<%= user_class %>ThatBelongsInA<%= group_class %>WithOne<%= permission_class %>Test < Test::Unit::TestCase
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>


  def setup
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => ['vampires'] })  # </hax>
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)

    @<%= user_singular %> = create_<%= user_singular %>
    @<%= group_singular %> = <%= group_class %>.create(:name => 'vampires')
    @<%= user_singular %>.<%= group_plural %> << @<%= group_singular %>
    @perm = @<%= group_singular %>.<%= permission_plural %>.create(:controller => 'vampires', :can_read => true, :can_write => true)
  end

  def test_should_have_one_<%= membership_singular %>
    assert_equal 1, @<%= user_singular %>.<%= membership_plural %>.length
  end

  def test_should_have_one_<%= group_singular %>
    assert_equal 1, @<%= user_singular %>.<%= group_plural %>.length
  end

  def test_should_have_one_<%= permission_singular %>
    assert_equal 1, @<%= user_singular %>.<%= permission_plural %>.length
  end

  def test_should_delete_its_<%= membership_plural %>_on_destroy
    @<%= user_singular %>.destroy
    assert <%= membership_class %>.find_all_by_<%= user_singular %>_id(@<%= user_singular %>.id).empty?
  end
end

class A<%= user_class %>ThatBelongsInA<%= group_class %>WithMany<%= permission_class %>sTest < Test::Unit::TestCase
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>

  def setup
    UnixAccessControl.send(:class_variable_set, "@@configuration", { 'controllers' => %w{vampires werewolves unicorns} })  # </hax>
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

  def test_should_have_six_<%= permission_plural %>
    assert_equal 6, @<%= user_singular %>.<%= permission_plural %>.length
  end

  def test_should_have_three_controller_<%= permission_plural %>
    assert_equal 3, @<%= user_singular %>.controller_<%= permission_plural %>.length
  end

  def test_should_have_three_resource_<%= permission_plural %>
    assert_equal 3, @<%= user_singular %>.resource_<%= permission_plural %>.length
  end

  # can't have too many tests =)
  def test_should_have_read_and_write_access_to_the_vampires_controller
    assert @<%= user_singular %>.has_access_to?("vampires", "rw")
    assert @<%= user_singular %>.has_read_and_write_access_to?("vampires")
  end

  def test_should_have_read_access_to_the_werewolves_controller
    assert @<%= user_singular %>.has_access_to?("werewolves", "r")
    assert @<%= user_singular %>.has_read_access_to?("werewolves")
  end

  def test_should_not_have_write_access_to_the_werewolves_controller
    assert !@<%= user_singular %>.has_access_to?("werewolves", "w")
    assert !@<%= user_singular %>.has_write_access_to?("werewolves")
  end

  def test_should_not_have_read_and_write_access_to_the_werewolves_controller
    assert !@<%= user_singular %>.has_access_to?("werewolves", "rw")
    assert !@<%= user_singular %>.has_read_and_write_access_to?("werewolves")
  end

  def test_should_have_write_access_to_the_unicorns_controller
    assert @<%= user_singular %>.has_access_to?("unicorns", "w")
    assert @<%= user_singular %>.has_write_access_to?("unicorns")
  end

  def test_should_not_have_read_access_to_the_unicorns_controller
    assert !@<%= user_singular %>.has_access_to?("unicorns", "r")
    assert !@<%= user_singular %>.has_read_access_to?("unicorns")
  end

  def test_should_not_have_read_and_write_access_to_the_unicorns_controller
    assert !@<%= user_singular %>.has_access_to?("unicorns", "rw")
    assert !@<%= user_singular %>.has_read_and_write_access_to?("unicorns")
  end

  def test_should_have_read_and_write_access_to_pocky_1
    assert @<%= user_singular %>.has_access_to?(@pocky[0], "rw")
    assert @<%= user_singular %>.has_read_and_write_access_to?(@pocky[0])
  end

  def test_should_have_read_access_to_pocky_2
    assert @<%= user_singular %>.has_access_to?(@pocky[1], "r")
    assert @<%= user_singular %>.has_read_access_to?(@pocky[1])
  end

  def test_should_not_have_write_access_to_pocky_2
    assert !@<%= user_singular %>.has_access_to?(@pocky[1], "w")
    assert !@<%= user_singular %>.has_write_access_to?(@pocky[1])
  end

  def test_should_not_have_read_and_write_access_to_pocky_2
    assert !@<%= user_singular %>.has_access_to?(@pocky[1], "rw")
    assert !@<%= user_singular %>.has_read_and_write_access_to?(@pocky[1])
  end

  def test_should_have_write_access_to_pocky_3
    assert @<%= user_singular %>.has_access_to?(@pocky[2], "w")
    assert @<%= user_singular %>.has_write_access_to?(@pocky[2])
  end

  def test_should_not_have_read_access_to_pocky_3
    assert !@<%= user_singular %>.has_access_to?(@pocky[2], "r")
    assert !@<%= user_singular %>.has_read_access_to?(@pocky[2])
  end

  def test_should_not_have_read_and_write_access_to_pocky_3
    assert !@<%= user_singular %>.has_access_to?(@pocky[2], "rw")
    assert !@<%= user_singular %>.has_read_and_write_access_to?(@pocky[2])
  end
end

class A<%= user_class %>InTheAdmin<%= group_class %>Test < Test::Unit::TestCase
  include <%= user_class %>Helpers
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= permission_plural %>, :<%= membership_plural %>

  def setup
    <%= user_class %>.current_<%= user_singular %> = <%= user_plural %>(:admin)
    @<%= user_singular %> = create_<%= user_singular %>
    @<%= user_singular %>.<%= membership_plural %>.create(:<%= group_singular %> => <%= group_plural %>(:admin))
  end

  def test_should_be_an_admin
    assert @<%= user_singular %>.admin?
  end
end
