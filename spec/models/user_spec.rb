require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:day_ratings) }
    it { is_expected.to have_many(:energy_levels) }
    it { is_expected.to have_many(:reflections) }
    it { is_expected.to have_many(:daily_lessons) }
    it { is_expected.to have_many(:biggest_challenges) }
    it { is_expected.to have_one(:main_task) }

    it { is_expected.to have_many(:today_biggest_challenges) }
    it { is_expected.to have_many(:today_day_ratings) }
    it { is_expected.to have_many(:today_energy_levels) }
    it { is_expected.to have_many(:today_reflections) }
    it { is_expected.to have_many(:today_daily_lessons) }


    describe "today associations" do
      before do
        Timecop.freeze(Time.local(2018, 1, 1, 10))
      end

      let(:user) { FactoryBot.create :user }
      let(:another_user) { FactoryBot.create :user }

      let!(:today_energy_level) { FactoryBot.create :energy_level, user: user, created_at: Time.local(2018, 1, 1, 10) }
      let!(:yesterday_energy_level) { FactoryBot.create :energy_level, user: user, created_at: Time.local(2018, 1, 2, 10) }
      let!(:another_energy_level) { FactoryBot.create :energy_level, user: another_user, created_at: Time.local(2018, 1, 1, 10) }

      it 'returns today objects' do
        expect(user.today_energy_levels).to eq([today_energy_level])
      end
    end
  end
  describe "gamification" do
    let(:user) { FactoryBot.create :user }

    it "creates a notification when a user levels up" do
      level1 = FactoryBot.create(:level, level_number: 1, points_required: 0, name: "Beginner")
      FactoryBot.create(:level, level_number: 2, points_required: 100, name: "Novice")
      
      user.update(level: level1, total_points: 0)

      expect {
        user.award_points(100, "large_bonus")
      }.to change { user.notifications.count }.by(2) # 1 for points, 1 for level up

      level_notification = user.notifications.find_by("message LIKE ?", "%reached Level 2%")
      expect(level_notification).to be_present
      expect(level_notification.message).to include("Novice")
    end
  end
end
