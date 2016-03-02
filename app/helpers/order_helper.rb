module OrderHelper
  def orderproduct_fulfillment_status(op)
    if op.fulfillment_status == "fulfilled"
      if op.order.delivery_type == "personal"
        "fulfilled"
      else
        "#{op.fulfillment_status.capitalize} on
        #{formatted_date(op.fulfillment_date)},
        #{formatted_time(op.fulfillment_date)}"
      end
    elsif op.fulfillment_status == "has_exception"
      op.limit_exceptions.join(", ")
    else
      op.fulfillment_status.capitalize
    end
  end

  def formatted_date(date)
    date.strftime("%m/%d/%y") unless date.nil?
  end

  def formatted_time(time)
    time.strftime("%l:%M %p") unless time.nil?
  end

  def display_shortname(shortname)
    return shortname == 'FCTS' ? 'ETDNS' : shortname
  end
end
