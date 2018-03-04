class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :day_ratings, dependent: :destroy
  has_many :reflections, dependent: :destroy
  has_many :daily_lessons, dependent: :destroy
  has_many :biggest_challenges, dependent: :destroy

  has_many :today_biggest_challenges, -> { today }, class_name: "BiggestChallenge", dependent: :destroy
  has_many :today_day_ratings, -> { today }, class_name: "DayRating", dependent: :destroy
  has_many :today_reflections, -> { today }, class_name: "Reflection", dependent: :destroy
  has_many :today_daily_lessons, -> { today }, class_name: "DailyLesson", dependent: :destroy

  def today_biggest_challenges=(value)
    if today_biggest_challenges.size.empty?
      biggest_challenges.create(value)
    else
      raise ActiveRecord::Rollback, "BiggestChallenge already created!"
    end
  end

  def today_day_ratings=(value)
    if today_day_ratings.size.empty?
      day_ratings.create(value)
    else
      raise ActiveRecord::Rollback, "BiggestChallenge already created!"
    end
  end

  def today_reflections=(value)
    if today_reflections.size.empty?
      reflections.create(value)
    else
      raise ActiveRecord::Rollback, "BiggestChallenge already created!"
    end
  end

  def today_daily_lessons=(value)
    if today_daily_lessons.size.empty?
      daily_lessons.create(value)
    else
      raise ActiveRecord::Rollback, "BiggestChallenge already created!"
    end
  end

  accepts_nested_attributes_for :today_day_ratings, allow_destroy: true
  accepts_nested_attributes_for :today_reflections, allow_destroy: true
  accepts_nested_attributes_for :today_daily_lessons, allow_destroy: true
  accepts_nested_attributes_for :today_biggest_challenges, allow_destroy: true
end
