class Payment < ActiveRecord::Base
  belongs_to :registration
  
  validates :registration_id, :presence => true
end
