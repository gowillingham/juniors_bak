require 'spec_helper'

describe UsersController do
  
  describe "POST 'create'" do
    
    before(:each) do
      @attr = {
        :email => 'gmail@gmail.com',
        :password => 'password',
        :password_confirmation => 'password'
      }
    end
    
    it "should require a logged in user"
    
    it "should redirect to users#index" do
      post :create, :user => @attr
      response.should redirect_to users_path
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

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
  end
end
