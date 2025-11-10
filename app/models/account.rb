class Account < ApplicationRecord
  has_many :account_transactions, class_name: "Transaction"

  validates :name, presence: true
  validates :balance, presence: true
  validates :currency, presence: true


  enum state: {
    active: 1,
    inactive: 0,
    pending: 2,
    suspended: 3
  }
end
