class AddUserIdToScores < ActiveRecord::Migration[6.1]
  def change
    add_reference :scores, :user, foreign_key: true
    remove_reference :scores, :agent, foreign_key: true
  end
end
