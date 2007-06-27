class <%= membership_class %>sController < ApplicationController
  prepend_before_filter :login_required

  # GET /<%= membership_plural %>
  # GET /<%= membership_plural %>.xml
  def index
    if params[:<%= user_singular %>_id]
      @<%= user_singular %> = <%= user_class %>.find(params[:<%= user_singular %>_id])
      @<%= membership_plural %> = @<%= user_singular %>.<%= membership_plural %>
    elsif params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= membership_plural %> = @<%= group_singular %>.<%= membership_plural %>
    else
      @<%= membership_plural %> = <%= membership_class %>.find(:all)
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @<%= membership_plural %>.to_xml }
    end
  end

  # GET /<%= membership_plural %>/1
  # GET /<%= membership_plural %>/1.xml
  def show
    if params[:<%= user_singular %>_id]
      @<%= user_singular %> = <%= user_class %>.find(params[:<%= user_singular %>_id])
      @<%= membership_singular %> = @<%= user_singular %>.<%= membership_plural %>.find(params[:id])
    elsif params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= membership_singular %> = @<%= group_singular %>.<%= membership_plural %>.find(params[:id])
    else
      @<%= membership_singular %> = <%= membership_class %>.find(params[:id])
    end

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @<%= membership_singular %>.to_xml }
    end
  end

  # GET /<%= membership_plural %>/new
  def new
    if params[:<%= user_singular %>_id]
      @<%= user_singular %> = <%= user_class %>.find(params[:<%= user_singular %>_id])
      @<%= membership_singular %> = @<%= user_singular %>.<%= membership_plural %>.build
      @<%= group_plural %> = <%= group_class %>.find(:all)
    elsif params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= membership_singular %> = @<%= group_singular %>.<%= membership_plural %>.build
      @<%= user_plural %> = <%= user_class %>.find(:all)
    else
      @<%= membership_singular %> = <%= membership_class %>.new
      @<%= user_plural %> = <%= user_class %>.find(:all)
      @<%= group_plural %> = <%= group_class %>.find(:all)
    end
  end

  # POST /<%= membership_plural %>
  # POST /<%= membership_plural %>.xml
  def create
    if params[:<%= user_singular %>_id]
      @<%= user_singular %> = <%= user_class %>.find(params[:<%= user_singular %>_id])
      @<%= membership_singular %> = @<%= user_singular %>.<%= membership_plural %>.build(params[:<%= membership_singular %>])
      @<%= group_plural %> = <%= group_class %>.find(:all)
    elsif params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= membership_singular %> = @<%= group_singular %>.<%= membership_plural %>.build(params[:<%= membership_singular %>])
      @<%= user_plural %> = <%= user_class %>.find(:all)
    else
      @<%= membership_singular %> = <%= membership_class %>.new(params[:<%= membership_singular %>])
      @<%= user_plural %> = <%= user_class %>.find(:all)
      @<%= group_plural %> = <%= group_class %>.find(:all)
    end

    respond_to do |format|
      if @<%= membership_singular %>.save
        flash[:notice] = '<%= membership_class %> was successfully created.'
        format.html do 
          if @<%= user_singular %>
            redirect_to <%= user_singular %>_<%= membership_singular %>_url(@<%= user_singular %>, @<%= membership_singular %>)
          elsif @<%= group_singular %>
            redirect_to <%= group_singular %>_<%= membership_singular %>_url(@<%= group_singular %>, @<%= membership_singular %>)
          else
            redirect_to <%= membership_singular %>_url(@<%= membership_singular %>)
          end
        end
        format.xml  { head :created, :location => <%= membership_singular %>_url(@<%= membership_singular %>) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= membership_singular %>.errors.to_xml }
      end
    end
  end

  # DELETE /<%= membership_plural %>/1
  # DELETE /<%= membership_plural %>/1.xml
  def destroy
    if params[:<%= user_singular %>_id]
      @<%= user_singular %> = <%= user_class %>.find(params[:<%= user_singular %>_id])
      @<%= membership_singular %> = @<%= user_singular %>.<%= membership_plural %>.find(params[:id])
    elsif params[:<%= group_singular %>_id]
      @<%= group_singular %> = <%= group_class %>.find(params[:<%= group_singular %>_id])
      @<%= membership_singular %> = @<%= group_singular %>.<%= membership_plural %>.find(params[:id])
    else
      @<%= membership_singular %> = <%= membership_class %>.find(params[:id])
    end
    @<%= membership_singular %>.destroy

    respond_to do |format|
      format.html do 
        if @<%= user_singular %>
          redirect_to <%= user_singular %>_<%= membership_plural %>_url(@<%= user_singular %>)
        elsif @<%= group_singular %>
          redirect_to <%= group_singular %>_<%= membership_plural %>_url(@<%= group_singular %>)
        else
          redirect_to <%= membership_plural %>_url
        end
      end
      format.xml  { head :ok }
    end
  end
end
