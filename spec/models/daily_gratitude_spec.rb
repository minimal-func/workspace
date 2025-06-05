require 'rails_helper'

RSpec.describe DailyGratitude, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "scopes" do
    describe "today" do
      before do
        Timecop.freeze(Time.local(2018, 1, 1, 10))
      end

      let!(:today_gratitude) { FactoryBot.create :daily_gratitude, created_at: Time.local(2018, 1, 1, 10) }
      let!(:yesterday_gratitude) { FactoryBot.create :daily_gratitude, created_at: Time.local(2017, 12, 31, 10) }

      it 'returns right values' do
        expect(DailyGratitude.today()).to eq([today_gratitude])
      end
    end
  end
end