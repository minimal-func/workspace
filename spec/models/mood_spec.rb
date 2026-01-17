require 'rails_helper'

RSpec.describe Mood, type: :model do
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

      let!(:today_mood) { FactoryBot.create :mood, created_at: Time.local(2018, 1, 1, 10) }
      let!(:yesterday_mood) { FactoryBot.create :mood, created_at: Time.local(2017, 12, 31, 10) }

      it 'returns right values' do
        expect(Mood.today()).to eq([today_mood])
      end
    end
  end
end