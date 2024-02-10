class Library < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one_attached :file

  validates :file_name, presence: true
  validates :attached_file, presence: true
end
