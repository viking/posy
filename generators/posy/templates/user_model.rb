require 'digest/sha1'
class <%= user_class %> < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  # needed for the <%= user_plural %>tamp plugin
  cattr_accessor :current_<%= user_singular %>

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  has_many :<%= membership_plural %>, :dependent => :destroy
  has_many :<%= group_plural %>, :through => :<%= membership_plural %>
  belongs_to :creator, :class_name => "<%= user_class %>", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "<%= user_class %>", :foreign_key => "updated_by"

  # TODO: destroying <%= user_plural %> should probably be disabled unless the <%= user_singular %> was created
  #       by mistake; <%= user_singular %> id's will probably be in lots of tables (like audit trails)
  #       that need to be maintained even if a <%= user_singular %>'s access to a resource is terminated

  # Authenticates a <%= user_singular %> by their login name and unencrypted password.  Returns the <%= user_singular %> or nil.
  def self.authenticate(login, password)
    u = find(:first, :conditions => ['login = ?', login], :include => :<%= group_plural %>) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the <%= user_singular %> salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def self.admin?(<%= user_singular %>)
    @@admin_<%= group_singular %> ||= <%= group_class %>.find_by_name('admin')
    @@admin_<%= group_singular %>.include?(<%= user_singular %>)
  end

  def admin?
    self.class.admin?(self)
  end

  def <%= permission_plural %>(force_reload = false)
    unless @<%= permission_plural %> && !force_reload
      g = <%= group_plural %>.find(:all, :include => :<%= permission_plural %>)
      @<%= permission_plural %> = <%= permission_class %>.find_by_sql([<<-end_of_sql, self.id])
        SELECT p.*  FROM <%= user_plural %> u
                    JOIN <%= membership_plural %> m ON u.id = m.<%= user_singular %>_id
                    JOIN <%= group_plural %> g ON g.id = m.<%= group_singular %>_id
                    JOIN <%= permission_plural %> p ON g.id = p.<%= group_singular %>_id
        WHERE u.id = ?
      end_of_sql
    end
    @<%= permission_plural %>
  end

  def controller_<%= permission_plural %>(force_reload = false)
    unless @controller_<%= permission_plural %> && !force_reload
      @controller_<%= permission_plural %> = <%= permission_class %>.find_by_sql([<<-end_of_sql, self.id])
        SELECT p.*  FROM <%= user_plural %> u
                    JOIN <%= membership_plural %> m ON u.id = m.<%= user_singular %>_id
                    JOIN <%= group_plural %> g ON g.id = m.<%= group_singular %>_id
                    JOIN <%= permission_plural %> p ON g.id = p.<%= group_singular %>_id
        WHERE u.id = ? AND p.controller IS NOT NULL
      end_of_sql
    end
    @controller_<%= permission_plural %>
  end

  def resource_<%= permission_plural %>(force_reload = false)
    unless @resource_<%= permission_plural %> && !force_reload
      @resource_<%= permission_plural %> = <%= permission_class %>.find_by_sql([<<-end_of_sql, self.id])
        SELECT p.*  FROM <%= user_plural %> u
                    JOIN <%= membership_plural %> m ON u.id = m.<%= user_singular %>_id
                    JOIN <%= group_plural %> g ON g.id = m.<%= group_singular %>_id
                    JOIN <%= permission_plural %> p ON g.id = p.<%= group_singular %>_id
        WHERE u.id = ? AND p.resource_id IS NOT NULL
      end_of_sql
    end
    @resource_<%= permission_plural %>
  end

  # Return an array of all resources that the <%= user_singular %> has the specified access to.  This
  # looks at the appropriate controller <%= permission_singular %> (if it exists) to get default <%= permission_plural %>.
  #
  # parameters:
  #   klass       - a Class
  #   access_mode - 'r', 'w', 'rw', or 'b'  (b == rw)
  def resources(klass, access_mode, force_reload = false)
    access_requirement, access_values = case access_mode.to_s
      when 'r'
        ["p.can_read = ?", [true]]
      when 'w'
        ["p.can_write = ?", [true]]
      when 'rw', 'wr', 'b'
        ["p.can_read = ? AND p.can_write = ?", [true, true]]
      else
        raise "bad access_mode"
    end

    # FIXME: don't assume the controller name is klass.table_name
    controller_name = klass.table_name
    table_name      = klass.table_name
    <%= group_singular %>_ids_sql   = "(" + <%= membership_plural %>.collect { |m| m.<%= group_singular %>_id }.join(", ") + ")"

    if self.can_access?(controller_name, access_mode)
      # this means the <%= user_singular %> has default access to the whole lot of #{klass} resources
      klass.find_by_sql([<<-end_of_sql, klass.to_s] + access_values)
        SELECT  k.* FROM #{table_name} k
                    LEFT JOIN <%= permission_plural %> p ON k.id = p.resource_id AND p.resource_type = ?
        WHERE   (p.<%= group_singular %>_id IN #{<%= group_singular %>_ids_sql} AND #{access_requirement}) OR p.id IS NULL
      end_of_sql

      # same thing using find
#      klass.find :all,
#        :joins => "LEFT JOIN <%= permission_plural %> perm ON perm.resource_id = #{table_name}.id AND perm.resource_type = '#{klass.to_s}'",
#        :conditions => ["(perm.<%= group_singular %>_id IN (#{<%= group_singular %>_ids.join(", ")}) AND #{access_requirement}) OR perm.id IS NULL"] + access_values
    else
      klass.find_by_sql([<<-end_of_sql, klass.to_s] + access_values)
        SELECT  k.* FROM #{table_name} k
                    JOIN <%= permission_plural %> p ON k.id = p.resource_id AND p.resource_type = ?
        WHERE   p.<%= group_singular %>_id IN #{<%= group_singular %>_ids_sql} AND #{access_requirement}
      end_of_sql
    end
  end

  # returns true or false depending on whether or not the <%= user_singular %> can
  # access =thing= in the manner specified by =type= ('r', 'w', or 'rw')
  #
  # parameters:
  #   thing       - a String (for controller) or ActiveRecord::Base descendant
  #   access_mode - 'r', 'w', 'rw', or 'b'  (b == rw)
  def can_access?(thing, access_mode)
    case thing
    when String, Symbol
      # controller
      # NOTE: no effort is made here to make sure the #{thing} controller exists
      perm = <%= permission_plural %>.detect { |p| p.controller == thing.to_s }
    when ActiveRecord::Base
      perm = <%= permission_plural %>.detect { |p| p.resource == thing }
    else
      raise "bad thing"
    end

    case access_mode.to_s
    when 'r'
      admin? || (perm && perm.can_read?)
    when 'w'
      admin? || (perm && perm.can_write?)
    when 'rw', 'wr', 'b'
      admin? || (perm && perm.can_read? && perm.can_write?)
    else
      raise "bad access_mode"
    end
  end
  alias :has_access_to? :can_access?

  def can_read?(thing)
    can_access?(thing, 'r')
  end
  alias :has_read_access_to? :can_read?

  def can_write?(thing)
    can_access?(thing, 'w')
  end
  alias :has_write_access_to? :can_write?

  def can_read_and_write?(thing)
    can_access?(thing, 'rw')
  end
  alias :has_read_and_write_access_to? :can_read_and_write?

  def <%= group_plural %>_not_in
    exclude_list = <%= group_plural %>.collect { |g| "id != #{quote_value(g)}" }
    exclude_sql  = exclude_list.empty? ? nil : exclude_list.join(" AND ")
    <%= group_class %>.find(:all, :conditions => exclude_sql)
  end

  protected
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
