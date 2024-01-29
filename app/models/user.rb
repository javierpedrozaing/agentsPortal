class User < ApplicationRecord
  enum role: [:agent, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_one :agent
  validates :active, inclusion: { in: [true, false] }
  has_one :score

  has_many :transaction_users
  has_many :transactions, through: :transaction_users, source: :transaction_record

  has_many :libraries

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def set_default_role
    self.role ||= :agent
  end

  def self.calculate_relative_position(year = nil, month = nil, user_id = nil)
    return filter_by_agent(year, month, user_id) if user_id.present?
    return filter_transactions(user_id, year, month) if year.present? || month.present?

    users_with_scores = where(role: "agent").includes(:score, :transactions).all.map do |user|
      score = user.score
      transactions = user.transactions

      {
        user: user,
        score: score&.sales_volume.to_f + score&.sales_transactions.to_i,
        transactions: transactions
      }
    end
    users_with_scores.sort_by { |user_with_score| -user_with_score[:score] }
  end

  def self.filter_by_agent(year, month, user_id)
    users_with_scores = where(id: user_id).includes(:score, :transactions).all.map do |user|
      score = user.score
      transactions = user.transactions

      {
        user: user,
        score: score&.sales_volume.to_f + score&.sales_transactions.to_i,
        transactions: transactions
      }
    end
  end

  def self.filter_transactions(user_id, year, month)
    if year.present? && month.present?
      transactions = Transaction.where("strftime('%Y', transactions.created_at) = ? AND strftime('%m', transactions.created_at) = ?", year.to_s, "%02d" % month.to_s)
    elsif year.present?
      transactions = Transaction.where("strftime('%Y', transactions.created_at) = ?", year.to_s)
    elsif month.present?
      transactions = Transaction.where("strftime('%m', transactions.created_at) = ?", "%02d" % month.to_s)

    else
      transactions = user.transactions
    end

    user_ids = transactions.map(&:user_ids).flatten.uniq

    users_with_scores = where(role: 'agent').where(id: user_ids).includes(:score, :transactions).all.map do |user|
      score = user.score
      transactions = transactions.where(user_id: user.id)

      {
        user: user,
        score: score&.sales_volume.to_f + score&.sales_transactions.to_i,
        transactions: user.transactions
      }
    end
    users_with_scores.sort_by { |user_with_score| -user_with_score[:score] }
  end
end
