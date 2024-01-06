class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :type_of_file
      t.string :path
      t.references :library

      t.timestamps
    end
  end
end
