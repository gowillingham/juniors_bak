class PagesController < ApplicationController
  before_filter :require_login, :only => [:datatable]
  
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