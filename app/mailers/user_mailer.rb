class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def customer_notification_for_registration(registration)
    @registration = registration
    @product_name = ''
    subject = "[#{APP_SHORT_NAME}] **Registration confirmation for #{registration.first_name} #{registration.last_name}**"
    
    mail :to => registration.email, :subject => subject
  end
end
