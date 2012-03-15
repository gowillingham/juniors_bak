require 'spec_helper'

describe Payment do
  before(:each) do
    @registration = Factory(:registration)
    @attr = {
      :registration_id => @registration.id,
    }
  end
  
  it "should create a payment" do
    lambda do
      Payment.create!(@attr)
    end.should change(Payment, :count).by(1)
  end
  
  describe "validations" do
    it "should require a registration" do
      Payment.new(@attr.merge(:registration_id => nil)).should_not be_valid
    end
  end
  
  describe "methods" do
    it "should respond to receive_paypal_payment" do
      Payment.create(@attr).should respond_to(:receive_paypal_payment)
    end
    
    describe "receive_paypal_payment" do
      before(:each) do
        @payment = Payment.create!(@attr)
        
        @trans_id = "16F08736TA389152H"
        @ipn_params = {"payment_date" => "04:33:33 Oct 13.2007+PDT",
          :txn_type => "web_accept",
          :last_name => @registration.last_name,
          :first_name => @registration.first_name,
          :payer_email => @registration.email,
          :item_name => @registration.product.name,
          :item_number => @registration.id,
          :custom => @registration.id,
          :mc_gross => "100.00",
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
          :payment_status => 'Completed',
          :mc_fee => "5.52",
          :charset => "windows-1252",
          :notify_version => "2.4"
        }
      end
      
      context "when acknowledged by paypal" do
        it "should update the payment when payment_status is 'Complete'" do
          notifier = double("notifier", :acknowledge => true)
          @payment.receive_paypal_payment(@ipn_params, notifier)
          @payment.amount.should eq(@registration.product.price)
        end
        
        it "should not update the payment when mc_gross <> product.price" do
          notifier = double("notifier", :acknowledge => true)
          @payment.receive_paypal_payment(@attr, notifier)
          @payment.amount.should be_nil  
        end
        
        it "should not update the amount for payment_status 'Pending'" do
          notifier = double("notifier", :acknowledge => true)
          @payment.receive_paypal_payment(@attr.merge(:payment_status => PAYPAL_PENDING), notifier)  
          @payment.amount.should be_nil
          @payment.paypal_txn_id.should be_nil        
        end 
        
        it "should not update the amount for payment_status 'Failed'" do
          notifier = double("notifier", :acknowledge => true)
          @payment.receive_paypal_payment(@attr.merge(:payment_status => PAYPAL_FAILED), notifier)  
          @payment.amount.should be_nil
          @payment.paypal_txn_id.should be_nil        
        end 
      end
      
      context "when not acknowledged by paypal" do
        it "should not update the payment" do
          notifier = double("notifier", :acknowledge => false)
          @payment.receive_paypal_payment(@attr, notifier)
          @payment.amount.should be_nil
        end
      end
    end
    
    it "should respond to paid?" do
      Payment.create(@attr).should respond_to(:paid?)
    end
    
    describe "paid" do
      it "should be true if scholarship is true or the payment amount is greater than zero" do
        payment = Payment.create(@attr.merge(:amount => 70))
        payment.paid?.should be_true
        
        payment.amount = nil
        payment.scholarship = true
        payment.save
        payment.paid?.should be_true
        
        payment.amount = 0
        payment.scholarship = true
        payment.save
        payment.paid?.should be_true
        
        payment.scholarship = false
        payment.save
        payment.paid?.should_not be_true
      end
    end
    
    it "should respond to registration" do
      payment = Payment.create(@attr)
      payment.should respond_to(:registration)
    end
  end
end
