class CreateAgents < ActiveRecord::Migration[6.1]
  def change
    create_table :agents do |t|
      t.string :city
      t.string :state
      t.string :address_home
      t.string :zip_code
      t.string :licence
      t.string :split
      t.string :phone
      t.references :user, index: true
      t.timestamps
    end
  end
end
