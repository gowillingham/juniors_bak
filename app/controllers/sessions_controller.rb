class SessionsController < ApplicationController
  def destroy
    logout
    flash[:success] = "Logged out!"
    redirect_to pages_index_url
  end
  
  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to pages_index_url, :notice => "Logged in!"
    else
      flash[:error] = "Your email and password did not match any account"
      redirect_to new_session_url
    end
  end

  def new
    
  end
end
