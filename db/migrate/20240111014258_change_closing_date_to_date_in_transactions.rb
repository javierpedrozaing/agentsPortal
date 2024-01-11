class ChangeClosingDateToDateInTransactions < ActiveRecord::Migration[6.1]
  def change
    change_column :transactions, :closing_date, :date
  end
end
