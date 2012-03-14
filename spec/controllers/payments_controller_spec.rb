require 'spec_helper'

describe PaymentsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    login_user @user
    
    @registration = Factory(:registration)
    @registration.product.update_attribute(:price, 70)
    @attr = {
      :paypal_txn_id => 'txn_id',
      :paypal_sandbox => false,
      :paypal_payment_status => 'Completed',
      :paypal_pending_status_reason => 'echeck',
      :amount => 70,
      :online => false,
      :scholarship => false
    }
  end
  
  describe "POST 'ipn'" do
    
    # todo: add to Payment model
    # ------------
    # paypal_txn_type
    # paypal_payment_type
    # paypal_verify_sign
    # paypal_payer_status
    # paypal_mc_fee
    
    
    
    before(:each) do
      @payment = Payment.create(:registration_id => @registration.id)
      
      @trans_id = "16F08736TA389152H"
      @ipn_params = {"payment_date" => "04:33:33 Oct 13.2007+PDT",
        :txn_type => "web_accept",
        :last_name => @registration.last_name,
        :first_name => @registration.first_name,
        :payer_email => @registration.email,
        :item_name => @registration.product.name,
        :item_number => @registration.id,
        :custom => @registration.id,
        :mc_gross => @registration.product.price,
        :business => PAYPAL_ACCOUNT,
        :receiver_email => PAYPAL_ACCOUNT,
        :residence_country => "US",
        :mc_currency => "USD",
        :payment_type => "instant",
        :verify_sign => "AZQLcOZ7B.YM2m-QDAXOrQQcLFYuA0N0XoC3zadaGhkGNF2nlRWmpzlI",
        :payer_status => "verified",
        :test_ipn => "1",
        :tax => "0.00",
        :txn_id => @trans_id,
        :invoice => nil,
        :payment_status => "Completed",
        :mc_fee => "5.52",
        :charset => "windows-1252",
        :notify_version => "2.4"
      }
    end
    
    it "should be success" do
      post :ipn, @ipn_params
      response.should be_success 
    end
    
    describe "that are acknowledged" do
      it "should update the payment" 
      it "should not update the amount for payment_status 'Pending', 'Failed'"
    end
    
    describe "that are not acknowledged" do
      it "should not update the payment"
      it "should log the transaction details"
    end
  end
  
  describe "GET 'paypal'" do
    before(:each) do
      @payment = Payment.create(@attr.merge(:registration_id => @registration.id, :amount => nil))
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
    
    it "should redirect to registration#show with message if this payment is already paid" do
      @registration.payment.update_attributes(:amount => 70)
      get :paypal, :registration_id => @registration, :id => @payment
      response.should redirect_to(registration_path(@registration))
    end 
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
