class PaymentsController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  before_filter :require_login, :except => [:paypal, :ipn]
  before_filter(:only => :paypal) { require_unpaid_registrations params[:id] }
  skip_before_filter :verify_authenticity_token, :only => :ipn
  
  def ipn    
    paypal_notification = PaypalNotification.new(params)
    registration = Registration.find(paypal_notification.item_id)
    
    if paypal_notification.acknowledge
      begin
        if paypal_notification.complete? && (registration.product.price == paypal_notification.gross)
          registration.payment.paypal_txn_id = paypal_notification.txn_id
          registration.payment.paypal_payment_status = paypal_notification.status
          registration.payment.paypal_pending_status_reason = paypal_notification.pending_reason
          registration.payment.amount = paypal_notification.gross
          registration.payment.online = true
        else
          # log incomplete or tampered transaction
        end
      rescue => e
        raise 
      ensure
        registration.payment.save
      end
    else
      # log unacknowledged transaction ..
    end

    render :nothing => true
  end
  
  def paypal
    @registration = Registration.find(params[:registration_id])
  end
  
  def update
    @payment = Payment.find(params[:id])
    @payment.update_attributes(params[:payment])
    if @payment.save
      flash[:success] = 'The payment was saved'
      redirect_to registrations_url
    else
      render 'edit'
    end
  end

  def edit
    @registration = Registration.find(params[:registration_id])
    @payment = Payment.find(params[:id])
  end

  def create
    @registration = Registration.find(params[:registration_id])
    @payment = @registration.build_payment(params[:payment])
    if @payment.save
      flash[:success] = 'The payment was saved'
      redirect_to registrations_url
    else
      render 'new'
    end
  end

  def new
    @registration = Registration.find(params[:registration_id])
    @payment = Payment.new
  end
  
  private
  
    def require_unpaid_registrations(payment_id)
      payment = Payment.find(payment_id)
      if payment.paid?
        flash[:info] = 'The registration has already been paid '
        redirect_to registration_url(payment.registration)
      end
    end
end
