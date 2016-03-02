class ImpbConfiguration < ActiveRecord::Base

  has_one :pallet

  validates :piece_start_number, presence: true
  validates :container_start_number, presence: true

  PIECE_INCREMENT_NUMBER = 1000 # large no. suggested by Lorton Data
  CONTAINER_INCREMENT_NUMBER = 200
  UNIQUENESS_DAYS = 60 # USPS requirement is 45 minimum

  # http://blog.dalethatcher.com/2008/03/rails-dont-override-initialize-on.html 
  def generate
    @cciic = current_cycle_initial_impb_configuration
    self.piece_start_number = calculate_piece_start_number
    self.container_start_number = calculate_container_start_number
    self.save
    self
  end

  def calculate_piece_start_number
    if @cciic.nil? || @cciic.created_at < ImpbConfiguration::UNIQUENESS_DAYS.days.ago
      ImpbConfiguration::PIECE_INCREMENT_NUMBER
    else
      impb = ImpbConfiguration.last
      impb.piece_start_number + ImpbConfiguration::PIECE_INCREMENT_NUMBER
    end
  end

  def calculate_container_start_number
    if @cciic.nil? || @cciic.created_at < ImpbConfiguration::UNIQUENESS_DAYS.days.ago
      ImpbConfiguration::CONTAINER_INCREMENT_NUMBER
    else
      impb = ImpbConfiguration.last
      impb.container_start_number + ImpbConfiguration::CONTAINER_INCREMENT_NUMBER
    end
  end

  private
  def current_cycle_initial_impb_configuration
    ImpbConfiguration
      .where(piece_start_number: ImpbConfiguration::PIECE_INCREMENT_NUMBER)
      .order(created_at: :desc).first
  end
end
