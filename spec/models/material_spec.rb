require 'rails_helper'

RSpec.describe Material, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_one_attached(:file) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "file size limit" do
    let(:material) { build(:material) }

    def attach_file(byte_size)
      material.file.attach(io: StringIO.new("x" * byte_size), filename: "test.txt", content_type: "text/plain")
    end

    it "rejects files larger than 10MB" do
      attach_file(11.megabytes)
      expect(material).to be_invalid
      expect(material.errors[:file]).to include("must be smaller than 10MB")
    end

    it "accepts files up to 10MB" do
      attach_file(10.megabytes)
      expect(material).to be_valid
    end
  end
end