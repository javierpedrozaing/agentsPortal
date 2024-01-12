class RemoveFreignKeyFromTransaction < ActiveRecord::Migration[6.1]
  def change
    remove_reference :transactions, :user, foreign_key: false
  end
end
