class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.integer :photo_id, null: false
      t.float :rate, null: false
      t.text :comment

      t.timestamps
    end
  end
end
