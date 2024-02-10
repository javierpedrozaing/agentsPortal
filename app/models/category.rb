class Category < ApplicationRecord
  has_many :libraries, dependent: :destroy

  validates :name, presence: true
end
