class <%= permission_class %> < ActiveRecord::Base
  before_validation_on_create :get_<%= group_singular %>_id_from_parent

  validates_presence_of :<%= group_singular %>_id

  # only resource_id or controller can exist, but at least one of them must exist
  validates_each :resource_id do |r, a, v|
    if v.nil?
      r.errors.add(a, 'must exist if no controller') if r.controller.nil? || r.controller.empty?

    elsif !r.controller.nil? && !r.controller.empty?
      r.errors.add(a, 'cannot exist if controller exists')

    # resource_type must exist if resource_id exists
    elsif r.resource_type.nil?
      r.errors.add(:resource_type, 'cannot be blank')

    # cannot have more than one <%= group_singular %>/resource combo
    elsif r.new_record? && r.<%= group_singular %>_id && <%= permission_class %>.count(:conditions => ["<%= group_singular %>_id = ? AND resource_type = ? and resource_id = ?", r.<%= group_singular %>_id, r.resource_type, v]) > 0
      r.errors.add(a, "already has <%= permission_plural %> for specified <%= group_singular %>")

    # don't check existing <%= permission_singular %> if updating
    elsif r.<%= group_singular %>_id && <%= permission_class %>.count(:conditions => ["<%= group_singular %>_id = ? AND resource_type = ? AND resource_id = ? AND id != ?", r.<%= group_singular %>_id, r.resource_type, v, r.id]) > 0
      r.errors.add(a, "already has <%= permission_plural %> for specified <%= group_singular %>")
    end
  end

  validates_each :controller do |r, a, v|
    if v.nil? || v.empty?
      r.errors.add(a, 'must exist if no resource_id') if r.resource_id.nil?

    elsif !r.resource_id.nil?
      r.errors.add(a, 'cannot exist if resource_id exists')

    # make sure this controller exists
    elsif !Posy.controllers.include?(v)
      r.errors.add(a, 'is not valid')

    # cannot have more than one <%= group_singular %>/controller combo
    elsif r.new_record? && r.<%= group_singular %>_id && <%= permission_class %>.count(:conditions => ["<%= group_singular %>_id = ? AND controller = ?", r.<%= group_singular %>_id, v]) > 0
      r.errors.add(a, "already has <%= permission_plural %> for specified <%= group_singular %>")

    elsif r.<%= group_singular %>_id && <%= permission_class %>.count(:conditions => ["<%= group_singular %>_id = ? AND controller = ? AND id != ?", r.<%= group_singular %>_id, v, r.id]) > 0
      r.errors.add(a, "already has <%= permission_plural %> for specified <%= group_singular %>")
    end
  end

  belongs_to :<%= group_singular %>
  belongs_to :resource, :polymorphic => true
  belongs_to :creator, :class_name => "<%= user_class %>", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "<%= user_class %>", :foreign_key => "updated_by"

  belongs_to :parent, :class_name => "<%= permission_class %>", :foreign_key => "parent_id"
  has_many :children, :class_name => "<%= permission_class %>", :foreign_key => "parent_id"

  def can_read?
    self['can_read']
  end
  
  def can_write?
    self['can_write']
  end

  def can_read_and_write?
    self['can_read'] && self['can_write']
  end

  def can_access?(access_mode)
    case access_mode.to_s
    when 'r'
      self['can_read']
    when 'w'
      self['can_write']
    when 'rw', 'wr', 'b'
      self['can_read'] && self['can_write']
    else
      raise "bad access mode"
    end 
  end

  private
    def get_<%= group_singular %>_id_from_parent
      self.<%= group_singular %>_id = parent.<%= group_singular %>_id   if parent
    end
end
