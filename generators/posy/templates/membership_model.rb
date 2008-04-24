class <%= membership_class %> < ActiveRecord::Base
  validates_presence_of   :<%= user_singular %>_id, :<%= group_singular %>_id
  validates_uniqueness_of :<%= group_singular %>_id, :scope => :<%= user_singular %>_id

  # <%= user_plural %> can only belong in one <%= group_singular %> per <%= permission_singular %>
  # i.e. billy can't be in one <%= group_singular %> with read-only <%= permission_plural %> on
  #      project 'foo' and be in another <%= group_singular %> with read/write
  #      <%= permission_plural %> on the same project
  validate :unique_<%= permission_plural %>

  belongs_to :<%= group_singular %>
  belongs_to :<%= user_singular %>
  belongs_to :creator, :class_name => "<%= user_class %>", :foreign_key => "created_by"
  belongs_to :updater, :class_name => "<%= user_class %>", :foreign_key => "updated_by"

  protected
    def unique_<%= permission_plural %>
      return  unless <%= user_singular %>_id and <%= group_singular %>_id

      # get a list of all resources for the specified <%= group_singular %>
      resources = <%= group_singular %>.<%= permission_plural %>.collect do |perm|
        perm.resource ? "#{perm.resource_type}_#{perm.resource_id}" : perm.controller
      end

      # for all the <%= group_plural %> this <%= user_singular %> belongs in, see if there are any duplicate resources
      duplicates = Hash.new { |h,k| h[k] = [] }
      <%= user_singular %>.<%= group_plural %>.find(:all, :conditions => ['<%= group_singular %>_id != ?', <%= group_singular %>_id]).each do |g|
        g.<%= permission_plural %>.each do |perm|
          tmp = perm.resource ? "#{perm.resource_type}_#{perm.resource_id}" : perm.controller
          duplicates[g.name] << tmp   if resources.include?(tmp)
        end
      end

      if duplicates.keys.length > 0
        errors.add(:<%= group_singular %>_id, "cannot be used because it has overlapping <%= permission_plural %> with the <%= user_singular %>'s current <%= group_plural %>")
      end
    end
end
