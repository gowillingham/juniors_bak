class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path, :success => 'Successfully added person to account. '
    else
      render 'new'
    end
  end
  
  def index
    @users = User.all
    render 'index'
  end

end
