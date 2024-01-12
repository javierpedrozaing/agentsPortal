class Agent < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  has_one :score
end
