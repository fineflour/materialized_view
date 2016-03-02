class Material < ActiveRecord::Base
  include ProductMaterialDetails
  include Language

  has_paper_trail on: [:update, :create], ignore: [:updated_at]

  has_many :products, through: :product_materials
  has_many :product_materials
  has_many :inventory_adjustments
  has_many :orderproducts, through: :products
  has_many :pallets, -> { distinct }, through: :products

  validates_presence_of :name
  validates_presence_of :shortname
  validates :language, inclusion:
    { in: Material::LANGUAGE_NAMES, message: "- Select a language" }
  validates :censused_at, presence: true, unless: 'census_quantity.blank?'

  scope :active, -> { where active: true }
  scope :sorted, -> { order language: :asc, shortname: :asc }
  scope :ordered_name, -> { order name: asc }

  scope :having_60_day_velocity, -> { where("velocity_60_day > ?", 60) }
  scope :having_no_60_day_velocity, -> { where(velocity_60_day: 0) }

  def sum_of_inventory_adjustments_since_census
    inventory_adjustments.where("created_at > ?", self.censused_at).sum(:quantity)
  end

  def self.grouped_by_language
    groups = []
    languages = Material.uniq.pluck(:language)
    languages.each do |lang|
      groups << [lang, Material.active.where(language:lang).all.sort_by(&:name)]
      end
    return groups.sort_by{|k, v| k}
  end

  def total_shipped_since_census
    shipped_pallets = self.pallets.shipped.after_shipped_date(self.censused_at.to_date)
    @outbound_materials_since_census = 0
    shipped_pallets.each do |sp|
      @outbound_materials_since_census += sp.materials.where(id: self.id).size
    end
    @outbound_materials_since_census
  end

  def self.retrieve_all_material_ids
    Material.pluck(:id).sort
  end

  def name_with_language
    "#{name} (#{language})"
  end

end
