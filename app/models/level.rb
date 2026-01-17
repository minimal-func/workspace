class Level < ApplicationRecord
  has_many :users

  validates :level_number, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  validates :points_required, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true

  # Find the appropriate level for a given number of points
  def self.for_points(points)
    where('points_required <= ?', points).order(points_required: :desc).first
  end

  # Get the next level
  def next_level
    Level.find_by(level_number: level_number + 1)
  end

  # Calculate points needed for next level
  def points_to_next_level(current_points)
    next_lvl = next_level
    return 0 unless next_lvl
    
    [next_lvl.points_required - current_points, 0].max
  end
end