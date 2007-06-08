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

  # TODO: destroying <%= user_plural %> should be generally disabled unless the <%= user_singular %> was created
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
    unless @<%= permission_plural %> and !force_reload
      g = <%= group_plural %>.find(:all, :include => :<%= permission_plural %>)
      @<%= permission_plural %> = g.collect { |<%= group_singular %>| <%= group_singular %>.<%= permission_plural %> }.flatten
    end
    @<%= permission_plural %>
  end

  # TODO: add caching
  def controller_<%= permission_plural %>(force_reload = false)
    <%= permission_plural %>(force_reload).select { |p| p.controller }
  end

  # TODO: add caching
  def resource_<%= permission_plural %>(force_reload = false)
    <%= permission_plural %>(force_reload).select { |p| p.resource }
  end

  # returns true or false depending on whether or not the <%= user_singular %> can
  # access =thing= in the manner specified by =type= ('r', 'w', or 'rw')
  #
  # parameters:
  #   thing       - a String (for controller), Project, or Form
  #   access_mode - 'r', 'w', or 'rw'
  #   project_id  - required if =thing= is a Form
  def can_access?(thing, access_mode, project_id = nil)
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
    when 'rw', 'wr'
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
