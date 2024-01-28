class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    drop_table :libraries, if_exists: true

    create_table :libraries do |t|
      t.string :file_name
      t.string :file_description
      t.string :file_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
