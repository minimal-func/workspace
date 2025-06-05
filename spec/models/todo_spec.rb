require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end