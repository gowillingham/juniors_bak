class Payment < ActiveRecord::Base
  belongs_to :registration
  
  validates :registration_id, :presence => true
  
  def paid?
    if scholarship
      true
    else
      if (amount > 0)
        true
      else
        false
      end
    end
  end
end
