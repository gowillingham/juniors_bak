class Product < ActiveRecord::Base
  belongs_to :registration
  
  validates :name,
    :presence => true
    
  validates :price, 
    :numericality => true, 
    :presence => true
end
