class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.date :current_date
      t.string :agent1_name
      t.string :agent2_name
      t.string :agent3_name
      t.string :type_of_transaction
      t.string :property_address
      t.string :seller_lessor
      t.string :buyer_lessee
      t.string :agent_client
      t.string :closing_date
      t.string :title_escrow_company
      t.string :sale_purchase
      t.string :bank_deposit
      t.string :transaction_fee_amount
      t.string :commission_percentage
      t.string :agent1_commission_percentage
      t.string :agent1_commission_amount
      t.string :agent2_commission_percentage
      t.string :agent2_commission_amount
      t.string :referral_to
      t.string :referral_amount
      t.string :office_commission_percentage
      t.string :office_commission_amount
      t.references :user, index: true
      t.timestamps
    end
  end
end
