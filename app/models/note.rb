class Note < ActiveRecord::Base
  belongs_to :order, touch: true
  validates :content, :entered_by, presence: true

  def who_entered
    if self.entered_by.present?
      self.entered_by[/[^@]+/]
    else
      "N/A"
    end
  end
end
