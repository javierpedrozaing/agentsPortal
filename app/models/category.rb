class Category < ApplicationRecord
  has_many :libraries, dependent: :destroy
end
