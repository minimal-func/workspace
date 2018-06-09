require 'rails_helper'

RSpec.describe DailyLesson, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "scopes" do
    describe "today" do
      before do
        Timecop.freeze(Time.local(2018, 1, 1, 10))
      end

      let!(:today_daily_lesson) { create :daily_lesson, created_at: Time.local(2018, 1, 1, 10) }
      let!(:yesterday_daily_lesson) { create :daily_lesson, created_at: Time.local(2018, 1, 2, 10) }

      it 'returns right values' do
        expect(DailyLesson.today()).to eq([today_daily_lesson])
      end
    end
  end
end
