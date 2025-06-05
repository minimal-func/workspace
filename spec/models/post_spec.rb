require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_rich_text(:content) }
    it { is_expected.to have_one_attached(:featured_image) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:short_description) }
    it { is_expected.to validate_presence_of(:title) }
  end
end