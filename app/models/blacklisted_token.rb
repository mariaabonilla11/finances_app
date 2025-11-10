class BlacklistedToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  
  scope :expired, -> { where('expires_at < ?', Time.current) }
  scope :active, -> { where('expires_at >= ?', Time.current) }
end