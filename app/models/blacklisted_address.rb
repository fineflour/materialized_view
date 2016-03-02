class BlacklistedAddress < ActiveRecord::Base
  validates :delivery_point_barcode, presence: true
  validates :delivery_point_barcode, uniqueness: true
  belongs_to :order

  def append_note(note_text, entered_by)
  end
end
