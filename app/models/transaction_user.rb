class TransactionUser < ApplicationRecord
  belongs_to :transaction_record, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :user
end
