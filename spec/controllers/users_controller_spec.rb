require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @user = User.create(
      :email => 'email@email.com',
      :password => 'password',
      :confirm_password => 'password'
    )
    login_user(@user)
    
    @attr = {
      :email => 'gmail@gmail.com',
      :password => 'password',
      :password_confirmation => 'password'
    }
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = User.create!(@attr) 
    end
    
    it "should require a logged in user" do
      logout_user
      delete :destroy, :id => @user
      response.should redirect_to(new_session_path)
    end
    
    it "should remove the user" do
      lambda do
        delete :destroy, :id => @user
      end.should change(User, :count).by(-1)
    end 
    
    it "should redirect and display flash to users#index" do
      delete :destroy, :id => @user
      response.should redirect_to(users_path)
      flash[:success].should =~ /removed/i
    end 
  end 
  
  describe "PUT 'update'" do
    before(:each) do
      @user = User.create!(@attr) 
    end
        
    it "should require a logged in user" do
      logout_user
      put :update, :id => @user, :user => @user
      response.should redirect_to(new_session_path)
    end
    
    it "should redirect and display flash to users#index" do
      @user.email = 'new_email.gmail.com'
      put :update, :id => @user, :user => @user
      response.should redirect_to(users_path)
      flash[:success].should =~ /changes/i    
    end 
    
    it "should change a user with valid attributes" do
      put :update, :id => @user, :user => @attr.merge(:email => 'new_email.gmail.com')
      User.find(@user.id).email.should eq('new_email.gmail.com')
    end
  end 
  
  describe "GET 'edit'" do
    before(:each) do
      @user = User.create!(@attr)
    end 
    
    it "should be successful" do
      get :edit, :id => @user, :user => @attr
      response.should be_success
    end 
  end

  describe "POST 'create'" do
    
    it "should require a logged in user" do
      logout_user
      post :create, :user => @attr
      response.should redirect_to(new_session_path)
    end
    
    it "should redirect to users#index" do
      post :create, :user => @attr
      response.should redirect_to users_path
      flash[:success].should =~ /Added/i
    end
    
    it "should add a valid user" do
      lambda do
        post :create, :user => @attr
      end.should change(User, :count).by(1)
    end
    
    it "should not add an invalid user" do
      lambda do
        post :create, :user => @attr.merge(:password_confirmation => '')
      end.should change(User, :count).by(0)
    end
  end
  
  describe "GET 'index'" do
    it "should require a logged in user" do
      logout_user
      get :index
      response.should redirect_to(new_session_path)
    end
    
    it "should display a listing of members" do
      get :index
      response.should have_selector('td', :content => @user.email)
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should require a logged in user" do
      logout_user
      get :new
      response.should redirect_to(new_session_path)
    end
    
    it "should be successful" do
      get :new
      response.should be_success
    end
  end
end
