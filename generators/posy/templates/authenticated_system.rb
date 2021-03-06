module AuthenticatedSystem
  DEFAULT_ACTION_PERMISSIONS = HashWithIndifferentAccess.new({
    'r' => %w{index show},
    'w' => %w{new create update destroy},
    'b' => %w{edit},
    't' => %w{edit update destroy}
  })

  # Actions that are affected by resource <%= permission_plural %>.
  DEFAULT_RESOURCE_ACTIONS = %w{show edit update destroy}

  # Actions that are affected when a <%= permission_singular %> is sticky.
  DEFAULT_STICKY_ACTIONS   = %w{edit update destroy}

  module ClassMethods
    # You can use this method to either get or set the action_<%= permission_plural %> inheritable
    # attribute.  You'll probably want to use chmod instead of setting this manually.
    #
    def action_<%= permission_plural %>(hsh = nil)
      return read_inheritable_attribute(:action_<%= permission_plural %>)  if hsh.nil?
      write_inheritable_hash(:action_<%= permission_plural %>, hsh)
    end

    # You can use this method to get or add additional actions which should look for resource
    # <%= permission_plural %> prior to looking for controller <%= permission_plural %>.  The default actions are:
    # show, edit, update, destroy.
    #
    def resource_actions(*actions)
      return read_inheritable_attribute(:resource_actions)    if actions.empty?
      write_inheritable_array(:resource_actions, actions.collect { |a| a.to_s })
    end

    # Use this method to remove actions from the list of actions that should look for
    # resource <%= permission_plural %>.
    #
    def remove_resource_actions(*actions)
      write_inheritable_attribute(:resource_actions, read_inheritable_attribute(:resource_actions) - actions.collect { |a| a.to_s })
    end

    # You can use this method to get or add additional actions that are affected by sticky
    # <%= permission_plural %>.  The default actions are: edit, update, destroy.
    #
    # NOTE: It doesn't make sense to have an action in sticky_actions that also isn't in
    #       resource_actions, because access will always be denied (since authorized? will
    #       check for current_resource, which would be nil for a non-resource action).
    #
    def sticky_actions(*actions)
      return read_inheritable_attribute(:sticky_actions)    if actions.empty?
      write_inheritable_array(:sticky_actions, actions.collect { |a| a.to_s })
    end

    # Use this method to remove actions from the list of actions that are affected by
    # sticky <%= permission_plural %>.
    #
    def remove_sticky_actions(*actions)
      write_inheritable_attribute(:sticky_actions, read_inheritable_attribute(:sticky_actions) - actions.collect { |a| a.to_s })
    end

    # Use this to get or set the model name that I should use to look for resource <%= permission_plural %>.
    # By default, this is the singular of the controller name.
    #
    def resource_model_name(name = nil)
      # NOTE: using instance variable instead of class variable here
      if name
        @resource_model_name = name.to_s.classify
      end
      @resource_model_name ||= controller_name.singularize.classify
    end

    # Specify options for parent/child <%= permission_singular %> relationships.  You must set this
    # if you want a controller to look for parent <%= permission_plural %>.  This should be a list of
    # arrays of controller names like so:
    #
    # access_hierarchies [:cats, :dogs, :ferrets], [:dogs, :cats]
    #
    # Using the above example, if you surfed to the following url:
    #   /cats/1/dogs/2/ferrets
    #
    # I would first look for the resource <%= permission_singular %> for cat 1.  If that didn't exist,
    # I would look for the controller <%= permission_singular %> for cats.  Next, I'd look for the resource
    # <%= permission_singular %> for dog 2 where the first <%= permission_singular %> is the parent, and so on.  If at
    # any point in the chain no <%= permission_singular %> can be found, it goes to the next array in the
    # access hierarchy list.  This way, precedence is established.
    #
    # NOTE: It is up to you to make sure the controllers are in the correct order.  The
    # authorization method is not smart enough to figure out the correct order via the
    # url.  For example, if your hierarchy is set up like this,
    #   access_hierarchies [:cats, :dogs]
    #
    # and you went to /dogs/1/cats/1, it would first look for the cat <%= permission_singular %> BEFORE
    # the dog <%= permission_singular %>.
    #
    def access_hierarchies(*args)
      return read_inheritable_attribute(:access_hierarchies)  if args.empty?
      args.collect! { |a| a.collect { |b| b.to_s } }
      write_inheritable_attribute(:access_hierarchies, args)
    end

    # Use this method to set what <%= permission_plural %> are needed to perform what actions.
    # You can also override default <%= permission_plural %>.
    #
    # NOTE: This isn't exactly like its unix counterpart.  Since an action can
    #       require that a <%= user_singular %> have both read AND write privileges to access
    #       it, "+rw" is different than "+b" ('b' is the letter used for
    #       both read and write access).  So if you wanted to make an action
    #       only accessible by read AND write <%= user_plural %>, do "-rw+b" (or just "b").
    #       If you don't have a '+' or '-', the <%= permission_singular %> is just set to whatever
    #       you specify.
    #
    # Examples:
    #   chmod "+r", :foo
    #   chmod "+rw", :bar, :baz
    #   chmod "-r", :index
    #   chmod "b", :update
    #
    def chmod(<%= permission_singular %>, *actions)
      # parse <%= permission_singular %> string
      perms = { 'add' => [], 'del' => [], 'set' => [] }
      mode  = "set"
      <%= permission_singular %>.split(//).each do |p|
        case p
        when '+'
          mode = "add"
        when '-'
          mode = "del"
        when 'r', 'w', 'b'
          perms[mode] << p
        else
          raise "bad <%= permission_singular %> string: '#{<%= permission_singular %>}'"
        end
      end

      # NOTE: if a "set" exists, the others are ignored
      unless perms["set"].empty?
        perms["add"] = []
        perms["del"] = []
        %w{r w b}.each do |x|
          if perms["set"].include?(x)
            perms["add"] << x
          else
            perms["del"] << x
          end
        end
      end

      hsh = action_<%= permission_plural %>.dup
      actions = actions.collect { |a| a.to_s }
      perms["add"].each do |p|
        hsh[p] |= actions
      end
      perms["del"].each do |p|
        hsh[p] -= actions
      end
      write_inheritable_hash(:action_<%= permission_plural %>, hsh)
    end
  end

  def action_<%= permission_plural %>(hsh = nil)
    self.class.action_<%= permission_plural %>(hsh)
  end

  def resource_actions(*actions)
    self.class.resource_actions(*actions)
  end

  def remove_resource_actions(*actions)
    self.class.remove_resource_actions(*actions)
  end

  def sticky_actions(*actions)
    self.class.sticky_actions(*actions)
  end

  def remove_sticky_actions(*actions)
    self.class.remove_sticky_actions(*actions)
  end

  def resource_model_name(name = nil)
    self.class.resource_model_name(name)
  end

  def access_hierarchies(*args)
    self.class.access_hierarchies(*args)
  end

  # Accesses the current <%= user_singular %> from the <%= session_singular %>.
  # NOTE: this is public so that the <%= user_plural %>tamp filter can access it
  def current_<%= user_singular %>
    @current_<%= user_singular %> ||= (<%= session_singular %>[:<%= user_singular %>] && <%= user_class %>.find_by_id(<%= session_singular %>[:<%= user_singular %>])) || :false
  end

  protected
    def current_resource
      unless defined? @current_resource
        unless params[:id]
          @current_resource = nil
          return @current_resource
        end

        begin
          model = resource_model_name.constantize
          @current_resource = model.find_by_id(params[:id]) # returns nil if not found
        rescue NameError => boom
          logger.error boom
          raise NameError, "resource_model_name is bad; please use the resource_model_name method to set the correct model name"
        end
      end
      @current_resource
    end

    # This will grab the associated <%= permission_singular %> for the selected action.  Access hierarchies
    # take highest precedence.  Next, if params[:id] exists, it will try to grab the
    # <%= permission_singular %> for the associated resource.  Finally, if that doesn't exist it will try to
    # get the <%= permission_singular %> for the associated controller.
    #
    # You can use the following methods to tweak how this works:
    #   resource_actions:        use to add additional actions that use resources
    #   remove_resource_actions: use to remove actions that use resources
    #   resource_model_name:     use to change the model name of the resource
    #   access_hierarchies:      for nested <%= permission_plural %>
    #
    def current_<%= permission_singular %>
      unless defined? @current_<%= permission_singular %>
        if current_<%= user_singular %> == :false
          @current_<%= permission_singular %> = nil
          return @current_<%= permission_singular %>
        end
        perms = current_<%= user_singular %>.<%= permission_plural %>

        # try access hierarchies first!
        parent = nil
        access_hierarchies.each do |arr|
          arr.each do |controller|
            id = params["#{controller.singularize}_id"]
            next  unless id
            type = "#{controller}_controller".classify.constantize.resource_model_name

            # try to find parent resource <%= permission_singular %> first; then controller <%= permission_singular %>
            perm   = perms.detect { |p| p.resource_id == id.to_i && p.resource_type == type && p.parent == parent }
            perm ||= perms.detect { |p| p.controller == controller && p.parent == parent }
            parent = perm

            break unless parent
          end
          break if parent
        end

        # grab the current resource <%= permission_singular %>
        if resource_actions.include?(action_name) && !current_resource.nil?
          @current_<%= permission_singular %> = perms.detect { |p| p.resource == current_resource && p.parent == parent }
        end
        @current_<%= permission_singular %> ||= perms.detect { |p| p.controller == controller_name && p.parent == parent }
      end
      @current_<%= permission_singular %>
    end

    def <%= user_singular %>_can_read?
      current_<%= permission_singular %> ? current_<%= permission_singular %>.can_read : false
    end

    def <%= user_singular %>_can_write?
      current_<%= permission_singular %> ? current_<%= permission_singular %>.can_write : false
    end

    def <%= user_singular %>_can_read_and_write?
      current_<%= permission_singular %> ? current_<%= permission_singular %>.can_read && current_<%= permission_singular %>.can_write : false
    end

    def <%= permission_singular %>_is_sticky?
      current_<%= permission_singular %> ? current_<%= permission_singular %>.is_sticky : false
    end

    # Returns true or false if the <%= user_singular %> is logged in.
    # Preloads @current_<%= user_singular %> with the <%= user_singular %> model if they're logged in.
    def logged_in?
      current_<%= user_singular %> != :false
    end

    # Store the given <%= user_singular %> in the <%= session_singular %>.
    def current_<%= user_singular %>=(new_<%= user_singular %>)
      <%= session_singular %>[:<%= user_singular %>] = (new_<%= user_singular %>.nil? || new_<%= user_singular %>.is_a?(Symbol)) ? nil : new_<%= user_singular %>.id
      @current_<%= user_singular %> = new_<%= user_singular %>
    end

    # Check if the <%= user_singular %> is authorized.  You can specify one-time <%= permission_plural %> via:
    #     flash[:allow] = true
    #
    # See the DEFAULT_ACTION_PERMISSIONS constant for default behavior.
    #
    # About sticky <%= permission_plural %>:
    #   If preliminary access is granted for the <%= user_singular %>, sticky_actions is checked to see
    #   whether or not the requested action is affected by sticky <%= permission_plural %>.  If it is,
    #   then current_<%= permission_singular %> is first checked, and then current_resource is tested to
    #   see if the <%= user_singular %> is the creator.
    #
    #   See the DEFAULT_STICKY_ACTIONS constant for the default list of actions that are
    #   affected by stickiness.
    #
    # NOTE: controllers with additional actions should specify what <%= permission_singular %> is required
    #       to access those actions by using =chmod=; actions not specified are denied by default.
    #
    # NOTE: this method gets run AFTER logged_in?, so assume the <%= user_singular %> is logged in
    def authorized?
      return true   if controller_name == '<%= session_plural %>'
      return true   if current_<%= user_singular %>.admin? || flash[:allow]
      return false  unless current_<%= permission_singular %>

      ap     = action_<%= permission_plural %>
      bools  = []
      bools << <%= user_singular %>_can_read?             if ap['r'].include?(action_name)
      bools << <%= user_singular %>_can_write?            if ap['w'].include?(action_name)
      bools << <%= user_singular %>_can_read_and_write?   if ap['b'].include?(action_name)
      if bools.any?
        # handle sticky <%= permission_plural %>
        if sticky_actions.include?(action_name) && <%= permission_singular %>_is_sticky?
          # make sure the <%= user_singular %> is the owner
          current_resource ? current_resource.created_by == current_<%= user_singular %>.id : false
        else
          true
        end
      else
        false
      end
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      unless @current_<%= user_singular %>
        <%= user_singular %>name, passwd = get_auth_data
        self.current_<%= user_singular %> = <%= user_class %>.authenticate(<%= user_singular %>name, passwd) || :false if <%= user_singular %>name && passwd
      end
      logged_in? && authorized? ? true : access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the <%= user_singular %> is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |accepts|
        accepts.html do
          if logged_in?
            render :template => 'errors/denied', :status => :unauthorized
          else
            store_location
            redirect_to :controller => '<%= session_plural %>', :action => 'new'
          end
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Couldn't authenticate you", :status => :unauthorized
        end
      end
      false
    end

    # Store the URI of the current request in the <%= session_singular %>.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      <%= session_singular %>[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      <%= session_singular %>[:return_to] ? redirect_to_url(<%= session_singular %>[:return_to]) : redirect_to(default)
      <%= session_singular %>[:return_to] = nil
    end

    # Inclusion hook to make a few methods available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_<%= user_singular %>, :logged_in?, :current_<%= permission_singular %>,
                :<%= user_singular %>_can_read?, :<%= user_singular %>_can_write?, :<%= user_singular %>_can_read_and_write?

      # inheritable variables for authentication
      base.extend(ClassMethods)

      # default action_<%= permission_plural %> hash
      unless base.inheritable_attributes[:action_<%= permission_plural %>]
        base.write_inheritable_attribute(:action_<%= permission_plural %>, DEFAULT_ACTION_PERMISSIONS.dup)
      end

      # default resource_actions array
      unless base.inheritable_attributes[:resource_actions]
        base.write_inheritable_attribute(:resource_actions, DEFAULT_RESOURCE_ACTIONS.dup)
      end

      # default sticky_actions array
      unless base.inheritable_attributes[:sticky_actions]
        base.write_inheritable_attribute(:sticky_actions, DEFAULT_STICKY_ACTIONS.dup)
      end

      unless base.inheritable_attributes[:access_hierarchies]
        base.write_inheritable_attribute(:access_hierarchies, [])
      end
    end

  private
    @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil]
    end
end
