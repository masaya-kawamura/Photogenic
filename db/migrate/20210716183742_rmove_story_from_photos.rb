class RmoveStoryFromPhotos < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :story, :text
    remove_column :photos, :detail, :text

    add_column :photos, :caption, :text
  end
end
