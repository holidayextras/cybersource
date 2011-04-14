# ActiveMerchant CyberSource Subscription Extensions

Implements CyberSource subscriptions in ActiveMerchant.

## Create a subscription

Creates a subscription on CyberSource.  Can be used to make recurring payments or just storing a credit card for later use.

`GATEWAY.create_subscription(creditcard, options={})`

Credit card should be an instance of ActiveMerchant::Billing::CreditCard.

The same options are required as with a normal authorisation or capture.  There are some subscription specific options that should be set.

* `subscription_id` should be a reference for this subscription.
* `title` should be used to give a descriptive title of the subscription.
* `payment_method` should represent what the payment method is, probably just 'credit card' for now.

These should all be nested under a subscription hash e.g.

    options = {
      :subscription => {
        :subscription_id => "test",
        :title => "blah",
        :payment_method => "credit card"
      }
    }

This returns an ID for the subscription as part of the response, can be accessed from params as 'requestID'.  This should be stored somewhere as it will be used to retrieve details of the subscription as well as make authorisations against the stored card.

    response = GATEWAY.create_subscription(creditcard, options)
    response.params["requestID"] # -> the ID for this subscription

## Retrieve a subscription

Get all the details of a subscription with a matching ID.  Importantly this includes details of the card that will identify it to the owner, e.g. obfuscated credit card number.

    GATEWAY.retrieve_subscription(subscription_id, options)

The method needs a subscription_id (duh!) and an options hash, the options hash needs a `order_id` key to succeed.  In practise this `order_id` can be any random string, I can't see where it is being used by CyberSource, just include it and don't ask questions, ok?

The method returns with all the details of the subscription which can be found in the params hash of the response.

    response = GATEWAY.retrieve_subscription(123, :order_id => "whatever")
    response.params["cardAccountNumber"] # -> the obfuscated credit card number
    response.params["cardType"] # -> code for the card type e.g. 001 = visa
    response.params["cardExpirationYear"]
    response.params["cardExpirationMonth"]

## Authorize a subscription

Create an authorisation for funds from a credit card stored in a subscription, works in much the same way as the normal authorize method.

    GATEWAY.auth_subscription(amount, subscription_id, options)

This method uses the same options as the normal authorize, the only difference in the method signiture is the name and the second parameter which should be the `subscription_id` to charge instead of a credit card.

The response should be the same as the normal authorize, so you can grab the auth token and later on capture the authorized funds.

## Delete a subscription

Deletes a stored subscription.

    GATEWAY.delete_subscription(subscription_id, options)

Again the options needs to contain an `order_id` key, this can be whatever you want.

    GATEWAY.delete_subscription(123, :order_id => "who knows what this is for?")