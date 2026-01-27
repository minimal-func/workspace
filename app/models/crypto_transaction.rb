class CryptoTransaction < ApplicationRecord
  belongs_to :user

  validates :transaction_hash, presence: true, uniqueness: true
  validates :block_number, presence: true
  validates :block_timestamp, presence: true
  validates :from_address, presence: true
  validates :to_address, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validates :token_symbol, presence: true
  validates :transaction_type, inclusion: { in: %w[ETH ERC20] }

  scope :incoming, ->(address) { where(to_address: address.downcase) }
  scope :outgoing, ->(address) { where(from_address: address.downcase) }

  def incoming?(address)
    to_address.downcase == address.downcase
  end

  def outgoing?(address)
    from_address.downcase == address.downcase
  end
end
