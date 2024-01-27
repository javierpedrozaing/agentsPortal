class User < ApplicationRecord
  enum role: [:agent, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_one :agent
  validates :active, inclusion: { in: [true, false] }
  has_one :score

  has_many :transaction_users
  has_many :transactions, through: :transaction_users, source: :transaction_record

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def set_default_role
    self.role ||= :agent
  end

  def self.calculate_relative_position
    users_with_scores = includes(:score, :transactions).all.map do |user|
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
end
