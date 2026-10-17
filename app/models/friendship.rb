class Friendship < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :addressee, class_name: "User"

  enum :status, { pending: "pending", accepted: "accepted" }, default: :pending

  validates :requester_id, uniqueness: { scope: :addressee_id }
  validate :users_are_different
  validate :connection_does_not_already_exist

  scope :between, ->(first_user, second_user) do
    where(
      "(requester_id = :first_id AND addressee_id = :second_id) OR " \
      "(requester_id = :second_id AND addressee_id = :first_id)",
      first_id: first_user.id,
      second_id: second_user.id
    )
  end

  def other_user(user)
    requester_id == user.id ? addressee : requester
  end

  def accept!
    update!(status: :accepted, accepted_at: Time.current)
  end

  private

  def users_are_different
    errors.add(:addressee, "can't be yourself") if requester_id.present? && requester_id == addressee_id
  end

  def connection_does_not_already_exist
    return if requester_id.blank? || addressee_id.blank?

    existing_connection = self.class.between(requester, addressee).where.not(id: id).exists?
    errors.add(:base, "A friend request already exists") if existing_connection
  end
end
