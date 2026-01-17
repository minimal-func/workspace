require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:notification) { FactoryBot.create(:notification, user: user) }

  before do
    sign_in user
  end

  describe "GET /notifications" do
    it "returns http success" do
      get notifications_path
      expect(response).to have_http_status(:success)
    end

    it "displays 'No new notifications' when there are none" do
      get notifications_path
      expect(response.body).to include("No new notifications")
    end
  end

  describe "PATCH /notifications/:id" do
    it "marks notification as read" do
      patch notification_path(notification)
      expect(notification.reload.read?).to be true
      expect(response).to redirect_to(notifications_path)
    end
  end
end
