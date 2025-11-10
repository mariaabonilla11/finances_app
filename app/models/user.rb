class User < ApplicationRecord
  has_secure_password
  has_many :refresh_tokens, dependent: :destroy


  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: :password_digest_changed?
  validates :first_name, presence: true
  validates :last_name, presence: true

  enum state: {
    active: 1,
    inactive: 0,
    pending: 2,
    suspended: 3
  }
end
