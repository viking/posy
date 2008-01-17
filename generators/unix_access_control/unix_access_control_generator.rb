class UnixAccessControlGenerator < Rails::Generator::Base
  default_options :skip_migration => false, :skip_in_place_modifications => false

  %w{user group membership permission session}.each do |thing|
    attr_reader "#{thing}_class", "#{thing}_plural_class", "#{thing}_singular",
                "#{thing}_plural", "#{thing}_model_file_name", "#{thing}_controller_file_name",
                "#{thing}_migrate_file_name", "#{thing}_fixture_file_name", 
                "#{thing}_helper_file_name", "#{thing}_model_spec_file_name",
                "#{thing}_controller_spec_file_name", "#{thing}_helper_spec_file_name"
  end
  
  def initialize(runtime_args, runtime_options = {})
    super

    # arguments:
    #   [user-model] [ [group-model] [ [membership-model] [ [permission-model] [session-model] ] ] ]
    #
    # gotta catch 'em all
    @model_names = {}
    @model_file_names = {}
    %w{user group membership permission session}.each_with_index do |thing, i|
      fn = args[i] || thing
      fnplural = fn.pluralize
      instance_variable_set("@#{thing}_singular", fn)
      instance_variable_set("@#{thing}_plural", fnplural)
      instance_variable_set("@#{thing}_class", fn.classify)
      instance_variable_set("@#{thing}_plural_class", fnplural.capitalize)
      instance_variable_set("@#{thing}_model_file_name", "#{fn}.rb")
      instance_variable_set("@#{thing}_controller_file_name", "#{fnplural}_controller.rb")
      instance_variable_set("@#{thing}_helper_file_name", "#{fnplural}_helper.rb")
      instance_variable_set("@#{thing}_migrate_file_name", "create_#{fnplural}")
      instance_variable_set("@#{thing}_model_spec_file_name", "#{fn}_spec.rb")
      instance_variable_set("@#{thing}_fixture_file_name", "#{fnplural}.yml")
      instance_variable_set("@#{thing}_controller_spec_file_name", "#{fnplural}_controller_spec.rb")
      instance_variable_set("@#{thing}_helper_spec_file_name", "#{fnplural}_helper_spec.rb")
    end
  end

  def manifest
    record do |m|
      m.directory File.join("app", "models")
      m.directory File.join("app", "controllers")
      m.directory File.join("app", "helpers")
      m.directory File.join("app", "views")
      m.directory File.join("app", "views", "layouts")
      m.directory File.join("app", "views", "errors")
      m.directory File.join("db", "migrate")
      m.directory File.join("test", "fixtures")
      m.directory File.join("test", "mocks", "test")
      m.directory File.join("spec", "models")
      m.directory File.join("spec", "controllers")
      m.directory File.join("spec", "helpers")
      m.directory File.join("spec", "views")
      m.directory File.join("spec", "fixtures")
      m.directory File.join("spec", "lib")
      m.directory File.join("public", "images")
      m.directory File.join("public", "stylesheets")
      m.directory "lib"
      m.directory "config"

      # model templates
      %w{user group membership permission session}.each do |thing|
        tplural = thing.pluralize

        modelfn   = instance_variable_get("@#{thing}_model_file_name") 
        ctrlfn    = instance_variable_get("@#{thing}_controller_file_name") 
        helpfn    = instance_variable_get("@#{thing}_helper_file_name") 
        migratefn = instance_variable_get("@#{thing}_migrate_file_name") 
        fixfn     = instance_variable_get("@#{thing}_fixture_file_name") 
        mspecfn   = instance_variable_get("@#{thing}_model_spec_file_name")
        cspecfn   = instance_variable_get("@#{thing}_controller_spec_file_name")
        hspecfn   = instance_variable_get("@#{thing}_helper_spec_file_name")

        m.template "#{thing}_model.rb", File.join("app", "models", modelfn) unless thing == "session"
        m.template "#{tplural}_controller.rb", File.join("app", "controllers", ctrlfn)
        unless options[:skip_migration]
          m.migration_template "#{tplural}_migration.rb", "db/migrate", :migration_file_name => migratefn
        end

        # views
        m.directory File.join("app", "views", tplural)
        m.template "#{tplural}_index.rhtml", File.join("app", "views", tplural, "index.rhtml")  unless thing == "session"
        m.template "#{tplural}_show.rhtml",  File.join("app", "views", tplural, "show.rhtml")   unless thing == "session"
        m.template "#{tplural}_edit.rhtml",  File.join("app", "views", tplural, "edit.rhtml")   unless %w{membership session}.include?(thing)
        m.template "#{tplural}_new.rhtml",   File.join("app", "views", tplural, "new.rhtml")
        m.template "#{tplural}_new.rjs",     File.join("app", "views", tplural, "new.rjs")  if thing == "permission"

        # view specs
        m.directory File.join("spec", "views", tplural)
        m.template "#{tplural}_index_view_spec.rb", File.join("spec", "views", tplural, "index_view_spec.rb")  unless thing == "session"
        m.template "#{tplural}_show_view_spec.rb",  File.join("spec", "views", tplural, "show_view_spec.rb")   unless thing == "session"
        m.template "#{tplural}_edit_view_spec.rb",  File.join("spec", "views", tplural, "edit_view_spec.rb")   unless %w{membership session}.include?(thing)
        m.template "#{tplural}_new_view_spec.rb",   File.join("spec", "views", tplural, "new_view_spec.rb")

        # helper
        m.template "#{tplural}_helper.rb", File.join("app", "helpers", helpfn)

        # helper spec
        m.template "#{tplural}_helper_spec.rb", File.join("spec", "helpers", hspecfn)

        # tests
        unless thing == "session"
          m.template "#{thing}_model_spec.rb", File.join("spec", "models", mspecfn)
          m.template "#{tplural}.yml", File.join("test", "fixtures", fixfn)
          m.template "#{tplural}.yml", File.join("spec", "fixtures", fixfn)
        end

        # controller spec
        m.template "#{tplural}_controller_spec.rb", File.join("spec", "controllers", cspecfn)
      end

      # lib templates
      m.template "authenticated_system.rb", File.join("lib", "authenticated_system.rb")
      m.template "authenticated_test_helper.rb", File.join("lib", "authenticated_test_helper.rb")
      
      # add in routes by gsub'ing config/routes.rb
      unless options[:skip_in_place_modifications]
        resources = [session_plural, permission_plural, membership_plural, user_plural, group_plural]
        resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
        m.method_missing("instance_eval") { logger.route "map.resources #{resource_list}" }  # </hack>

        sentinel = 'ActionController::Routing::Routes.draw do |map|'
        unless options[:pretend]
          m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
            <<EOF
