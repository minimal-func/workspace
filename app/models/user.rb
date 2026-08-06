class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one_attached :avatar
 
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "inviter_id", dependent: :destroy
  has_many :received_invitations, class_name: "Invitation", foreign_key: "accepted_user_id", dependent: :nullify
 
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
  has_many :notifications, dependent: :destroy

  # Gamification associations
  has_many :points, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements
  belongs_to :level, optional: true

  def self.ransackable_associations(_auth_object = nil)
    ["achievements", "avatar_attachment", "avatar_blob", "biggest_challenges", "daily_gratitudes", "daily_lessons", "day_ratings", "energy_levels", "level", "main_task", "moods", "notifications", "points", "projects", "received_invitations", "reflections", "sent_invitations", "today_biggest_challenges", "today_daily_gratitudes", "today_daily_lessons", "today_day_ratings", "today_energy_levels", "today_moods", "today_reflections", "user_achievements"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "current_sign_in_at", "email", "id", "id_value", "last_sign_in_at", "level_id", "purchased_features", "remember_created_at", "sign_in_count", "total_points", "updated_at"]
  end

  FEATURE_UNLOCKS = {
    timetracker: { name: 'Time Tracker', level: 1, cost: 0 },
    todos: { name: 'Tasks', level: 2, cost: 150 },
    saved_links: { name: 'Saved Links', level: 3, cost: 450 },
    posts: { name: 'Posts', level: 4, cost: 250 },
    knowledge: { name: 'Knowledge', level: 5, cost: 350 },
    materials: { name: 'Materials', level: 6, cost: 350 }
  }.freeze

  def self.feature_unlocks
    FEATURE_UNLOCKS
  end

  def self.feature_unlocks_sorted
    feature_unlocks.sort_by { |_feature, info| info[:level] }.to_h
  end

  def self.feature_name(feature)
    feature_unlocks.fetch(feature.to_sym)[:name]
  end

  def self.feature_unlock_level(feature)
    feature_unlocks.fetch(feature.to_sym)[:level]
  end

  def self.feature_purchase_cost(feature)
    feature_unlocks.fetch(feature.to_sym)[:cost]
  end

  def self.project_feature_unlocks
    feature_unlocks.except(:knowledge)
  end

  def self.project_feature_unlocks_sorted
    project_feature_unlocks.sort_by { |_feature, info| info[:level] }.to_h
  end

  def self.project_feature_name(feature)
    feature_name(feature)
  end

  def self.project_feature_unlock_level(feature)
    feature_unlock_level(feature)
  end

  def current_level_number
    return level.level_number if level
    Level.for_points(total_points || 0)&.level_number || 0
  end

  def feature_unlocked?(feature)
    current_level_number >= self.class.feature_unlock_level(feature) || purchased_feature?(feature)
  end

  def project_feature_unlocked?(feature)
    feature_unlocked?(feature)
  end

  def feature_purchase_cost(feature)
    self.class.feature_purchase_cost(feature)
  end

  def purchased_feature?(feature)
    Array(purchased_features).map(&:to_s).include?(feature.to_s)
  end

  def can_purchase_feature?(feature)
    return false unless self.class.feature_unlocks.key?(feature.to_sym)
    return false if feature_unlocked?(feature)

    total_points.to_i >= feature_purchase_cost(feature).to_i
  end

  def purchase_feature!(feature)
    cost = feature_purchase_cost(feature)
    raise ArgumentError, "Invalid feature" unless cost
    raise StandardError, "Cannot purchase #{feature}" unless can_purchase_feature?(feature)

    transaction do
      award_points(-cost, "purchase_#{feature}")
      update!(purchased_features: (Array(purchased_features) + [feature.to_s]).uniq)
    end
  end

  accepts_nested_attributes_for :today_day_ratings, allow_destroy: true
  accepts_nested_attributes_for :today_energy_levels, allow_destroy: true
  accepts_nested_attributes_for :today_moods, allow_destroy: true
  accepts_nested_attributes_for :today_reflections, allow_destroy: true
  accepts_nested_attributes_for :today_daily_lessons, allow_destroy: true
  accepts_nested_attributes_for :today_daily_gratitudes, allow_destroy: true
  accepts_nested_attributes_for :today_biggest_challenges, allow_destroy: true

  validate :avatar_is_an_image
  validate :avatar_size_within_limit

  # Gamification methods
  def update_total_points
    update(total_points: points.sum(:value))
    update_level
    check_achievements
  end

  def update_level
    new_level = Level.for_points(total_points)
    if new_level && level != new_level
      update(level: new_level)
      notifications.create!(
        message: "Congratulations! You've reached Level #{new_level.level_number}: #{new_level.name}!",
        notifiable: new_level
      )
    end
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
    project = if resource.is_a?(Project)
                resource
              else
                resource.project
              end

    return false unless project

   project.user == self
  end

  private

  def avatar_is_an_image
    return unless avatar.attached?
    return if avatar.blob.content_type&.start_with?("image/")

    errors.add(:avatar, "must be an image")
  end

  def avatar_size_within_limit
    return unless avatar.attached?
    return if avatar.blob.byte_size <= 5.megabytes

    errors.add(:avatar, "must be smaller than 5MB")
  end
end
