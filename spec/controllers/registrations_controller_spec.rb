require 'spec_helper'

describe RegistrationsController do
  render_views
  
  before(:each) do
    @user = User.create(:email => 'email@gmail.com', :password => 'p', :password_confirmation => 'p')
    login_user
    
    @attr = {
      :first_name => 'player',
      :last_name => 'name', 
      :parent_first_name => 'parent', 
      :parent_last_name => 'name',
      :grade => 3, 
      :school => 'LME',
      :email => 'player@gmail.com',
      :phone => '9524316344', 
      :address => '222 Inspiration path',
      :city => 'Lake City',
      :state => 'MN', 
      :zip => '55044',
      :parent_helper => true,
      :tshirt_size => 'YL', 
      :parent_tshirt_size => 'XL',
      :note => "Some text that I'm sending along with this message as a note. Some text that I'm sending along with this message as a note. Some text that I'm sending along with this message as a note. ",
      :session => 1,
      :has_release => true
    }
    @registration = Registration.create!(@attr)
  end
  
  describe "GET 'index'" do
    it "should display a listing of registrations" do
      get :index
      response.should have_selector('td', :content => "#{@attr[:last_name]}, #{@attr[:first_name]}")
    end
    
    it "should not allow non-authenticated user" do
      logout_user
      get :index
      response.should redirect_to(new_session_path)
    end
  end
  
  describe "POST 'create'" do
    it "it should add a valid registration" do
      lambda do
        post :create, :registration => @attr
      end.should change(Registration, :count).by(1)
    end
    
    it "should not add an invalid registration" do
      lambda do
        post :create, :registration => @attr.merge(:email => '')
      end.should change(Registration, :count).by(0)
    end
    
    it "should redirect with flash message for a valid registration" do
      post :create, :registration => @attr
      response.should redirect_to(pages_index_path)
    end
    
    it "should allow non-authenticated user" do
      logout_user
      post :create, :registration => @attr
      response.should redirect_to(pages_index_path)
    end
  end 
  
  describe "GET 'new'" do
    it "should be success" do
      get :new 
      response.should render_template('new')
    end
  end
  
  it "should allow non-authenticated user" do
    logout_user
    get :new
    response.should render_template('new')
  end  
end