#{match}
  map.resources :#{session_plural}, :#{permission_plural}, :#{membership_plural}
  map.resources :#{user_plural} do |#{user_singular}|
    #{user_singular}.resources :#{membership_plural}, :name_prefix => '#{user_singular}_'
  end
  map.resources :#{group_plural} do |#{group_singular}|
    #{group_singular}.resources :#{membership_plural}, :name_prefix => '#{group_singular}_'
    #{group_singular}.resources :#{permission_plural}, :name_prefix => '#{group_singular}_'
  end
EOF
          end
        end

        # modify app/controller/application.rb by gsub
        m.method_missing("instance_eval") { logger.modify "app/controllers/application.rb" }
        sentinel = "class ApplicationController < ActionController::Base"
        unless options[:pretend]
          m.gsub_file 'app/controllers/application.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
            <<EOF
#{match}
  include AuthenticatedSystem

  # userstamp filter
  # NOTE: since this sets @current_user, you'll want to use prepend_before_filter
  #       for login_required if you want HTTP authentication to work properly
  before_filter do |c|
    User.current_user = c.current_user == :false ? nil : c.current_user
  end
EOF
          end
        end
        
        # modify test/test_helper.rb by gsub
        m.method_missing("instance_eval") { logger.modify "test/test_helper.rb" }
        unless options[:pretend]
          m.gsub_file 'test/test_helper.rb', /^(end)/mi do |match|
            "  include AuthenticatedTestHelper\n#{match}"
          end
        end

        # modify app/helpers/application_helper.rb by gsub
        m.method_missing("instance_eval") { logger.modify "app/helpers/application_helper.rb" }
        sentinel = "module ApplicationHelper"
        unless options[:pretend]
          m.gsub_file 'app/helpers/application_helper.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
            <<EOF
#{match}
  def resource_name(resource)
    resource.send(UnixAccessControl.name_method_for(resource.class))
  end

  def resource_link(resource)
    case resource
    when String
      h(resource)
    when ActiveRecord::Base
      link_to("\#{resource.send(UnixAccessControl.name_method_for(resource.class))} (\#{resource.class})",
              :controller => resource.class.to_s.tableize, :action => 'show', :id => resource.id)
    else
      resource
    end
  end
EOF
          end
        end
      end

      # other
      m.template "application_helper_spec.rb", File.join("spec", "helpers", "application_helper_spec.rb")
      m.template "application_layout.rhtml", File.join("app", "views", "layouts", "application.rhtml")
      m.template "errors_denied.rhtml", File.join("app", "views", "errors", "denied.rhtml")
      m.template "access_control.yml", File.join("config", "access_control.yml")
      m.template "pocky_mock.rb", File.join("test", "mocks", "test", "pocky.rb")
      m.template "ohagi_mock.rb", File.join("test", "mocks", "test", "ohagi.rb")
      m.template "fake_model_mock.rb", File.join("test", "mocks", "test", "fake_model.rb")
      m.template "authenticated_system_spec.rb", File.join("spec", "lib", "authenticated_system_spec.rb")
      m.file "spinner.gif",  File.join("public", "images", "spinner.gif")
      m.file "scaffold.css", File.join("public", "stylesheets", "scaffold.css")
    end
  end

  protected
    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-migrations",
             "Don't generate migration files") { |v| options[:skip_migration] = v }
      opt.on("--skip-in-place-modifications",
             "Don't change files in-place") { |v| options[:skip_in_place_modifications] = v }
    end
end
