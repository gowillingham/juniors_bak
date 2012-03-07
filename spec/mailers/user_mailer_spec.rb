require "spec_helper"

describe UserMailer do
  describe "customer_notification_for_registration" do
    before(:each) do
      @registration = Factory(:registration)
      @mail = UserMailer.customer_notification_for_registration @registration
    end
    
    it "should have the correct subject" do
      @mail.subject.should =~ /#{@registration.first_name} #{@registration.last_name}/i
    end
    
    it "should have the correct :to address" do
      @mail.to.should eq([@registration.email])
    end
    
    it "should have the correct :from address" do
      @mail.from.should eq([INFO_EMAIL_ADDRESS])
    end 
  end
end
