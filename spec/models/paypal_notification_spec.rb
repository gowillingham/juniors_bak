require 'spec_helper'

describe PaypalNotification do
  before(:each) do
    @registration = Factory(:registration)
    @payment = Payment.create(:registration_id => @registration.id)

    @trans_id = "16F08736TA389152H"
    @ipn_params = {"payment_date" => "04:33:33 Oct 13.2007+PDT" ,
      :txn_type => "web_accept",
      :last_name => @registration.last_name,
      :first_name => @registration.first_name,
      :residence_country => "US",
      :item_name => @registration.product.name,
      :payment_gross => @registration.product.price,
      :mc_currency => "USD",
      :business => PAYPAL_ACCOUNT,
      :payment_type => "instant",
      :verify_sign => "AZQLcOZ7B.YM2m-QDAXOrQQcLFYuA0N0XoC3zadaGhkGNF2nlRWmpzlI",
      :payer_status => "verified",
      :test_ipn => "1",
      :tax => "0.00",
      :payer_email => @registration.email,
      :txn_id => @trans_id,
      :receiver_email => PAYPAL_ACCOUNT,
      :invoice => nil,
      :item_number => @registration.id,
      :payment_status => "Completed",
      :mc_fee => "5.52",
      :mc_gross => "180.00",
      :custom => @registration.id,
      :charset => "windows-1252",
      :notify_version => "2.4"
    }
  end
  
  it "should instantiate" do
    notification = PaypalNotification.new(@ipn_params)
  end
  
  it "should return acknowledge = true for when tested" do
    notification = PaypalNotification.new(@ipn_params)
    notification.acknowledge.should be_true
  end
end