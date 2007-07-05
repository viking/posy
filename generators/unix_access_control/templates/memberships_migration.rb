class Create<%= membership_plural_class %> < ActiveRecord::Migration
  def self.up
    create_table :<%= membership_plural %> do |t|
      t.column :<%= group_singular %>_id, :integer
      t.column :<%= user_singular %>_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_by, :integer
      t.column :updated_by, :integer
    end
  end

  def self.down
    drop_table :<%= membership_plural %>
  end
end
