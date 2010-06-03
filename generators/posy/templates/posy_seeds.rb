admin_group = <%= group_class %>.create(:name => 'admin', :description => 'administration <%= group_singular %>', :permanent => true)
admin_user = <%= user_class %>.create(:login => "admin", :email => "admin@foobar.com", :password => "admin", :password_confirmation => "admin")
admin_user.<%= membership_plural %>.create(:<%= group_singular %> => admin_group)
