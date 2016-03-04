class Order < ActiveRecord::Base
  include PgSearch
  self.inheritance_column = :_type_disabled
  #include Language
  REQUEST_METHOD = %w( web ios android called-in mailed-in e-mailed landingpage)
  OPEN_MEDIA_DELIVERY_TYPES = ["media mail", "media PR"]
  ALASKA_DELIVERY_TYPES = ["media AK"]
  MILITARY_DELIVERY_TYPES = ["media ML"]
  MEDIA_DELIVERY_TYPES = OPEN_MEDIA_DELIVERY_TYPES + ALASKA_DELIVERY_TYPES + MILITARY_DELIVERY_TYPES
  DELIVERY_TYPES_FOR_BULK_MAIL = ["bulk"]
  PERSONAL_DELIVERY_TYPE = ["personal"]
  INTERNATIONAL_DELIVERY_TYPES = ["international"] #automatically gets put into a state of cancelled
  DELIVERY_TYPES = MEDIA_DELIVERY_TYPES + DELIVERY_TYPES_FOR_BULK_MAIL + PERSONAL_DELIVERY_TYPE
  ADDRESS_EXCEPTION_DELIVERY_TYPES = DELIVERY_TYPES_FOR_BULK_MAIL + ALASKA_DELIVERY_TYPES + MILITARY_DELIVERY_TYPES
  HOW_HEARD_OPTIONS = ["BfA Literature","Brochure Stand", "Chaplain", "Commanding officer", "Direct Distribution", "Facebook", "Fellow service member", "Friend", "Gospel of John", "Internet search engine", "News/Magazine", "Offer in mailbox", "Other", "Radio ad", "Relative", "Twitter", "Word of Mouth"]

  self.per_page = 50 # for will paginate

  attr_reader :s_address1, :s_address2, :s_city, :s_state, :s_zip
  validates :firstname, :lastname, :address1, :city, :state, :zip, :products, presence: true

  has_many :orderproducts
  has_many :orderproducts, :dependent => :destroy
  has_many :mailing_configurations, through: :orderproducts

  has_many :products,  through: :orderproducts
  has_many :order_exceptions, through: :orderproducts
  has_many :questionable_name_exceptions, through: :orderproducts
  has_many :orderproduct_transitions, through: :orderproducts
  has_many :notes, :dependent => :destroy

  has_one :smarty_streets_response
  has_one :blacklisted_address

  accepts_nested_attributes_for :notes, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :orderproducts

  before_save :hash_address
  before_save :hash_name
  before_save { |order| order.email = email.downcase if order.email }
  before_save :build_search_body
  before_create :default_values
  after_touch :update_search_body_column

  has_paper_trail
  geocoded_by :address_p

  #--MAILER----------------------------------------------
  def send_order_confirmation_email
    unless self.email.blank?
      CustomerMailer.order_confirmation(self).deliver
    end
  end

  #--SCOPES----------------------------------------------
  scope :within_three_months, -> {where("orders.created_at > ?", 3.months.ago)}
  scope :before, -> (beforedate) { where("orders.created_at < ?", beforedate) }
  scope :after, -> (afterdate) { where("orders.created_at > ?", afterdate) }
  scope :by_email, ->(email) { where("email = ?", email )}
  scope :media_orders, -> { where("delivery_type" => MEDIA_DELIVERY_TYPES)}
  scope :open_media, -> (state) {where("delivery_type" => OPEN_MEDIA_DELIVERY_TYPES).joins(:orderproducts).where(orderproducts: {current_state: state }).uniq(:order_id).order('orders.created_at asc')}
  scope :AK_media, -> (state) {order("created_at ASC").where("delivery_type" => ALASKA_DELIVERY_TYPES).joins(:orderproducts).where(orderproducts: {current_state: state }).uniq(:order_id)}
  scope :ML_Packet, -> (state) {order("created_at ASC").where("delivery_type" => MILITARY_DELIVERY_TYPES).joins(:orderproducts).where(orderproducts: {current_state: state }).uniq(:order_id)}
  scope :by_address_hash, -> (hash) { where("orders.address_hash = ?", hash) }
  scope :in_last_x_days, -> (numdays) { where("orders.created_at > ?", Time.now - numdays.days) }
  scope :by_orderproduct_state, -> (state) { joins(:orderproducts).where(orderproducts: {current_state: state}).uniq }
  scope :with_same_dpb, -> (code) { joins(:smarty_streets_response).where("smarty_streets_responses.delivery_point_barcode" => code).order('orders.created_at desc') }
  scope :with_invalid_address_exceptions, -> { joins(:order_exceptions).where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).uniq.merge(OrderException.in_state(:invalid)) }
  scope :with_invalid_address_exceptions_marked_bulk, -> { where("delivery_type" => DELIVERY_TYPES_FOR_BULK_MAIL).joins(:order_exceptions).where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).uniq.merge(OrderException.in_state(:invalid)) }
  scope :with_invalid_address_exceptions_qualifying_delivery_type,
    ->{ where("delivery_type" => ADDRESS_EXCEPTION_DELIVERY_TYPES).
      joins(:order_exceptions).
      where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).
      uniq.
      merge(OrderException.in_state(:invalid)) }
  scope :with_invalid_address_exceptions_qualifying_delivery_type_and_op_state,
    -> { where("delivery_type" => ADDRESS_EXCEPTION_DELIVERY_TYPES).
      joins(:order_exceptions).
      where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).
      merge(OrderException.in_state(:invalid)).
      joins(:orderproducts).
      where.not("orderproducts.current_state" => "cancelled").
      uniq }
  scope :by_product_name, -> (name) { joins(:products).merge(Product.where(shortname: name)) }
  scope :with_exception, -> { joins(:order_exceptions) }
  scope :with_questionable_name_exceptions, -> { joins(:orderproducts).where.not("orderproducts.current_state" => "cancelled").joins(:order_exceptions).where("order_exceptions.type" => OrderException::QUESTIONABLE_NAME_EXCEPTIONS).uniq } #.merge(OrderException.in_state(:invalid)) }

  # TODO: consider moving this to report.rb
  scope :by_cities_like, (lambda do |cities|
    if cities.present?
      cities_array = cities.split(',').collect{|x| x.strip}
      Order.where(table[:city].matches_any(cities_array))
    end
  end)

  scope :by_state_like, (lambda do |state|
    if state.present?
      Order.where(table[:state].matches(state))
    end
  end)

  scope :by_language_spoken, (lambda do |language_spoken|
    if language_spoken.present?
      Order.where(table[:language_spoken].matches(language_spoken))
    end
  end)

  def self.have_fulfilled_orderproducts
    includes(:orderproducts).
      where("orderproducts.current_state" => "fulfilled")
  end

  pg_search_scope :pgsearch, against: [:search_body]

  #--END SCOPES-----------------------------------------

  def has_military_products?
    military_products = [Product::MILITARY_PACKET, Product::MILITARY_BIBLE]
    order_products = self.products.map(&:id).uniq
    (military_products & order_products).count > 0
  end

  def self.table
    Order.arel_table
  end

  def non_editable_state?
    self.orderproducts.in_state([:palletizable,
                                :shippable,
                                :packaged,
                                :palletized,
                                :fulfilled,
                                :returned,
                                :not_received]).count > 0
  end

  def palletized_and_after_state?
    self.orderproducts.in_state([:palletized,
                                :packaged,
                                :fulfilled]).count > 0
  end

  def cancelled?
    self.orderproducts.in_state("cancelled").count > 0
  end

  def has_op_with_state?(state)
    self.orderproducts.in_state(state).count > 0
  end

  def is_open_media?
   OPEN_MEDIA_DELIVERY_TYPES.include? self.delivery_type
  end

  def is_media?
   MEDIA_DELIVERY_TYPES.include? self.delivery_type
  end

  def is_alaska_delivery_type?
   ALASKA_DELIVERY_TYPES.include? self.delivery_type
  end

  def is_international?
   INTERNATIONAL_DELIVERY_TYPES.include? self.delivery_type
  end

  def address_exception
   self.orderproducts.first.order_exceptions.where("type" => OrderException::ADDRESS_EXCEPTIONS).first
  end

  def address_exception_state
    ae = address_exception
    unless ae == nil
      ae.state_machine.current_state
    end
  end

  def smarty_streets_match_code_interpreter
    SmartyStreetsMatchCodeInterpreter.new.interpret_order(self) if self.smarty_streets_response
  end

  def smarty_streets_footnote_interpreter
    SmartyStreetsFootnoteInterpreter.new.interpret_order(self) if self.smarty_streets_response
  end

  def ss_match_code
    self.smarty_streets_response.match_code if self.smarty_streets_response
  end

  def all_orderproducts_fulfilled?
    !(self.orderproducts.not_in_state(:fulfilled).size > 0)
  end

  def self.text_search(query)
    if query
      OrderSearch.new(query).result
    else
      #Order.all
      Order.all
    end
  end

  def address
    Address.new(address1: address1,
                address2: address2,
                state: state,
                city: city,
                zip: zip)
  end

  def hash_address
    # Removes non alphanumerics and upcases it
    self.address_hash = "#{address1}#{address2}#{city}#{state}#{zip}".gsub(/[^0-9a-z]/i,"").upcase
  end

  def hash_name
    # Removes non alphanumerics and upcases it
    self.name_hash = "#{self.firstname}#{self.lastname}".gsub(/[^a-z]/i,"").upcase
  end

  def cancel
    self.orderproducts.each do |op|
      if %w(initial palletizable has_exception shippable).include? op.fulfillment_status
        op.state_machine.trigger!(:cancel)
      end
    end
  end

  def name
    "#{self.firstname} #{self.lastname}"
  end

  # TODO: can't you access with order.address_exception ?
  def has_address_exception?
    (self.order_exceptions.where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).merge(OrderException.not_in_state(:corrected)).pluck(:type)).any?
  end

  def has_invalid_address_exception?
    (self.order_exceptions.where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).merge(OrderException.in_state(:invalid)).pluck(:type)).any?
  end

  def has_undeliverable_address_exception?
    (self.order_exceptions.where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).merge(OrderException.in_state(:undeliverable)).pluck(:type)).any?
  end

  def has_corrected_address_exception?
    (self.order_exceptions.where("order_exceptions.type" => OrderException::ADDRESS_EXCEPTIONS).merge(OrderException.in_state(:corrected)).pluck(:type)).any?
  end

  def has_limit_exception?
    (self.order_exceptions.pluck(:type) & OrderException::LIMIT_EXCEPTIONS).any?
  end

  def has_questionable_name_exceptions?
    self.questionable_name_exceptions.any?
  end

  def clear_questionable_name_exceptions
    orderproducts.each do |op|
      op.clear_questionable_name_exception
    end
  end

  def approve
    if self.is_open_media?
      self.orderproducts.each do |op|
        if op.state_machine.current_state == "has_exception"
          op.state_machine.trigger!(:approve_media_orderproduct)
        end
      end
    else
      self.orderproducts.each do |op|
        if op.state_machine.current_state == "has_exception"
          op.state_machine.trigger!(:approve_orderproduct)
        end
      end
    end
  end

  def has_exception?
    self.orderproducts.in_state(:has_exception).any?
  end

  def product_names
    products.map(&:shortname).flatten.join(', ')
  end

  def product_languages
    products.pluck(:language).uniq.join(" ")
  end

  def build_search_body
    note_contents = self.notes.pluck(:content, :entered_by).flatten.join(' ')
    self.search_body = [firstname, lastname, address1, address2, city, state, zip, phone, email, product_names, product_languages, note_contents].compact.join(' ')
  end

  def update_search_body_column
    update_columns(search_body: build_search_body)
  end

  def append_note(note_text, entered_by = "System")
    notes.create(content: note_text, entered_by: entered_by) unless note_text.blank?
  end

  def default_values
    self.delivery_type ||= 'bulk'
    self.type = "BulkMailOrder" if delivery_type == 'bulk'
    self.type = "MediaMailOrder" if MEDIA_DELIVERY_TYPES.include? delivery_type
    self.type = "MilitaryPacketOrder" if MILITARY_DELIVERY_TYPES.include? delivery_type

    if state == 'AK'
      self.type = "AlaskaMediaMailOrder"
      self.delivery_type = "media AK" 
    end

    unless (self.type == "MilitaryPacketOrder") || (self.type == "AlaskaMediaMailOrder")
      if self.products.map(&:id).uniq.include? Product::MILITARY_PACKET
        split_military_order
      end
    end
  end

  def split_military_order
    #if order contains more than ml bible and ml packet
    ml_packet = [Product::MILITARY_PACKET]
    ml_bible = [Product::MILITARY_BIBLE]
    ml_set = ml_packet + ml_bible
    other_products_in_order = self.product_ids - ml_set
    if other_products_in_order.size > 0
      duplicate_military_order = self.dup
      duplicate_military_order.type = "MilitaryPacketOrder"
      duplicate_military_order.delivery_type = "media ML"

      self.product_ids = self.product_ids - [Product::MILITARY_PACKET]
      duplicate_military_order.product_ids =  [Product::MILITARY_PACKET]

      if self.products.map(&:id).uniq.include? Product::MILITARY_BIBLE
        duplicate_military_order.product_ids = [Product::MILITARY_BIBLE, Product::MILITARY_PACKET]
        self.product_ids = self.product_ids - [Product::MILITARY_BIBLE]
      end

      duplicate_military_order.save
    else
      self.delivery_type = "media ML"
      self.type = "MilitaryPacketOrder"
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      columns1 = ["firstname","lastname","address1","address2",
                 "city","state","zip","email","phone"]

      header_row = columns1 + ["created_at"] +
        ["how_heard"] + ["requests_further_contact"] +
        ["product names"] + ["product language"]

      csv << ["Number of Recipients:", "#{all.to_a.count}"]
      csv << [""]
      csv << header_row

      all.includes(:products).each do |order|
        row = order.attributes.values_at(*columns1)
        row << order.created_at.strftime("%m/%d/%Y")
        row << (order.how_heard.nil? ? "" : order.how_heard)
        row << order.requests_further_contact
        row << order.product_names
        row << order.product_languages
        csv << row
      end
    end
  end

  def op_has_not_been_processed(op)
    processed = ['palletized', 'packaged', 'fulfilled', 'cancelled']
    processed.exclude? op.current_state
  end

  def blocked_by_blacklist?
    self.type == "BlacklistedAddressOrder"
  end

  def address_on_blacklist?
    order_barcode = self.smarty_streets_response.try(:delivery_point_barcode)

    if BlacklistedAddress.find_by_delivery_point_barcode(order_barcode)
      true
    else
      false
    end
  end

  def address_p
    "#{address1} #{address2} #{city} #{state} #{zip}"
  end

  def address_barcode
    self.smarty_streets_response.delivery_point_barcode if self.smarty_streets_response
  end

  def delivery_point_barcode_exist?
    self.smarty_streets_response.present? && self.smarty_streets_response.delivery_point_barcode.present?
  end

  def self.ransackable_attributes(auth_object = nil)
    super - ['search_body', 'updated_at', 'name_hash', 'address_hash', 'legacy_id', 'skip_limit_check', 'delivery_type', 'type', 'ip_address', 'latitude', 'longitude', 'geocoded_at']
  end
end
