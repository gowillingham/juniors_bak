class Registration < ActiveRecord::Base
  belongs_to :product
  has_one :payment
  
  validates :product_id, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :parent_first_name, :presence => true
  validates :parent_last_name, :presence => true
  validates :zip, :format => { :with => %r{\d{5}(-\d{4})?} }

  validates :school, :presence => true
  validates :grade, 
    :presence => true,
    :numericality => true
  validates :tshirt_size, :presence => true 
  validates :phone, 
    :presence => true,
    :format => { :with => /^[\(\)0-9\- \+\.]{10,20}$/ }
  validates :email,
    :presence => true,
    :confirmation => true,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  validates :has_release, 
    :presence => { :message => ": Please read and accept the liability waiver" }

  validates_presence_of :parent_tshirt_size, :if => :parent_helper?, :message => "needed for parent helpers"
end
