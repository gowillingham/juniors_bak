require 'net/http'

class PaypalNotification
  
  def initialize(params)
    @ipn = params
  end
  
  def complete?
    status == "Completed" 
  end

  def test_ipn?
    @ipn[:test_ipn] == '1'
  end

  def received_at
    Time.parse @ipn[:payment_date]
  end
  
  def custom
    @ipn[:custom]
  end
  
  def status
    @ipn[:payment_status]
  end

  def pending_reason
    @ipn[:pending_reason]
  end

  def txn_id
    @ipn[:txn_id]
  end

  def type
    @ipn[:txn_type]
  end

  def gross
    @ipn[:mc_gross]
  end

  def fee
    @ipn[:mc_fee]
  end

  def currency
    @ipn[:mc_currency]
  end

  def item_id
    @ipn[:item_number]
  end

  def item_name
    @ipn[:item_name]
  end

  def invoice
    @ipn[:invoice]
  end

  def business
    @ipn[:business] 
  end
  
  def receiver_email
    @ipn[:receiver_email]
  end
  
  def acknowledge    
    # always return true if testing ..
    if Rails.env == 'test'
      true
    else
      payload =  @ipn
      response = ssl_post(Paypal.service_url + '?cmd=_notify-validate', payload, 'Content-Length' => "#{payload.size}")
      raise StandardError.new("Faulty paypal result: #{response}") unless ["VERIFIED", "INVALID"].include?(response)
      response == "VERIFIED"
    end
  end  
end
