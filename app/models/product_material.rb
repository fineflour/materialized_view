class ProductMaterial < ActiveRecord::Base
  belongs_to :product
  belongs_to :material
  validates_uniqueness_of :material_id, :scope => :product_id
end
