class ChangeToPhotoGenres < ActiveRecord::Migration[5.2]
  def change
    rename_table :photo_genres, :photo_genre_maps
  end
end
