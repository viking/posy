class Create<%= group_plural_class %> < ActiveRecord::Migration
  class <%= group_class %> < ActiveRecord::Base
  end
  
  def self.up
    create_table :<%= group_plural %> do |t|
      t.column :name,        :string
      t.column :description, :string
      t.column :permanent,   :boolean, :default => false
      t.column :created_at,  :datetime
      t.column :updated_at,  :datetime
      t.column :created_by,  :integer
      t.column :updated_by,  :integer
    end
    g = <%= group_class %>.create(:name => 'admin', :description => 'administration <%= group_singular %>', :permanent => true)
  end

  def self.down
    drop_table :<%= group_plural %>
  end
end
