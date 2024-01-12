class Transaction < ApplicationRecord
  has_one :score, dependent: :destroy
  has_many :transaction_users
  has_many :users, through: :transaction_users
  has_one_attached :csv_file

  # create the TYPE_OF_TRANSACTION constant
  TYPE_OF_TRANSACTION = ['Sale', 'Lease', 'Referral']
end
