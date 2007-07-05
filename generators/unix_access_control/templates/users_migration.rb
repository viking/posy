class Create<%= user_plural_class %> < ActiveRecord::Migration
  def self.up
    create_table "<%= user_plural %>", :force => true do |t|
      t.column :login,             :string
      t.column :email,             :string
      t.column :crypted_password,  :string, :limit => 40
      t.column :salt,              :string, :limit => 40
      t.column :created_at,        :datetime
      t.column :updated_at,        :datetime
      t.column :accessed_at,       :datetime
      t.column :created_by,        :integer
      t.column :updated_by,        :integer
      t.column :deleted,           :boolean, :default => false
    end

    <%= user_class %>.create(:login => "admin", :email => "admin@foobar.com", :password => "admin", :password_confirmation => "admin")
  end

  def self.down
    drop_table "<%= user_plural %>"
  end
end
