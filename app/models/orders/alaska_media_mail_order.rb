class AlaskaMediaMailOrder < Order
  def respond_to_exceptions
    orderproducts.each do |op|
      OrderproductManager.new(op).process_as_media_mail_with_valid_address
    end

    unless has_questionable_name_exceptions?
      if !has_address_exception? && has_limit_exception?
        ExceptionMailerService.new(self).send_email_for_limit_exception
      elsif has_undeliverable_address_exception? && has_limit_exception?
        ExceptionMailerService.new(self).send_email_for_address_and_limit_exception
      elsif has_undeliverable_address_exception? && !has_limit_exception?
        ExceptionMailerService.new(self).send_email_for_address_exception
      end
    end
  end
end
