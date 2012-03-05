class RegistrationsController < ApplicationController
  before_filter :require_login, :except => [:create, :new]
  
  def update
    @registration = Registration.find(params[:id])
    @registration.update_attributes(params[:registration])
    if @registration.save
      flash[:success] = 'The registration was saved'
      redirect_to registration_url(@registration)
    else
      render 'edit'
    end
  end

  def edit
    @registration = Registration.find(params[:id])
  end
  
  def show
    @registration = Registration.find(params[:id])
  end
  
  def destroy
    @registration = Registration.find(params[:id]).destroy
    flash[:success] = "The registration for #{@registration.first_name} #{@registration.last_name} was removed"
    redirect_to registrations_url
  end
  
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
