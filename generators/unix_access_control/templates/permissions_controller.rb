class <%= permission_class %>sController < ApplicationController
  before_filter :login_required

  # GET /<%= permission_plural %>
  # GET /<%= permission_plural %>.xml
  def index
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_plural %> = @<%= group_singular %>.<%= permission_plural %>
    else
      @<%= permission_plural %> = <%= permission_class %>.find(:all)
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @<%= permission_plural %>.to_xml }
    end
  end

  # GET /<%= permission_plural %>/1
  # GET /<%= permission_plural %>/1.xml
  def show
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_singular %> = @<%= group_singular %>.<%= permission_plural %>.find(params[:id])
    else
      @<%= permission_singular %> = <%= permission_class %>.find(params[:id])
    end

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @<%= permission_singular %>.to_xml }
    end
  end

  # GET /<%= permission_plural %>/new
  def new
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_singular %> = @<%= group_singular %>.<%= permission_plural %>.build
    else
      @<%= group_plural %> = <%= group_class %>.find(:all)
      @<%= permission_singular %> = <%= permission_class %>.new
    end

    respond_to do |format|
      format.html # new.rhtml

      format.js do 
        type = params[:value] 
        case type
        when 'Controller'
          @controllers = UnixAccessControl.controllers 
        when /[A-Z]\w+/
          @resources = type.constantize.find(:all).collect { |x| [x.name, x.id] }
        end

        render :action => 'new.rjs'
      end
    end
  end

  # GET /<%= permission_plural %>/1;edit
  def edit
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_singular %> = @<%= group_singular %>.<%= permission_plural %>.find(params[:id])
    else
      @<%= permission_singular %> = <%= permission_class %>.find(params[:id])
    end
  end

  # POST /<%= permission_plural %>
  # POST /<%= permission_plural %>.xml
  def create
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_singular %> = @<%= group_singular %>.<%= permission_plural %>.build(params[:<%= permission_singular %>])
    else
      @<%= group_plural %> = <%= group_class %>.find(:all)
      @<%= permission_singular %> = <%= permission_class %>.new(params[:<%= permission_singular %>])
    end
    
    # remove resource_type if 'Controller'
    @<%= permission_singular %>.resource_type = nil   if @<%= permission_singular %>.controller

    respond_to do |format|
      if @<%= permission_singular %>.save
        flash[:notice] = '<%= permission_class %> was successfully created.'
        format.html do
          if @<%= group_singular %>
            redirect_to <%= group_singular %>_<%= permission_singular %>_url(@<%= group_singular %>, @<%= permission_singular %>)
          else
            redirect_to <%= permission_singular %>_url(@<%= permission_singular %>)
          end
        end
        format.xml  { head :created, :location => <%= permission_singular %>_url(@<%= permission_singular %>) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= permission_singular %>.errors.to_xml }
      end
    end
  end

  # PUT /<%= permission_plural %>/1
  # PUT /<%= permission_plural %>/1.xml
  def update
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_singular %> = @<%= group_singular %>.<%= permission_plural %>.find(params[:id])
    else
      @<%= permission_singular %> = <%= permission_class %>.find(params[:id])
    end

    # remove all params except read/write/sticky
    params[:<%= permission_singular %>].delete_if { |k, v| !%w{can_read can_write is_sticky}.include?(k) }

    respond_to do |format|
      if @<%= permission_singular %>.update_attributes(params[:<%= permission_singular %>])
        flash[:notice] = '<%= permission_class %> was successfully updated.'
        format.html do
          if @<%= group_singular %>
            redirect_to <%= group_singular %>_<%= permission_singular %>_url(@<%= group_singular %>, @<%= permission_singular %>)
          else
            redirect_to <%= permission_singular %>_url(@<%= permission_singular %>)
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= permission_singular %>.errors.to_xml }
      end
    end
  end

  # DELETE /<%= permission_plural %>/1
  # DELETE /<%= permission_plural %>/1.xml
  def destroy
    if params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= permission_singular %> = @<%= group_singular %>.<%= permission_plural %>.find(params[:id])
    else
      @<%= permission_singular %> = <%= permission_class %>.find(params[:id])
    end
    @<%= permission_singular %>.destroy

    respond_to do |format|
      format.html do
        if @<%= group_singular %>
          redirect_to <%= group_singular %>_<%= permission_plural %>_url(@<%= group_singular %>)
        else
          redirect_to <%= permission_plural %>_url
        end
      end
      format.xml  { head :ok }
    end
  end
end
