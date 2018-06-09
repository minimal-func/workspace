require 'rails_helper'

RSpec.describe Reflection, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "scopes" do
    describe "today" do
      before do
        Timecop.freeze(Time.local(2018, 1, 1, 10))
      end

      let!(:today_reflection) { create :reflection, created_at: Time.local(2018, 1, 1, 10) }
      let!(:yesterday_reflection) { create :reflection, created_at: Time.local(2018, 1, 2, 10) }

      it 'returns right values' do
        expect(Reflection.today()).to eq([today_reflection])
      end
    end
  end
end
