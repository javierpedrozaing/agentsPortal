class Transaction < ApplicationRecord
  has_many :transaction_users, dependent: :destroy
  has_many :users, through: :transaction_users
  has_one_attached :csv_file

  # create the TYPE_OF_TRANSACTION constant
  TYPE_OF_TRANSACTION = ['Sale', 'Lease', 'Referral']

  def self.filter_by_year_and_month(year, month)
    if year.present? && month.present?
      where("strftime('%Y', transactions.created_at) = ? AND strftime('%m', transactions.created_at) = ?", year.to_s, month.to_s)
    elsif year.present?
      where("strftime('%Y', transactions.created_at) = ?", year.to_s)
    elsif month.present?
      where("strftime('%m', transactions.created_at) = ?", month.to_s)
    else
      all
    end
  end
end
