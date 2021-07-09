class ChangeToPhotographerGenreMaps < ActiveRecord::Migration[5.2]
  def change
    rename_table :photographer_genre_map, :photographer_genre_maps
  end
end
