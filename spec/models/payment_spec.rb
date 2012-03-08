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
    it "should respond to registration" do
      payment = Payment.create(@attr)
      payment.should respond_to(:registration)
    end
  end
end
