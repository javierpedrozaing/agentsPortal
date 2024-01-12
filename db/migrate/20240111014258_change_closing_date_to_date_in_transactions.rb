class ChangeClosingDateToDateInTransactions < ActiveRecord::Migration[6.1]
  def up
    # Add a default value for existing NULL values, if necessary
    change_column_default :transactions, :closing_date, -> { 'CURRENT_DATE' }

    # Change the data type of the column using the USING clause
    change_column :transactions, :closing_date, 'date USING CAST(closing_date AS date)'
  end

  def down
    # Change the data type back to its original type if you need to rollback the migration
    change_column :transactions, :closing_date, :original_data_type
  end
end
