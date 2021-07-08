class RemoveGenrePhotographers < ActiveRecord::Migration[5.2]
  def change
    remove_column :photographers, :genre
  end
end
