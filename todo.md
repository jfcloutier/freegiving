 Card refill 
    belongs_to :payment_method, PaymentMethod
    replace by
    has_one :payment, Payment

A payment belongs to a payment method 
A payment method has many payments

A fundraiser has many payment methods