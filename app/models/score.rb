class Score < ApplicationRecord
  belongs_to :agent
  # belongs_to :transaction_record, class_name: 'Transaction', foreign_key: 'transaction_id'
end
