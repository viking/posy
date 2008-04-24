module <%= membership_plural_class %>Helper
  def link_to_index(name, html_options = nil, *parameters_for_method_reference)
    if @<%= user_singular %>
      link_to(name, <%= user_singular %>_<%= membership_plural %>_path(@<%= user_singular %>), html_options, *parameters_for_method_reference)
    elsif @<%= group_singular %>
      link_to(name, <%= group_singular %>_<%= membership_plural %>_path(@<%= group_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, <%= membership_plural %>_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_new(name, html_options = nil, *parameters_for_method_reference)
    if @<%= user_singular %>
      link_to(name, new_<%= user_singular %>_<%= membership_singular %>_path(@<%= user_singular %>), html_options, *parameters_for_method_reference)
    elsif @<%= group_singular %>
      link_to(name, new_<%= group_singular %>_<%= membership_singular %>_path(@<%= group_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, new_<%= membership_singular %>_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_show(name, <%= membership_singular %>, html_options = nil, *parameters_for_method_reference)
    if @<%= user_singular %>
      link_to(name, <%= user_singular %>_<%= membership_singular %>_path(@<%= user_singular %>, <%= membership_singular %>), html_options, *parameters_for_method_reference)
    elsif @<%= group_singular %>
      link_to(name, <%= group_singular %>_<%= membership_singular %>_path(@<%= group_singular %>, <%= membership_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, <%= membership_singular %>_path(<%= membership_singular %>), html_options, *parameters_for_method_reference)
    end
  end

  def link_to_destroy(name, <%= membership_singular %>, html_options = {}, *parameters_for_method_reference)
    html_options = html_options.merge(:method => :delete)

    if @<%= user_singular %>
      link_to(name, <%= user_singular %>_<%= membership_singular %>_path(@<%= user_singular %>, <%= membership_singular %>), html_options, *parameters_for_method_reference)
    elsif @<%= group_singular %>
      link_to(name, <%= group_singular %>_<%= membership_singular %>_path(@<%= group_singular %>, <%= membership_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, <%= membership_singular %>_path(<%= membership_singular %>), html_options, *parameters_for_method_reference)
    end
  end

  def url_for_create
    if @<%= user_singular %>
      <%= user_singular %>_<%= membership_plural %>_path(@<%= user_singular %>)
    elsif @<%= group_singular %>
      <%= group_singular %>_<%= membership_plural %>_path(@<%= group_singular %>)
    else
      <%= membership_plural %>_path
    end
  end
end
