class AddColumunImageToPhotographers < ActiveRecord::Migration[5.2]
  def change
    add_column :photographers, :photographer_profile_image, :string
    add_column :photographers, :cover_image, :string
  end
end
