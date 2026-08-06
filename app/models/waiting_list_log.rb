class WaitingListLog < ApplicationRecord
  STATUSES = %w[pending approved declined].freeze

  belongs_to :invitation, optional: true
  belongs_to :reviewed_by, class_name: "AdminUser", optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
  scope :approved, -> { where(status: "approved") }
  scope :declined, -> { where(status: "declined") }

  def pending?
    status == "pending"
  end

  def approved?
    status == "approved"
  end

  def approve!(reviewer: nil)
    transaction do
      invite = Invitation.create!(email: email, inviter: nil)
      update!(status: "approved", invitation: invite, reviewed_by: reviewer)
      invite
    end
  end

  def reject!(reviewer: nil)
    update!(status: "declined", reviewed_by: reviewer)
  end
end