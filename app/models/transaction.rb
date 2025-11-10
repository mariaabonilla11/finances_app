class Transaction < ApplicationRecord
  belongs_to :type_transaction
  belongs_to :category
  belongs_to :account

  validates :value, presence: true
  validates :date, presence: true

  enum state: {
    active: 1,
    inactive: 0,
    pending: 2,
    suspended: 3
  }

end
