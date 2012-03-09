class Payment < ActiveRecord::Base
  belongs_to :registration
  
  validates :registration_id, :presence => true
  
  def paid?
    if scholarship
      true
    else
      if amount.nil?
        false
      elsif amount == 0
        false
      else
        true
      end
    end
  end
end
