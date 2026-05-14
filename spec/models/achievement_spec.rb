require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:user_achievements).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_achievements) }
  end

  describe "validations" do
    subject { FactoryBot.create(:achievement) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_numericality_of(:points_required).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:threshold).is_greater_than(0) }
  end

  describe "constants" do
    it "defines achievement types" do
      expect(Achievement::TYPES).to include(
        points: 'points',
        tasks_completed: 'tasks_completed',
        posts_created: 'posts_created'
      )
    end
  end

  describe "#earned_by?" do
    let(:user) { FactoryBot.create(:user) }
    let(:achievement) { FactoryBot.create(:achievement) }

    it "returns true if user has earned the achievement" do
      FactoryBot.create(:user_achievement, user: user, achievement: achievement)
      expect(achievement.earned_by?(user)).to be true
    end

    it "returns false if user has not earned the achievement" do
      expect(achievement.earned_by?(user)).to be false
    end
  end

  describe "#award_to" do
    let(:user) { FactoryBot.create(:user) }
    let(:achievement) { FactoryBot.create(:achievement) }

    it "creates a user_achievement record" do
      expect {
        achievement.award_to(user)
      }.to change { UserAchievement.count }.by(1)
    end

    it "creates a notification" do
      expect {
        achievement.award_to(user)
      }.to change { Notification.count }.by(1)
    end

    it "does not award twice" do
      achievement.award_to(user)
      expect {
        achievement.award_to(user)
      }.not_to change { UserAchievement.count }
    end
  end
end
