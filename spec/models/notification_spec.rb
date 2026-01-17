require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:notifiable).optional }
  end

  describe "scopes" do
    let(:user) { FactoryBot.create(:user) }
    let!(:read_notification) { FactoryBot.create(:notification, user: user, read_at: Time.current) }
    let!(:unread_notification) { FactoryBot.create(:notification, user: user, read_at: nil) }

    describe ".unread" do
      it "returns only unread notifications" do
        expect(Notification.unread).to include(unread_notification)
        expect(Notification.unread).not_to include(read_notification)
      end
    end
  end

  describe "#mark_as_read!" do
    let(:notification) { FactoryBot.create(:notification, read_at: nil) }

    it "sets read_at to current time" do
      expect { notification.mark_as_read! }.to change { notification.read_at }.from(nil)
    end
  end
end
