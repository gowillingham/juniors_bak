require 'spec_helper'

describe RegistrationsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    login_user
    
    @product = Product.create(:name => 'session 1', :price => 7000)
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
      :has_release => true, 
      :product_id => @product.id
    }
    @registration = Registration.create!(@attr)
  end
  
  describe "PUT 'update'" do
    it "should require logged in user" do
      logout_user
      put :update, :id => @registration, :registration => @attr
      response.should redirect_to(new_session_path)
    end 
    
    it "should change the registration given valid attributes" do
      put :update, :id => @registration, :registration => @attr.merge(:email => 'new_email@gmail.com')
      @registration.reload.email.should eq('new_email@gmail.com')
    end 
    
    it "should not change the regisration given invalid attributes" do
      put :update, :id => @registration, :registration => @attr.merge(:email => '')
      @registration.reload.email.should eq(@attr[:email])
    end
    
    it "should change the product when passed a new product" do
      product = Product.create(:name => 'new product', :price => '70')
      put :update, :id => @registration, :registration => @attr.merge(:product_id => product.id)
      @registration.reload.product.id.should eq(product.id)
    end
    
    it "should redisplay the edit page given invalid attributes" do
      put :update, :id => @registration, :registration => @attr.merge(:email => '')
      response.should render_template('edit')
    end
    
    it "should redirect to registrations#show on success" do 
      put :update, :id => @registration, :registration => @attr.merge(:email => 'new_email@gmail.com')
      response.should redirect_to(registration_path(@registration))
    end 
  end
  
  describe "GET 'edit'" do
    it "should require logged in user" do
      logout_user
      get :edit, :id => @registration
      response.should redirect_to(new_session_path)
    end
    
    it "should display the edit form for the selected user" do
      get :edit, :id => @registration
      response.should have_selector('form', :action => registration_path(@registration))
      response.should have_selector('td input', :value => @registration.first_name)
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @registration.create_payment
    end
    
    it "should allow non-authenticated user" do
      get :show, :id => @registration
      response.should render_template('show')
    end
    
    describe "for logged in user" do
      it "should display the actions link bar" do
        get :show, :id => @registration
        response.should have_selector("a", :content => "Remove")
      end
      
      it "should display registration and payment details" do
        get :show, :id => @registration
        response.should have_selector("td", :content => "#{@registration.last_name}, #{@registration.first_name}")
        response.should have_selector("td", :content => @registration.email)
        response.should have_selector("td", :content => "Paypal")
      end      
    end
    
    describe "for the non-authenticated user" do
      before(:each) do
        logout_user
      end
      
      it "should display registration and payment details" do
        get :show, :id => @registration
        response.should have_selector("td", :content => "#{@registration.last_name}, #{@registration.first_name}")
        response.should have_selector("td", :content => @registration.email)
      end
      
      it "should not display certain registration and payment details" do
        get :show, :id => @registration
        response.should_not have_selector("td", :content => "Paypal")
      end
      
      it "should not display the admin linkbar" do
        get :show, :id => @registration
        response.should_not have_selector("a", :content => "Remove")
      end      
    end
  end
  
  describe "DELETE 'destroy'" do
    it "should require logged in user" do
      logout_user
      delete :destroy, :id => @registration
      response.should redirect_to(new_session_path)
    end
    
    it "should remove the registration" do
      lambda do
        delete :destroy, :id => @registration
      end.should change(Registration, :count).by(-1)
    end 
  end
  
  describe "GET 'index'" do
    it "should display a listing of registrations" do
      get :index
      response.should have_selector('td', :content => "#{@attr[:last_name]}, #{@attr[:first_name]}")
    end
    
    it "should require logged in user" do
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
    
    it "should redirect to payment#paypal with flash message for a valid registration" do
      post :create, :registration => @attr
      registration = Registration.find_by_email(@attr[:email])
      response.should redirect_to(paypal_registration_payment_path(assigns(:registration), assigns(:registration).payment))
    end
    
    it "should not require a logged in user" do
      logout_user
      post :create, :registration => @attr
      response.should redirect_to(paypal_registration_payment_path(assigns(:registration), assigns(:registration).payment))
    end
  end 
  
  describe "GET 'new'" do
    it "should be success" do
      get :new 
      response.should render_template('new')
    end
  end
  
  it "should not require a logged in user" do
    logout_user
    get :new
    response.should render_template('new')
  end  
end
