class Product < ActiveRecord::Base
  validates :name,
    :presence => true
    
  validates :price, 
    :numericality => true, 
    :presence => true
end
