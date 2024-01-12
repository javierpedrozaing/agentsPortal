class CreateTransactionUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_users do |t|
      t.references :transaction, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
