class CreateScores < ActiveRecord::Migration[6.1]
  def change
    create_table :scores do |t|
      t.float :sales_volume
      t.float :lease_volume
      t.integer :sales_transactions
      t.integer :lease_transactions
      t.references :agent, foreign_key: true

      t.timestamps
    end
  end
end
