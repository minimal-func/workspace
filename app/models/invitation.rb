class Invitation < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :accepted_user, class_name: "User", optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  def accepted?
    accepted_at.present?
  end

  def available_for_sign_up?
    !accepted?
  end

  def accept!(user)
    update!(accepted_at: Time.current, accepted_user: user)
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(16)
  end
end
