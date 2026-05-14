require 'rails_helper'

RSpec.describe ReflectionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns paginated reflections' do
      FactoryBot.create_list(:reflection, 3, user: user)
      get :index
      expect(assigns(:reflections).size).to eq(3)
    end
  end
end
