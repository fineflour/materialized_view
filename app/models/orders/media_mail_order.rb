class MediaMailOrder < Order
  def respond_to_exceptions
    if !has_address_exception? 
      # Media mail orders without address exceptions can be processed via bulk mail (cheaper)
      update_type_service = UpdateType.new(self, "bulk")
      new_order = update_type_service.new_order
      new_order.respond_to_exceptions

    else
      orderproducts.each do |op|
        OrderproductManager.new(op).process_as_media_mail_disregarding_address_state
      end

      unless has_questionable_name_exceptions?
        if has_limit_exception?
          ExceptionMailerService.new(self).send_email_for_limit_exception
        end
      end
    end
  end
end
