class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :day_ratings, dependent: :destroy
  has_many :energy_levels, dependent: :destroy
  has_many :moods, dependent: :destroy
  has_many :reflections, dependent: :destroy
  has_many :daily_lessons, dependent: :destroy
  has_many :daily_gratitudes, dependent: :destroy
  has_many :biggest_challenges, dependent: :destroy

  has_many :today_biggest_challenges, -> { today }, class_name: "BiggestChallenge", dependent: :destroy
  has_many :today_day_ratings, -> { today }, class_name: "DayRating", dependent: :destroy
  has_many :today_energy_levels, -> { today }, class_name: "EnergyLevel", dependent: :destroy
  has_many :today_moods, -> { today }, class_name: "Mood", dependent: :destroy
  has_many :today_reflections, -> { today }, class_name: "Reflection", dependent: :destroy
  has_many :today_daily_lessons, -> { today }, class_name: "DailyLesson", dependent: :destroy
  has_many :today_daily_gratitudes, -> { today }, class_name: "DailyGratitude", dependent: :destroy

  has_one :main_task

  has_many :projects

  # Gamification associations
  has_many :points, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements
  belongs_to :level, optional: true

  accepts_nested_attributes_for :today_day_ratings, allow_destroy: true
  accepts_nested_attributes_for :today_energy_levels, allow_destroy: true
  accepts_nested_attributes_for :today_moods, allow_destroy: true
  accepts_nested_attributes_for :today_reflections, allow_destroy: true
  accepts_nested_attributes_for :today_daily_lessons, allow_destroy: true
  accepts_nested_attributes_for :today_daily_gratitudes, allow_destroy: true
  accepts_nested_attributes_for :today_biggest_challenges, allow_destroy: true

  # Gamification methods
  def update_total_points
    update(total_points: points.sum(:value))
    update_level
    check_achievements
  end

  def update_level
    new_level = Level.for_points(total_points)
    update(level: new_level) if new_level && level != new_level
  end

  def check_achievements
    Achievement.where(achievement_type: 'points').each do |achievement|
      if total_points >= achievement.points_required && !achievements.include?(achievement)
        achievement.award_to(self)
      end
    end
  end

  def award_points(value, action, pointable = nil)
    points.create!(value: value, action: action, pointable: pointable)
  end

  def can_update_resource?(resource)
    return false unless resource&.project

    resource.project.user == self
  end
end
