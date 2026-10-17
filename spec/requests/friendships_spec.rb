require "rails_helper"

RSpec.describe "Friendships", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  before { sign_in user }

  it "sends a friend request and notifies the recipient" do
    expect {
      post friendships_path, params: { user_id: other_user.id }
    }.to change(Friendship, :count).by(1)

    friendship = Friendship.last
    expect(friendship).to be_pending
    expect(friendship.requester).to eq(user)
    expect(other_user.notifications.last.message).to include("sent you a friend request")
  end

  it "accepts an incoming request" do
    friendship = FactoryBot.create(:friendship, requester: other_user, addressee: user)

    patch accept_friendship_path(friendship)

    expect(friendship.reload).to be_accepted
    expect(user.friends).to include(other_user)
    expect(other_user.notifications.last.message).to include("accepted your friend request")
  end

  it "does not allow another user to accept a request" do
    friendship = FactoryBot.create(:friendship, requester: user, addressee: other_user)

    patch accept_friendship_path(friendship)

    expect(response).to redirect_to(friendships_path)
    expect(friendship.reload).to be_pending
  end
end
