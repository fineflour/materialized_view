class Pallet < ActiveRecord::Base
  has_many :orderproducts
  has_many :products, through: :orderproducts
  belongs_to :impb_configuration
  belongs_to :mailing_configuration
  has_many :materials, through: :products

  default_scope { order("pallets.created_at DESC") }

  scope :shipped, -> {where(status: :shipped)}
  scope :within_year, -> {where("pallets.created_at > ?", 1.year.ago)}
  scope :within_year, -> {where("pallets.created_at > ?", 1.year.ago)}
  scope :within_six_months, -> {where("pallets.created_at > ?", 6.months.ago)}
  scope :within_three_months, -> {where("pallets.created_at > ?", 3.months.ago)}
  scope :within_60_days, -> {where("pallets.created_at > ?", 60.days.ago)}
  scope :after_shipped_date, -> (afterdate) { where("pallets.shipped_at > ?", afterdate) }

  after_destroy :delete_impb_config

  #Class scopes
  def self.east
    joins(:mailing_configuration).
      where("mailing_configurations.distribution" => 'East')
  end

  def self.west
    joins(:mailing_configuration).
      where("mailing_configurations.distribution" => 'West')
  end

  def self.irvine
    joins(:mailing_configuration).
      where("mailing_configurations.distribution" => 'Irvine')
  end

  def self.alaska
    joins(:mailing_configuration).
      where("mailing_configurations.distribution" => 'Alaska')
  end

  def self.military
    joins(:mailing_configuration).
      where("mailing_configurations.distribution" => 'Military')
  end

  def generate
    PalletGenerator.new(self).generate_pallet
  end

  def size
    orderproducts.count
  end

  # @todo: what should this function return when pallet contains multiple product (types)?
  # our original intention in doing this is that all pallets would only have 1 product type
  def product
    orderproducts.first.product
  end

  def product_kind
    orderproducts.first.kind
  end

  def prepare_csv(*args)
    objects_to_extract_address_data = self.orderproducts
    objects_to_extract_address_data = args[0] unless args[0].nil?
    if self.mailing_configuration.media?
      op_order_ids = objects_to_extract_address_data.map(&:order_id).uniq
      objects_to_extract_address_data = Order.find(op_order_ids)
    end

    # Using Windows line endings ("\r\n") b/c of a-qua mailer desktop
    csv_address_data = csv_header + "\r\n"

    objects_to_extract_address_data.each do |o|
      # Using Windows line endings("\r\n") b/c of a-qua mailer desktop
      csv_address_data += Csv_Formatter.new(o).format + "\r\n"
    end

    update_attributes(address_label_data: csv_address_data)
  end

  def csv_filename
    name = "p#{id}_#{size}"
    name.gsub!(/\./,'')
    name.gsub!(/[\W&&[^-]]/,'_')
    name + '.csv'
  end

  def shipped_at_string
    if shipped_at.nil?
      "Not Shipped"
    else
      shipped_at.strftime("%m/%d/%Y %l:%M %p")
    end
  end

  def mark_shipped
    self.status = 'shipped'
    self.shipped_at = Time.now
    self.save
    self.delay(priority: 2).change_state_and_email_recipients
  end

  def unpalletize
    self.delay(priority: 0).update_orderproducts_for_unpalletize
  end

  private

  def update_orderproducts_for_unpalletize
    orderproducts.each do |op|
      op.state_machine.trigger!(:unpalletize)
      op.update_attributes(pallet_id: nil)
    end
    destroy
  end

  def change_state_and_email_recipients
    orderproducts.each do |op|
      op.state_machine.trigger!(:fulfill)
    end
    email_recipients
  end

  def email_recipients
    orderproducts.each do |op|
      if op.order.all_orderproducts_fulfilled?
        CustomerMailer.delay.shipped_confirmation(op) unless op.order.email.blank?
      end
    end
  end

  def csv_header
    %w(Fname Lname Address Address2 City State Zip Lang Kind)
      .join(MailingConfiguration::CSV_FILE_DELIMITER)
  end

  def delete_impb_config
    if mailing_configuration.kind == 'RcV'
      impb_configuration.delete
    end
  end
end
