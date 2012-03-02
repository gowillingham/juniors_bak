class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
    def not_authenticated
      redirect_to new_session_url, :alert => "First log in to view that page."
    end
end
