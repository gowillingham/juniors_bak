class Product < ActiveRecord::Base
  belongs_to :registration
  
  validates_presence_of :name
  validates_presence_of :price
end
