require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
  end
end