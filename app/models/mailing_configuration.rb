class MailingConfiguration < ActiveRecord::Base
  DC_NAMES = ["East", "West", "Irvine", "Open", "Alaska", "Military"]
  CSV_FILE_DELIMITER = "|"

  has_many :products
  has_many :pallets
  has_many :orderproducts, through: :products
  has_many :orders, through: :orderproducts

  validates :kind, uniqueness: true
  validates :minimum_size, presence: true
  validates :maximum_size, presence: true
  validates :weight, presence: true
  validates :distribution, inclusion: { in: MailingConfiguration::DC_NAMES, message: "%{value} is not a valid distribution center" }
  validates :max_address_line_length, presence: true
  validates :label_model_number, presence: true

  after_create :add_mailing_configuration_to_products_of_same_kind
  after_destroy :remove_mailing_configuration_from_products_of_same_kind

  scope :east, -> {where distribution: "East"}
  scope :west, -> {where distribution: "West"}

  def enough_orderproducts_to_create_pallet?
    Orderproduct.palletizable_by_mailing_configuration(self)
      .size >= minimum_size
  end

  def pallet_processing?
    if  pallets.find_by_status('processing')
      return true
    else
      return false
    end
  end

  def media?
    kind.split[0] == "Media"
  end

  private

  def add_mailing_configuration_to_products_of_same_kind
    Product.set_mailing_configuration(self)
  end

  def remove_mailing_configuration_from_products_of_same_kind
    Product.remove_mailing_configuration(self)
  end
end
