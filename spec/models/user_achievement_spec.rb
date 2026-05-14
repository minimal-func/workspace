require 'rails_helper'

RSpec.describe UserAchievement, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:achievement) }
  end

  describe "validations" do
    subject { FactoryBot.create(:user_achievement) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:achievement_id).with_message("has already earned this achievement") }
  end

  describe "callbacks" do
    it "sets earned_at before creation" do
      user_achievement = FactoryBot.create(:user_achievement)
      expect(user_achievement.earned_at).to be_present
    end

    it "does not overwrite existing earned_at" do
      time = 1.day.ago
      user_achievement = FactoryBot.create(:user_achievement, earned_at: time)
      expect(user_achievement.earned_at.to_i).to eq(time.to_i)
    end
  end
end
