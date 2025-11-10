class RefreshToken < ApplicationRecord
  belongs_to :user
  
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  # Querys reutilizables
  scope :active, -> { where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }
  scope :for_user, ->(user) { where(user: user) }

  def active?
    expires_at > Time.current
  end

  def expired?
    expires_at <= Time.current
  end
end