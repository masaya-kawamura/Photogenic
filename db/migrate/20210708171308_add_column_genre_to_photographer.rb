class AddColumnGenreToPhotographer < ActiveRecord::Migration[5.2]
  def change
    add_column :photographers, :genre, :string
  end
end
