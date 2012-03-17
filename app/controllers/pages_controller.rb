class PagesController < ApplicationController
  before_filter :require_login, :only => [:datatable]
  
  def calendar
    render :layout => 'application_wide'
  end
  
  def datatable
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