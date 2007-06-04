class <%= user_class %>sController < ApplicationController
  before_filter :login_required

  # GET /<%= user_plural %>
  # GET /<%= user_plural %>.xml
  def index
    @<%= user_plural %> = <%= user_class %>.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @<%= user_plural %>.to_xml }
    end
  end

  # GET /<%= user_plural %>/1
  # GET /<%= user_plural %>/1.xml
  def show
    @<%= user_singular %> = <%= user_class %>.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @<%= user_singular %>.to_xml }
    end
  end

  # GET /<%= user_plural %>/new
  def new
    @<%= user_singular %> = <%= user_class %>.new
  end

  # GET /<%= user_plural %>/1;edit
  def edit
    @<%= user_singular %> = <%= user_class %>.find(params[:id])
  end

  # POST /<%= user_plural %>
  # POST /<%= user_plural %>.xml
  def create
    @<%= user_singular %> = <%= user_class %>.new(params[:<%= user_singular %>])

    respond_to do |format|
      if @<%= user_singular %>.save
        flash[:notice] = '<%= user_class %> was successfully created.'
        format.html { redirect_to <%= user_singular %>_url(@<%= user_singular %>) }
        format.xml  { head :created, :location => <%= user_singular %>_url(@<%= user_singular %>) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= user_singular %>.errors.to_xml }
      end
    end
  end

  # PUT /<%= user_plural %>/1
  # PUT /<%= user_plural %>/1.xml
  def update
    @<%= user_singular %> = <%= user_class %>.find(params[:id])

    respond_to do |format|
      if @<%= user_singular %>.update_attributes(params[:<%= user_singular %>])
        flash[:notice] = '<%= user_class %> was successfully updated.'
        format.html { redirect_to <%= user_singular %>_url(@<%= user_singular %>) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= user_singular %>.errors.to_xml }
      end
    end
  end

  # DELETE /<%= user_plural %>/1
  # DELETE /<%= user_plural %>/1.xml
  def destroy
    @<%= user_singular %> = <%= user_class %>.find(params[:id])
    @<%= user_singular %>.destroy

    respond_to do |format|
      format.html { redirect_to <%= user_plural %>_url }
      format.xml  { head :ok }
    end
  end
end
