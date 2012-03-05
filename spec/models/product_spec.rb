require 'spec_helper'

describe Product do
  before(:each) do
    @attr = {
      :name => 'Intermediate session', 
      :description => 'Grade 3-5 volleyball session',
      :price => 7000,
      :enabled => true
    }
  end
  
  it "should create a product given valid attributes" do
    lambda do
      Product.create!(@attr)
    end.should change(Product, :count).by(1)
  end 
  
  describe "validations" do
    it "should require a name" do
      Product.new(@attr.merge(:name => nil)).should_not be_valid
    end
    
    it "should require a price" do
      Product.new(@attr.merge(:price => nil)).should_not be_valid
    end
  end
end
