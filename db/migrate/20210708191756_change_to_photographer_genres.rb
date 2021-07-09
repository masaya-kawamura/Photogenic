class ChangeToPhotographerGenres < ActiveRecord::Migration[5.2]
  def change
    rename_table :photographer_genres, :photographer_genre_map
  end
end
