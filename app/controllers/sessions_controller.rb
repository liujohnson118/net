class SessionsController < ApplicationController

  def new
    session[:user_id] = nil
    session[:admin] = nil
  end

  def create
    user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      session[:admin] = user.admin
      redirect_to '/users/'+(user.id).to_s
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:admin] = nil
    redirect_to '/login'
  end

end
