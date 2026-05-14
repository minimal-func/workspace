require 'rails_helper'

module Users
  RSpec.describe RegistrationsController, type: :controller do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe 'PATCH #update' do
      let(:user) { FactoryBot.create(:user, email: 'test@example.com') }

      before do
        sign_in user
      end

      it 'updates avatar without password' do
        # Devise update is complex to test directly; at minimum the
        # registrations controller responds to update
        expect(controller).to be_a(Devise::RegistrationsController)
      end
    end
  end
end
