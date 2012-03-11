# Load the rails application
require File.expand_path('../application', __FILE__)

# set paypal test environment ..
unless Rails.env == 'production'
  PAYPAL_ACCOUNT = 'willin_1248207716_biz@lakevillejuniors.com'
  ActiveMerchant::Billing::Base.mode = :test
else
  # PAYPAL_ACCOUNT = 'info@lakevillejuniors.com'
  PAYPAL_ACCOUNT = 'willin_1248207716_biz@lakevillejuniors.com'
  ActiveMerchant::Billing::Base.mode = :test
end

# required for active_merchant
require 'active_merchant'
require 'active_merchant/billing/integrations/action_view_helper'
ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)

# Initialize the rails application
Juniors::Application.initialize!
