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
        if !notify.complete?
          Rails.logger.info "PAYPAL_ERROR: transaction did not return 'Completed'"
        elsif registration.product.price != notify.gross
          Rails.logger.info "PAYPAL_ERROR: registration.product.price:#{registration.product.price} <> mc_gross:#{notify.gross} returned by paypal"
        else
          registration.payment.paypal_txn_id = notify.transaction_id
          registration.payment.paypal_payment_status = notify.status
          registration.payment.paypal_pending_status_reason = params[:pending_reason]
          registration.payment.amount = notify.gross
          registration.payment.online = true
        end
      rescue => e
        # there's a bug
        Rails.logger.info "PAYPAL_ERROR: an exception was thrown after notify.acknowledge."
      ensure
        registration.payment.save
      end
    else
      # log unacknowledged transaction ..
      Rails.logger.info "PAYPAL_ERROR: this transaction was not acknowleged by paypal"
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
