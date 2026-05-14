require 'rails_helper'

RSpec.describe EnergyLevelsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated energy levels' do
      FactoryBot.create_list(:energy_level, 3, user: user)
      get :index
      expect(assigns(:energy_levels).size).to eq(3)
    end
  end
end
