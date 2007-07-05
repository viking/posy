class Create<%= permission_plural_class %> < ActiveRecord::Migration
  def self.up
    create_table :<%= permission_plural %> do |t|
      t.column :<%= group_singular %>_id, :integer
      t.column :controller, :string
      t.column :resource_id, :integer
      t.column :resource_type, :string
      t.column :can_read, :boolean
      t.column :can_write, :boolean
      t.column :is_sticky, :boolean
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :integer
      t.column :updated_by, :integer
    end

    <%= user_class %>.find_by_login('admin').<%= membership_plural %>.create(:<%= group_singular %> => <%= group_class %>.find_by_name('admin'))
  end

  def self.down
    drop_table :<%= permission_plural %>
  end
end
