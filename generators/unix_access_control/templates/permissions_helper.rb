module <%= permission_plural_class %>Helper
  def link_to_index(name, html_options = nil, *parameters_for_method_reference)
    if @<%= group_singular %>
      link_to(name, <%= group_singular %>_<%= permission_plural %>_path(@<%= group_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, <%= permission_plural %>_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_new(name, html_options = nil, *parameters_for_method_reference)
    if @<%= group_singular %>
      link_to(name, <%= group_singular %>_new_<%= permission_singular %>_path(@<%= group_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, new_<%= permission_singular %>_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_show(name, <%= permission_singular %>, html_options = nil, *parameters_for_method_reference)
    if @<%= group_singular %>
      link_to(name, <%= group_singular %>_<%= permission_singular %>_path(@<%= group_singular %>, <%= permission_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, <%= permission_singular %>_path(<%= permission_singular %>), html_options, *parameters_for_method_reference)
    end
  end

  def link_to_edit(name, <%= permission_singular %>, html_options = nil, *parameters_for_method_reference)
    if @<%= group_singular %>
      link_to(name, <%= group_singular %>_edit_<%= permission_singular %>_path(@<%= group_singular %>, <%= permission_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, edit_<%= permission_singular %>_path(<%= permission_singular %>), html_options, *parameters_for_method_reference)
    end
  end

  def link_to_destroy(name, <%= permission_singular %>, html_options = {}, *parameters_for_method_reference)
    html_options = html_options.merge(:method => :delete)

    if @<%= group_singular %>
      link_to(name, <%= group_singular %>_<%= permission_singular %>_path(@<%= group_singular %>, <%= permission_singular %>), html_options, *parameters_for_method_reference)
    else
      link_to(name, <%= permission_singular %>_path(<%= permission_singular %>), html_options, *parameters_for_method_reference)
    end
  end

  def url_for_create
    if @<%= group_singular %>
      <%= group_singular %>_<%= permission_plural %>_path(@<%= group_singular %>)
    else
      <%= permission_plural %>_path
    end
  end

  def url_for_update(<%= permission_singular %>)
    if @<%= group_singular %>
      <%= group_singular %>_<%= permission_singular %>_path(@<%= group_singular %>, <%= permission_singular %>)
    else
      <%= permission_singular %>_path(<%= permission_singular %>)
    end
  end
end
