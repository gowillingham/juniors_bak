require 'spec_helper'

describe SessionsController do
  
  describe "POST 'create'" do
    before(:each) do
      @user = User.create!(:email => 'email@gmail.com', :password => 'password', :password_confirmation => 'password')
    end
    it "should login a valid user" do
      post :create, :email => @user.email, :password => 'password'
      controller.should be_logged_in
    end
    
    it "should redirect a logged in user to home" do
      post :create, :email => @user.email, :password => 'password'
      response.should redirect_to(pages_index_path)      
    end
    
    it "should not login an invalid user" do
      post :create, :email => @user.email, :password => 'not_the_password'
      controller.should_not be_logged_in
      response.should redirect_to(new_session_path)
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
