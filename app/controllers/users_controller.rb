class UsersController < ApplicationController
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "The person #{@user.email} was removed"
    redirect_to users_path
  end 
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      flash[:success] = "Changes to person #{@user.email} were saved"
      redirect_to users_path
    else
      render 'edit'
    end
  end 
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Added person #{@user.email} to your account"
      redirect_to users_path
    else
      render 'new'
    end
  end
  
  def index
    @users = User.all
    render 'index'
  end
end
