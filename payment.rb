require "rubygems"
require "bundler/setup"
require "active_merchant"

ActiveMerchant::Billing::Base.mode = :test

gateway = ActiveMerchant::Billing::CyberSourceGateway.new(
  :test => true,
  :login => "LOGIN",
  :password => "PASSWORD",
  :ignore_avs => true
)

credit_card = ActiveMerchant::Billing::CreditCard.new(
  :type               => "visa",
  :number             => "4111111111111111",
  :verification_value => "123",
  :month              => 1,
  :year               => Time.now.year+1,
  :first_name         => "Test",
  :last_name          => "Test"
)

subscription_options = {
  :order_id => "test123",
  :currency => "GBP",
  :email => "oliver@example.com",
  :subscription => {
    :title => "Testing!",
    :payment_method => "credit card"
  },
  :address => {
    :address1 => "1 High Street",
    :address2 => "",
    :city => "London",
    :state => "London",
    :zip => "SW113EP",
    :country => "UK"
  }
}

# SUBSCRIPTION_ID = 3026187276810008284282

# Create a subscription
# puts gateway.create_subscription(credit_card, subscription_options).inspect

# Authorize a subscription
# puts gateway.authorize_subscription(1000, 123, subscription_options).inspect

# Get the details of a specific subscription & print result
# puts gateway.retrieve_subscription(123, :order_id => "this seems random").inspect

# Delete a subscription & print result
# puts gateway.delete_subscription(123, :order_id => "whatever").inspect

# Create subscription, make an authorization against it and then capture the authorized funds
# response = gateway.create_subscription(credit_card, subscription_options)
# subscription_id = response.params["requestID"]
# auth = gateway.auth_subscription(100, subscription_id, subscription_options)
# capture_response = gateway.capture(100, auth.authorization, subscription_options)
# 
# puts capture_response.inspect