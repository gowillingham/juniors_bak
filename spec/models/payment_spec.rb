require 'spec_helper'

describe Payment do
  before(:each) do
    @registration = Factory(:registration)
    @attr = {
      :registration_id => @registration.id,
      :paypal_txn_id => 'txn_id',
      :paypal_sandbox => false,
      :paypal_payment_status => 'completed',
      :paypal_pending_status_reason => 'echeck',
      :amount => 70,
      :online => true,
      :scholarship => false
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
    it "should respond to receive_paypal_payment"
    describe "receive_paypal_payment" do
      context "when acknowledged by paypal" do
        it "should update the payment when payment_status is 'Complete'" 
        it "should not update the amount for payment_status 'Pending', 'Failed'"
      end
      context "when not acknowledged by paypal" do
        it "should not update the payment"
        it "should log the transaction details"
      end
    end
    
    it "should respond to paid?" do
      Payment.create(@attr).should respond_to(:paid?)
    end
    
    describe "paid" do
      it "should be true if scholarship is true or the payment amount is greater than zero" do
        payment = Payment.create(@attr)
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
