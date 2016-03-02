class OrdersController < ApplicationController
  def index
    @orders = orders_for_index()
  end

  def show
  end

  private

  def orders_for_index
    Order.order("created_at DESC").limit(100).
      #includes(:products, :orderproduct_transitions).limit(100)
      text_search(params[:query]).paginate(page: params[:page])

#    params[:order][:phone] = params[:order][:phone].gsub(/\D/,'')
#    params.require(:order).permit(:email, :firstname, :lastname, :phone, :address1, :address2, :city, :state, :zip, :language_spoken, :
  end
end
