class RegistrationsController < ApplicationController
  before_filter :require_login, :except => [:create, :new]
  
  def index
    @registrations = Registration.find(:all)
  end
  
  def create
    @registration = Registration.new
    @registration.update_attributes(params[:registration])
    if @registration.save
      flash[:success] = 'Your registration has been saved! '
      redirect_to pages_index_url
    else
      render 'new'
    end
  end
  
  def new
    @registration = Registration.new
  end
end
