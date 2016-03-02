class Report < ActiveRecord::Base
  def display_state
    if self.state.present?
      self.state
    else
      "No state specified"
    end
  end

  def display_cities
    if self.cities.present?
      self.cities
    else
      "No cities specified"
    end
  end
end
