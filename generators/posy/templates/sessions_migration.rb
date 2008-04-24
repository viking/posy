class Create<%= session_plural_class %> < ActiveRecord::Migration
  def self.up
    create_table :<%= session_plural %> do |t|
      t.column :<%= session_singular %>_id, :string
      t.column :data, :text
      t.column :updated_at, :datetime
    end

    add_index :<%= session_plural %>, :<%= session_singular %>_id
    add_index :<%= session_plural %>, :updated_at
  end

  def self.down
    drop_table :<%= session_plural %>
  end
end
