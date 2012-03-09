require 'spec_helper'

describe PaymentsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    login_user @user
    
    @registration = Factory(:registration)
    @attr = {
      :paypal_txn_id => 'txn_id',
      :paypal_sandbox => false,
      :paypal_payment_status => 'completed',
      :paypal_pending_status_reason => 'echeck',
      :amount => 70,
      :online => false,
      :scholarship => false
    }
  end
  
  describe "GET 'paypal'" do
    before(:each) do
      @payment = Payment.create(@attr.merge(:registration_id => @registration.id))
    end

    it "should allow non-authenticated user" do
      logout_user
      get :paypal, :registration_id => @registration, :id => @payment
      response.should render_template('paypal')
    end
    
    it "should display paypal form" do
      get :paypal, :registration_id => @registration, :id => @payment
      response.should have_selector('form', :action => 'https://www.sandbox.paypal.com/cgi-bin/webscr')
    end 
    
    it "should display the registration summary" do
      get :paypal, :registration_id => @registration, :id => @payment
      response.should have_selector('td', :content => @registration.last_name)
      response.should have_selector('td', :content => @registration.first_name)
      response.should have_selector('td', :content => @registration.product.name)
      response.should have_selector('td', :content => @registration.product.price.to_s)
    end 
    
    it "should redirect to registration#show with message if this payment is already paid"
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @payment = Payment.create(@attr.merge(:registration_id => @registration.id))
    end

    it "should require logged in user" do
      logout_user
      put :update, :registration_id => @registration, :id => @payment, :payment => @attr
      response.should redirect_to(new_session_path)
    end
    
    it "should redirect to registrations#index" do
      put :update, :registration_id => @registration, :id => @payment, :payment => @attr
      response.should redirect_to(registrations_path)
      flash[:success].should =~ /saved/i
    end
      
    it "should change the payment given valid attributes" do
      put :update, :registration_id => @registration, :id => @payment, :payment => @attr.merge(:amount => 100)
      @payment.reload.amount.should eq(100)
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @payment = Payment.create(@attr.merge(:registration_id => @registration.id))
    end
    
    it "should require logged in user" do
      logout_user
      get :edit, :registration_id => @registration, :id => @payment, :payment => @attr
      response.should redirect_to(new_session_path)
    end

    it "should be success" do
      get :edit, :registration_id => @registration, :id => @payment, :payment => @attr
      response.should render_template('edit')
    end
  end
  
  describe "POST 'create'" do
    it "should require logged in user" do
      logout_user
      post :create, :registration_id => @registration, :payment => @attr
      response.should redirect_to(new_session_path)
    end
    
    it "should add a payment" do
      lambda do
        post :create, :registration_id => @registration, :payment => @attr        
      end.should change(Payment, :count).by(1)
    end
    
    it "should redirect to registrations#index" do
      post :create, :registration_id => @registration, :payment => @attr
      flash[:success] = /saved/i
      response.should redirect_to(registrations_path)
    end 
  end
  
  describe "GET 'new'" do
    it "should require logged in user" do
      logout_user
      get :new, :registration_id => @registration
      response.should redirect_to(new_session_path)
    end 
    
    it "should be success" do
      get :new, :registration_id => @registration
      response.should render_template('new')  
    end
  end
end
