# This controller handles the login/logout function of the site.  
class <%= session_plural_class %>Controller < ApplicationController
  skip_before_filter :login_required

  # render new.rhtml
  def new
  end

  def create
    self.current_<%= user_singular %> = <%= user_class %>.authenticate(params[:login], params[:password])
    if logged_in?
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    reset_<%= session_singular %>
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
