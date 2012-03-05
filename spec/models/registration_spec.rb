require 'spec_helper'

describe Registration do
  before(:each) do
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
      :session => 1,
      :has_release => true,
      :product_id => @product.id
    }
  end
  
  it "should add a registration given valid attributes" do
    lambda do
      Registration.create!(@attr)
    end.should change(Registration, :count).by(1) 
  end 
  
  describe "methods" do
    it "should respond to products" do
      registration = Registration.create(@attr)
      registration.should respond_to(:product)
    end
  end 
  
  describe "validations" do 
    it "should require a player first and last name" do
      Registration.new(@attr.merge(:first_name => '')).should_not be_valid
      Registration.new(@attr.merge(:last_name => '')).should_not be_valid
    end
    
    it "should require a parent first and last name" do
      Registration.new(@attr.merge(:parent_first_name => '')).should_not be_valid
      Registration.new(@attr.merge(:parent_last_name => '')).should_not be_valid
    end
    
    it "should require a valid email address" do
      Registration.new(@attr.merge(:email => '')).should_not be_valid
      Registration.new(@attr.merge(:email => 'email')).should_not be_valid
    end
    
    it "shoud require a street address" do
      Registration.new(@attr.merge(:address => '')).should_not be_valid
      Registration.new(@attr.merge(:city => '')).should_not be_valid
      Registration.new(@attr.merge(:state => '')).should_not be_valid
      Registration.new(@attr.merge(:zip => '')).should_not be_valid
    end
    
    it "should require a valid phone number" do 
      Registration.new(@attr.merge(:phone => '')).should_not be_valid
      Registration.new(@attr.merge(:phone => '999')).should_not be_valid
      Registration.new(@attr.merge(:phone => 'x78-898-9999')).should_not be_valid
    end
    
    it "should require a numeric grade" do
      Registration.new(@attr.merge(:grade => nil)).should_not be_valid
      Registration.new(@attr.merge(:grade => 'x')).should_not be_valid
    end
    
    it "should require a tshirt size" do
      Registration.new(@attr.merge(:tshirt_size => '')).should_not be_valid
    end
    
    it "should require a session" do
      Registration.new(@attr.merge(:session => nil)).should_not be_valid
    end
  end
end
