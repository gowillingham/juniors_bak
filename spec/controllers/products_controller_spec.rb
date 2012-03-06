require 'spec_helper'

describe ProductsController do
  render_views
  
  before(:each) do
    @user = User.create(:email => 'email@gmail.com', :password => 'p', :password_confirmation => 'p')
    login_user
    
    @attr = {
      :name => 'Session 1',
      :description => 'The description for the product', 
      :enabled => true
    }
  end
  
  describe "GET 'new'" do
    it "should require logged in user" do
      logout_user
      get :new
      response.should redirect_to(new_session_path)
    end
    
    it "should be success" do
      get :new
      response.should render_template('new')
    end
  end
end
