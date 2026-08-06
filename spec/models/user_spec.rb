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
 
  describe '#project_feature_unlocked?' do
    let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }
    let!(:level3) { FactoryBot.create(:level, level_number: 3, points_required: 300, name: 'Enthusiast') }
    let(:user) { FactoryBot.create(:user, level: level1, total_points: 0) }
 
    it 'unlocks time tracker at level 1' do
      expect(user.project_feature_unlocked?(:timetracker)).to be true
    end

    it 'does not unlock posts until level 3' do
      expect(user.project_feature_unlocked?(:posts)).to be false
    end

    it 'unlocks posts at level 3' do
      user.update(level: level3, total_points: 300)
      expect(user.project_feature_unlocked?(:posts)).to be true
    end
  end

  describe 'feature purchases' do
    let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0, name: 'Beginner') }
    let(:user) { FactoryBot.create(:user, level: level1) }

    before do
      FactoryBot.create(:point, user: user, value: 300, action: 'initial_bonus')
      user.reload
    end

    it 'allows purchasing a feature when the user has enough points' do
      expect(user.can_purchase_feature?(:posts)).to be true
      user.purchase_feature!(:posts)

      expect(user.purchased_feature?(:posts)).to be true
      expect(user.feature_unlocked?(:posts)).to be true
      expect(user.total_points).to eq(50)
    end

    it 'does not allow purchasing a feature the user already unlocked by level' do
      level3 = FactoryBot.create(:level, level_number: 3, points_required: 300, name: 'Enthusiast')
      user.update(level: level3, total_points: 300)

      expect(user.can_purchase_feature?(:posts)).to be false
    end
  end
end
