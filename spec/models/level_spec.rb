require 'rails_helper'

RSpec.describe Level, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:users) }
  end

  describe "validations" do
    subject { FactoryBot.create(:level) }
    it { is_expected.to validate_presence_of(:level_number) }
    it { is_expected.to validate_uniqueness_of(:level_number) }
    it { is_expected.to validate_numericality_of(:level_number).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:points_required) }
    it { is_expected.to validate_numericality_of(:points_required).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe ".for_points" do
    let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0) }
    let!(:level2) { FactoryBot.create(:level, level_number: 2, points_required: 100) }
    let!(:level3) { FactoryBot.create(:level, level_number: 3, points_required: 500) }

    it "returns the appropriate level for given points" do
      expect(Level.for_points(0)).to eq(level1)
      expect(Level.for_points(50)).to eq(level1)
      expect(Level.for_points(100)).to eq(level2)
      expect(Level.for_points(250)).to eq(level2)
      expect(Level.for_points(500)).to eq(level3)
      expect(Level.for_points(1000)).to eq(level3)
    end
  end

  describe "#next_level" do
    let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0) }
    let!(:level2) { FactoryBot.create(:level, level_number: 2, points_required: 100) }

    it "returns the next level" do
      expect(level1.next_level).to eq(level2)
    end

    it "returns nil if no next level" do
      expect(level2.next_level).to be_nil
    end
  end

  describe "#points_to_next_level" do
    let!(:level1) { FactoryBot.create(:level, level_number: 1, points_required: 0) }
    let!(:level2) { FactoryBot.create(:level, level_number: 2, points_required: 100) }

    it "calculates points needed to reach next level" do
      expect(level1.points_to_next_level(0)).to eq(100)
      expect(level1.points_to_next_level(50)).to eq(50)
      expect(level1.points_to_next_level(100)).to eq(0)
    end

    it "returns 0 if at max level" do
      expect(level2.points_to_next_level(0)).to eq(0)
    end
  end
end
