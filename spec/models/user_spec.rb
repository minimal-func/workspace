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
end
