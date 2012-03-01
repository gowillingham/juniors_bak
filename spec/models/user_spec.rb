require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :email => 'user@gmail.com',
      :password => 'password',
      :password_confirmation => 'password'
    }
  end
  
  it "should add a user given valid attributes" do
    lambda do
      User.create!(@attr)
    end.should change(User, :count).by(1)
  end 
  
  describe "validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => '')).should_not be_valid
    end
    
    it "should require password confirmation" do
      User.new(@attr.merge(:password_confirmation => 'something_else')).should_not be_valid
    end
    
    it "should only allow unique email addresses" do
      User.create(@attr)
      User.new(@attr).should_not be_valid
    end
  end
end
