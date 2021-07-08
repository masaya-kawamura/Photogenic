class CreatePhotoGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_genres do |t|
      t.integer :photo_id, null:false
      t.integer :genre_id, null:false

      t.timestamps
    end
  end
end
