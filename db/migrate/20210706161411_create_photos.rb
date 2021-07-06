class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.text :photo_image
      t.text :story
      t.text :detail

      t.timestamps
    end
  end
end
