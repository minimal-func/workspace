require 'rails_helper'

RSpec.describe Point, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "notifications" do
    it "creates a notification when points are awarded" do
      expect {
        user.award_points(50, "create_project")
      }.to change { user.notifications.count }.by(1)

      notification = user.notifications.last
      expect(notification.message).to include("50 points")
      expect(notification.message).to include("create project")
    end
  end
end
