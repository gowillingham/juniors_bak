class PagesController < ApplicationController
  before_filter :require_login, :only => [:datatable]
  
  def calendar
    render :layout => 'application_wide'
  end
  
  def datatable
    @registrations = Registration.find(
    :all,
    :order => [:last_name, :first_name]
    )
    render :layout => 'application_popout'
  end
  
  def index
    render 'index'
  end
  
  def about
    
  end
  
  def privacy
    
  end 
  
  def contact
    
  end
end