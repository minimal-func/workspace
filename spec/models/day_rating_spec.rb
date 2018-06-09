require 'rails_helper'

RSpec.describe DayRating, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_inclusion_of(:value).in_range(1..10) }
  end

  describe "scopes" do
    describe "today" do
      before do
        Timecop.freeze(Time.local(2018, 1, 1, 10))
      end

      let!(:today_day_rating) { create :day_rating, created_at: Time.local(2018, 1, 1, 10) }
      let!(:yesterday_day_rating) { create :day_rating, created_at: Time.local(2018, 1, 2, 10) }

      it 'returns right values' do
        expect(DayRating.today()).to eq([today_day_rating])
      end
    end
  end
end
