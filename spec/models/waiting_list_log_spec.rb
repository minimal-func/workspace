require 'rails_helper'

RSpec.describe WaitingListLog, type: :model do
  let(:admin) { AdminUser.create!(email: "reviewer@example.com", password: "password") }

describe "validations" do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_inclusion_of(:status).in_array(WaitingListLog::STATUSES) }

    it "rejects a duplicate email" do
      WaitingListLog.create!(email: "dupe@example.com")
      expect(WaitingListLog.new(email: "dupe@example.com")).not_to be_valid
    end

    it "rejects an invalid email" do
      expect(WaitingListLog.new(email: "nope")).not_to be_valid
    end
  end

  describe "#approve!" do
    it "creates an invitation and marks the entry approved" do
      log = WaitingListLog.create!(email: "approve@example.com")

      invitation = log.approve!(reviewer: admin)

      expect(log.reload).to be_approved
      expect(log.reviewed_by).to eq(admin)
      expect(log.invitation).to eq(invitation)
      expect(invitation.email).to eq("approve@example.com")
      expect(invitation.token).to be_present
      expect(invitation.accepted?).to be false
    end
  end

  context "reject!" do
    it "marks the entry rejected and records the reviewer" do
      log = WaitingListLog.create!(email: "reject@example.com")

      log.reject!(reviewer: admin)

      expect(log.reload.status).to eq("declined")
      expect(log.reviewed_by).to eq(admin)
      expect(log.invitation).to be_nil
    end
  end
end