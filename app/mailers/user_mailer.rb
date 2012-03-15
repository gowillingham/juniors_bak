class UserMailer < ActionMailer::Base
  default :from => INFO_EMAIL_ADDRESS
  
  def customer_notification_for_registration_payment(registration)
    @registration = registration
    subject = "[#{APP_SHORT_NAME}] **Payment confirmation for #{registration.first_name} #{registration.last_name}**"
    mail :to => registration.email, :subject => subject
  end
  
  def customer_notification_for_registration(registration)
    @registration = registration
    subject = "[#{APP_SHORT_NAME}] **Registration confirmation for #{registration.first_name} #{registration.last_name}**"
    
    mail :to => registration.email, :subject => subject
  end
end
