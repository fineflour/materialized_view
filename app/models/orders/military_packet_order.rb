class MilitaryPacketOrder < Order

  def respond_to_exceptions
    orderproducts.each do |op|
      OrderproductManager.new(op).process_as_media_mail_with_valid_address
    end

    unless has_questionable_name_exceptions?
      limit_exception_email_if_needed
      address_and_limit_exception_email_if_needed
      address_exception_email_if_needed
    end
  end

  def respond_to_military_address_exceptions
    orderproducts.each do |op|
      OrderproductManager.new(op).process_as_media_mail_disregarding_address_state
    end

    unless has_questionable_name_exceptions?
      limit_exception_email_if_needed
    end
  end

  private

  def limit_exception_email_if_needed
    if !has_address_exception? && has_limit_exception?
      ExceptionMailerService.new(self).send_email_for_limit_exception
    end
  end

  def address_and_limit_exception_email_if_needed
    if has_undeliverable_address_exception? && has_limit_exception?
      ExceptionMailerService.new(self).send_email_for_address_and_limit_exception
    end
  end

  def address_exception_email_if_needed
    if has_undeliverable_address_exception? && !has_limit_exception?
      ExceptionMailerService.new(self).send_email_for_address_exception
    end
  end
end
