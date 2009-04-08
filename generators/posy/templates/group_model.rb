class <%= group_class %> < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :<%= membership_plural %>, :dependent => :destroy
  has_many :<%= user_plural %>, :through => :<%= membership_plural %>

  has_many :<%= permission_plural %>, :dependent => :destroy do
    def for(resource)
      case resource
      when String
        find_by_controller(resource)
      when Class
        find :all,
          :conditions => ['resource_type = ?', resource.to_s]
      else
        find :first,
          :conditions => ['resource_id = ? AND resource_type = ?', resource.id, resource.class.to_s]
      end
    end
  end
  belongs_to :creator, :class_name => "<%= user_class %>", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "<%= user_class %>", :foreign_key => "updated_by"

  # ensure the <%= group_singular %> isn't permanent
  def before_update
    raise "can't update permanent <%= group_singular %>"   if self['permanent']
  end

  # ensure the <%= group_singular %> isn't permanent
  def before_destroy
    raise "can't destroy permanent <%= group_singular %>"   if self['permanent']
  end

  def include?(<%= user_singular %>)
    unless <%= user_singular %>.is_a?(<%= user_class %>) or <%= user_singular %>.is_a?(Fixnum)
      raise TypeError, "not a <%= user_class %> or Fixnum"
    end

    <%= user_singular %>_id = <%= user_singular %>.is_a?(<%= user_class %>) ? <%= user_singular %>['id'] : <%= user_singular %>
    <%= user_plural %>.count(:conditions => ["<%= user_singular %>_id = ?", <%= user_singular %>_id]) > 0
  end

  def <%= user_plural %>_not_in
    exclude_list = <%= user_plural %>.collect { |u| "id != #{quote_value(u)}" }
    exclude_sql  = exclude_list.empty? ? nil : exclude_list.join(" AND ")
    <%= user_class %>.find(:all, :conditions => exclude_sql)
  end
end
