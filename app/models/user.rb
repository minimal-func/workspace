class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :day_ratings, dependent: :destroy
  has_many :energy_levels, dependent: :destroy
  has_many :reflections, dependent: :destroy
  has_many :daily_lessons, dependent: :destroy
  has_many :biggest_challenges, dependent: :destroy

  has_many :today_biggest_challenges, -> { today }, class_name: "BiggestChallenge", dependent: :destroy
  has_many :today_day_ratings, -> { today }, class_name: "DayRating", dependent: :destroy
  has_many :today_energy_levels, -> { today }, class_name: "EnergyLevel", dependent: :destroy
  has_many :today_reflections, -> { today }, class_name: "Reflection", dependent: :destroy
  has_many :today_daily_lessons, -> { today }, class_name: "DailyLesson", dependent: :destroy

  has_one :main_task

  has_many :projects

  accepts_nested_attributes_for :today_day_ratings, allow_destroy: true
  accepts_nested_attributes_for :today_energy_levels, allow_destroy: true
  accepts_nested_attributes_for :today_reflections, allow_destroy: true
  accepts_nested_attributes_for :today_daily_lessons, allow_destroy: true
  accepts_nested_attributes_for :today_biggest_challenges, allow_destroy: true

  has_many :topic_subscriptions, class_name: 'Wiki::TopicSubscription', foreign_key: 'wiki_topic_id'
  has_many :topics, through: :topic_subscriptions, class_name: 'Wiki::Topic'

  has_many :concept_learnings, class_name: 'Wiki::ConceptLearning', foreign_key: 'wiki_concept_id'
  has_many :concepts, through: :concept_learnings, class_name: 'Wiki::Concept'

  has_many :created_topics, class_name: 'Wiki::Topic', foreign_key: :created_by

  def topic_creator?(topic)
    topic.created_by == id
  end

  def subscribed?(topic)
    topic_subscriptions.where(topic: topic).present?
  end

  def learned?(concept)
    concept_learnings.where(concept: concept).present?
  end
end
