class DistributionCenter < ActiveRecord::Base
  validates :name, presence: true
end
