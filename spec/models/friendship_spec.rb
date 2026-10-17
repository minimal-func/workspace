require "rails_helper"

RSpec.describe Friendship, type: :model do
  it "does not allow a user to send themselves a friend request" do
    user = FactoryBot.create(:user)

    friendship = described_class.new(requester: user, addressee: user)

    expect(friendship).not_to be_valid
    expect(friendship.errors[:addressee]).to include("can't be yourself")
  end

  it "does not allow duplicate requests in either direction" do
    requester = FactoryBot.create(:user)
    addressee = FactoryBot.create(:user)
    described_class.create!(requester: requester, addressee: addressee)

    reverse_request = described_class.new(requester: addressee, addressee: requester)

    expect(reverse_request).not_to be_valid
  end
end
