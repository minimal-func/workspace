require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated notifications' do
      FactoryBot.create_list(:notification, 3, user: user)
      get :index
      expect(assigns(:notifications).size).to eq(3)
    end
  end

  describe 'PATCH #update' do
    let(:notification) { FactoryBot.create(:notification, user: user, read_at: nil) }

    it 'marks notification as read' do
      patch :update, params: { id: notification.id }
      expect(notification.reload.read_at).to be_present
    end

    it 'redirects back' do
      patch :update, params: { id: notification.id }
      expect(response).to redirect_to(notifications_path)
    end
  end
end
