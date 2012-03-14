class PaymentsController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  before_filter :require_login, :except => [:paypal, :ipn]
  before_filter(:only => :paypal) { require_unpaid_registrations params[:id] }
  skip_before_filter :verify_authenticity_token, :only => :ipn
  
  def ipn   
    notify = Paypal::Notification.new(request.raw_post) 
    registration = Registration.find(notify.item_id)
    if notify.acknowledge 
      begin 
        if notify.complete? && (registration.product.price == notify.gross)
          registration.payment.paypal_txn_id = notify.transaction_id
          registration.payment.paypal_payment_status = notify.status
          registration.payment.paypal_pending_status_reason = params[:pending_reason]
          registration.payment.amount = notify.gross
          registration.payment.online = true
        else
          # log incomplete or tampered transaction .. 
        end
      rescue => e
        # there's a bug
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
