class Payment < ActiveRecord::Base
  belongs_to :registration
  
  validates :registration_id, :presence => true
  
  def receive_paypal_payment(params_hash, notify)
    registration = Registration.find(registration_id)
    received = false
    
    if notify.acknowledge
      begin 
        if !(params_hash[:payment_status] == 'Completed')
          Rails.logger.info "PAYPAL_TXN: transaction did not return 'Completed'"
        elsif "#{registration.product.price.to_s}.00" != params_hash[:mc_gross]
          Rails.logger.info "PAYPAL_TXN: registration.product.price:#{registration.product.price} <> mc_gross:#{params[:mc_gross]} returned by paypal"
        else
          update_attributes(
            :paypal_txn_id => params_hash[:txn_id],
            :paypal_payment_status => params_hash[:payment_status],
            :paypal_pending_status_reason => params_hash[:pending_reason],
            :paypal_txn_type => params_hash[:txn_type],
            :paypal_payment_type => params_hash[:payment_type],
            :paypal_verify_sign => params_hash[:verify_sign],
            :paypal_payer_status => params_hash[:payer_status],
            :paypal_mc_fee => params_hash[:mc_fee],
            :amount => params_hash[:mc_gross],
            :online => true
          )
          Rails.logger.info "PAYPAL_TXN: Accepted payment #{amount} for registration_id #{registration_id}"
          
          received = true
        end
      rescue => e
        Rails.logger.info "PAYPAL_TXN: A problem in notify.acknowledge block"
      ensure
        save
      end
    else
      Rails.logger.info "PAYPAL_TXN: this transaction was not acknowleged by paypal"
    end
    
    return received
  end
  
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
