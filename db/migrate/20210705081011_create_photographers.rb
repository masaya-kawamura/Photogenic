class CreatePhotographers < ActiveRecord::Migration[5.2]
  def change
    create_table :photographers do |t|
      t.integer :user_id, null: false
      t.string :name
      t.string :introduction
      t.string :instagram_url
      t.string :facebook_url

      t.timestamps
    end
  end
end
