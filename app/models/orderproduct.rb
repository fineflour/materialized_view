class Orderproduct < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  belongs_to :order, touch: true
  belongs_to :product
  belongs_to :pallet

  has_many :order_exceptions
  has_many :questionable_name_exceptions
  has_many :order_exceptions, :dependent => :destroy
  has_many :orderproduct_transitions
  has_many :orderproduct_transitions, :dependent => :destroy
  has_many :materials, through: :product

  after_create :set_state_to_initial

  def state_machine
    @state_machine ||= OrderproductStateMachine.new(
      self, transition_class: OrderproductTransition)
  end

  def state #todo: this is duplicate of fulfilmment_status (refactor remove it)
    self.state_machine.current_state
  end

  #--SCOPES-------------------------------------
  scope :in_state, -> (state) { where(current_state: state) }
  scope :not_in_state, -> (state) { where.not(current_state: state) }
  scope :address_exceptions, -> { joins(:order_exceptions).where('order_exceptions.type' => OrderException::ADDRESS_EXCEPTIONS) }
  scope :in_last_x_days, -> (numdays) { where("orderproducts.created_at > ?", Time.now - numdays.days) }
  scope :after, -> (date) { where("orderproducts.created_at > ?", date) }
  scope :by_product, -> (product) { where("orderproducts.product_id = ?", product.id) }
  scope :before, -> (time) { where("orderproducts.created_at < ?", time) }
  scope :by_mailing_configuration, -> (mailing_configuration) { joins(:product).where("products.mailing_configuration_id" => mailing_configuration.id) }
    # TODO: associate by using mailing_configuration_id
    # TODO: consider changing name from mailing_configuration to pallet_configuration
  scope :palletizable_by_mailing_configuration, -> (mailing_configuration) { in_state(:palletizable).by_mailing_configuration(mailing_configuration) }
  scope :by_name_hash, -> (name) { joins(:order).where("orders.name_hash" => name) }
    # TODO: we should not use a column that has strong dependence on other
    # columns in the same table. Need to refactor this
  scope :by_email, -> (email) {
    joins(:order).where("lower(orders.email) = ?", email.downcase)
  }
  scope :by_address_hash, -> (address_hash) { joins(:order).where("orders.address_hash" => address_hash) }

  scope :by_address_barcode, -> (address_barcode) {
    joins(order: :smarty_streets_response).
    where("smarty_streets_responses.delivery_point_barcode" => address_barcode)
  }

  #--END SCOPES ---------------------------------

  def name
    Product.find(product_id).name
  end

  def has_address_exception?
    (self.order_exceptions.where("order_exception.type" => OrderException::ADDRESS_EXCEPTIONS).merge(OrderException.not_in_state(:corrected)).pluck(:type)).any?
  end

  def limit_exceptions
    self.order_exceptions.where("type" => OrderException::LIMIT_EXCEPTIONS).pluck(:type)
  end

  def clear_questionable_name_exception
    order_exceptions.each do |oe|
      if oe.type.in? OrderException::QUESTIONABLE_NAME_EXCEPTIONS
        oe.destroy!
      end
    end
  end

  def kind
    Product.find(product_id).shortname
  end

  def language
    Product.find(product_id).language
  end

  def first_in_order_to_be_palletized?
    self.order.orderproducts.in_state(:palletized).count == 1
  end

  #todo: refactor this method OUT
  def fulfillment_status
    self.current_state
  end

  def fulfillment_date
    if fulfillment_status == 'fulfilled' and self.order.delivery_type != "personal"
      Pallet.find(pallet_id).shipped_at
    else
      nil
    end
  end

  def csv_address_line
    Csv_Formatter.new(self).format
  end

  def has_limit_exception?
    (self.order_exceptions.pluck(:type) & OrderException::LIMIT_EXCEPTIONS).any?
  end

  def delete_from_order
    self.destroy unless self.order.orderproducts.size == 1
  end

  def can_be_deleted_from_order?
    self.state == "palletizable" && self.order.orderproducts.size > 1 
  end

  private

  def set_state_to_initial
    state_machine.trigger!(:initialize)
  end

  def self.transition_class
    OrderproductTransition
  end
end
