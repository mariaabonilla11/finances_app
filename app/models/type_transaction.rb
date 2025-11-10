class TypeTransaction < ApplicationRecord
  has_many :transactions, class_name: "Transaction"

  validates :name, presence: true

  enum state: {
    active: 1,
    inactive: 0,
    pending: 2,
    suspended: 3
  }
end
