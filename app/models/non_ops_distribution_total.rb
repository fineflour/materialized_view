class NonOPSDistributionTotal < ActiveRecord::Base
  # This is the model for the number section in the BfA main page
  # Sum of the total number of Books and bibles including off-line distribution and OMS Legacy system.
  PRODUCT_LIST =[["Bible", "1"], ["Book", "0"]]
  BOOK_IDS=[42,44,47,48,49,50, 52,53,54,55,57,60,61,62]
  BOOK_PAIR_IDS=[55, 64, 58, 65]
  BOOK_TRIO_IDS=[ 51, 46, 61, 63, 66]
  RCV_IDS=[1, 2, 56, 59]
  FIRST_OPS_ORDER = 127975
  FIRST_OPS_PALLET = 1740


  validates :total, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates :product, presence: true, inclusion:
    { :in => [0, 1], message: "- Select a product type" }

  #  def initialize
  #    @totals = {}
  #  end

  def self.rcv_total                                            
    ops_rcv_total + non_ops_rcv_total
  end                                                                                                                             
  def self.book_total
    ops_book_total + non_ops_book_total
  end   

  def self.ops_rcv_total                                                       
    Orderproduct.select(:id).where(:product_id => NonOPSDistributionTotal::RCV_IDS, current_state: 'fulfilled').where("id > ?", FIRST_OPS_ORDER).where("pallet_id > ?", FIRST_OPS_PALLET).count 
  end                                                                                                                             

  def self.ops_book_total
    Orderproduct.select(:id).where(:product_id => NonOPSDistributionTotal::BOOK_IDS, current_state: 'fulfilled').where("id > ?", FIRST_OPS_ORDER).where("pallet_id > ?", FIRST_OPS_PALLET).count +
      Orderproduct.select(:id).where(:product_id => NonOPSDistributionTotal::BOOK_PAIR_IDS, current_state: 'fulfilled').where("id > ?", FIRST_OPS_ORDER).where("pallet_id > ?", FIRST_OPS_PALLET).count*2 +
      Orderproduct.select(:id).where(:product_id => NonOPSDistributionTotal::BOOK_TRIO_IDS, current_state: 'fulfilled').where("id > ?", FIRST_OPS_ORDER).where("pallet_id > ?", FIRST_OPS_PALLET).count*3 
  end 

  def self.non_ops_rcv_total                     
    NonOPSDistributionTotal.where(product:1).sum(:total)  
  end                                                                                                                             

  def self.non_ops_book_total
    NonOPSDistributionTotal.where(product:0).sum(:total)  
  end

  def self.get_total_numbers
    @totals = {:rcv_total => rcv_total, :book_total => book_total} 
  end
end
