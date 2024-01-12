class AddReferenceTransactionToScore < ActiveRecord::Migration[6.1]
  def change
    add_reference :scores, :transaction, foreign_key: true
  end
end
