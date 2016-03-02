class BlacklistedAddressOrder < Order
  def respond_to_exceptions
    orderproducts.each do |op|
      op.state_machine.trigger!(:cancel)
    end
  end
end
