class InternationalOrder < Order
  def respond_to_exceptions
    orderproducts.each do |op|
      OrderproductStateMachineTrigger.new(op).cancel_order
    end
    send_international_email
  end

  def send_international_email
    ExceptionMailerService.new(self).send_email_for_international_address
  end
end
