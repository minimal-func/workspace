require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  describe 'GET #index' do
    context 'when signed in' do
      let(:user) { FactoryBot.create(:user) }

      before do
        sign_in user
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns @app_title' do
        get :index
        expect(assigns(:app_title)).to eq('Personal Productivity')
      end
    end

    context 'when not signed in' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns @app_title' do
        get :index
        expect(assigns(:app_title)).to eq('Personal Productivity')
      end
    end
  end

  describe 'GET #help' do
    it 'returns a success response' do
      get :help
      expect(response).to be_successful
    end

    it 'assigns @app_title' do
      get :help
      expect(assigns(:app_title)).to eq('Help')
    end
  end
end
