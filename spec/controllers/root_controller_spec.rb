require 'rails_helper'

RSpec.describe RootController, type: :controller do
  describe 'GET #index' do
    context 'when signed in' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in user
      end

      it 'redirects to dashboards path' do
        get :index
        expect(response).to redirect_to(dashboards_path)
      end
    end

    context 'when not signed in' do
      it 'redirects to landing page' do
        get :index
        expect(response).to redirect_to(landing_path)
      end
    end
  end
end
