class InventoryAdjustment < ActiveRecord::Base
  include PgSearch

  belongs_to :material
  belongs_to :user
  validates :material_id, :quantity, :description, presence: true
  validates :quantity, numericality: { only_integer: true }

  pg_search_scope :search, against: [:product_id, :notes], :associated_against => { :product => [:name, :shortname, :language]
  }

  def self.text_search(query)
    if query
      search(query)
    else
      InventoryAdjustment.all
    end
  end



  def self.total_since_census(material)
    material.inventory_adjustments.where("created_at > ?", material.censused_at).sum(:quantity)
  end

  def self.total_for(material)
    material.inventory_adjustments.sum(:quantity)
  end
end
