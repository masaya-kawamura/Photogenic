class CreatePhotographerGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :photographer_genres do |t|
      t.integer :photographer_id, null: false
      t.integer :genre_id, null: false

      t.timestamps
    end
  end
end
