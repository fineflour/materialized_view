class SearchOrdersController < ApplicationController
  def index
    binding.pry
    @search = OrderSearchMatview.search(params[:q])
    @search_orders = @search.result.includes(:products).order('created_at ASC').paginate(:page => params[:page], :per_page => 30)
    @search.build_condition if @search.conditions.empty?
  end
end
