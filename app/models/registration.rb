class Registration < ActiveRecord::Base
  validates_presence_of :session, :message => ": You didn't select an inhouse session"

  validates_presence_of :first_name, :last_name, :parent_first_name, :parent_last_name
  validates_presence_of :address, :city, :state

  validates_presence_of :zip  
  validates_format_of :zip, :with => %r{\d{5}(-\d{4})?}

  validates_presence_of :phone
  validates_format_of :phone, :with => /^[\(\)0-9\- \+\.]{10,20}$/

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_presence_of :email
  validates_confirmation_of :email

  validates_presence_of :school, :grade, :tshirt_size
  validates_presence_of :parent_tshirt_size, :if => :parent_helper?, :message => "needed for parent helpers"
  validates_presence_of :has_release, :message => ": Please read and accept the liability waiver"
  validates :grade, :numericality => true
end
