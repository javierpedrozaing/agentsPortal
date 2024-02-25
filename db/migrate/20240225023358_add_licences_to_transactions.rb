class AddLicencesToTransactions < ActiveRecord::Migration[6.1]
  ## add agent1_license and agent2_license to transactions
  def change
    add_column :transactions, :agent1_licence, :string
    add_column :transactions, :agent2_licence, :string
    add_column :transactions, :agent3_licence, :string
  end
end
