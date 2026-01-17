require 'rails_helper'

RSpec.describe Material, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_one_attached(:file) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end
end