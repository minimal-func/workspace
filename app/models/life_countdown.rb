class LifeCountdown < ApplicationRecord
  belongs_to :user

  def calculate_final_date
    Date.today + years_left.years
  end

  def years_lived
    (Date.today - born_in).to_i / 365
  end

  def years_left
    planned_years - years_lived
  end
end
