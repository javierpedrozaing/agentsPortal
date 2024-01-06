class User < ApplicationRecord
  enum role: [:agent, :admin]
  after_initialize :set_default_role, :if => :new_record?
  has_one :agent
  validates :active, inclusion: { in: [true, false] }

  def set_default_role
    self.role ||= :agent
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
