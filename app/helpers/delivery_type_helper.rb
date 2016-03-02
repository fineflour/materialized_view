module DeliveryTypeHelper

  def container_type(pallet)
    if pallet.nil? || pallet.mailing_configuration.kind.match(/Media/)
      "Job"
    else
      "Pallet"
    end
  end

  def undo_action(pallet)
    if pallet.mailing_configuration.kind.match(/Media/)
      "Cancel Job!"
    else
      "Unpalletize!"
    end
  end

  def size_info(pallet)
    if pallet.mailing_configuration.media?
      pallet.orderproducts.pluck(:order_id).uniq.count.to_s + " (" + pallet.size.to_s + ")"
    else
      pallet.size
    end
  end
end
