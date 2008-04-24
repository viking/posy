class <%= group_plural_class %>Controller < ApplicationController
  prepend_before_filter :login_required

  # GET /<%= group_plural %>
  # GET /<%= group_plural %>.xml
  def index
    @<%= group_plural %> = <%= group_class %>.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @<%= group_plural %>.to_xml }
    end
  end

  # GET /<%= group_plural %>/1
  # GET /<%= group_plural %>/1.xml
  def show
    @<%= group_singular %> = <%= group_class %>.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @<%= group_singular %>.to_xml }
    end
  end

  # GET /<%= group_plural %>/new
  def new
    @<%= group_singular %> = <%= group_class %>.new
  end

  # GET /<%= group_plural %>/1;edit
  def edit
    @<%= group_singular %> = <%= group_class %>.find(params[:id])
  end

  # POST /<%= group_plural %>
  # POST /<%= group_plural %>.xml
  def create
    @<%= group_singular %> = <%= group_class %>.new(params[:<%= group_singular %>])

    respond_to do |format|
      if @<%= group_singular %>.save
        flash[:notice] = '<%= group_class %> was successfully created.'
        format.html { redirect_to <%= group_singular %>_url(@<%= group_singular %>) }
        format.xml  { head :created, :location => <%= group_singular %>_url(@<%= group_singular %>) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= group_singular %>.errors.to_xml }
      end
    end
  end

  # PUT /<%= group_plural %>/1
  # PUT /<%= group_plural %>/1.xml
  def update
    @<%= group_singular %> = <%= group_class %>.find(params[:id])

    respond_to do |format|
      if @<%= group_singular %>.update_attributes(params[:<%= group_singular %>])
        flash[:notice] = '<%= group_class %> was successfully updated.'
        format.html { redirect_to <%= group_singular %>_url(@<%= group_singular %>) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= group_singular %>.errors.to_xml }
      end
    end
  end

  # DELETE /<%= group_plural %>/1
  # DELETE /<%= group_plural %>/1.xml
  def destroy
    @<%= group_singular %> = <%= group_class %>.find(params[:id])
    @<%= group_singular %>.destroy

    respond_to do |format|
      format.html { redirect_to <%= group_plural %>_url }
      format.xml  { head :ok }
    end
  end
end
