class AddColumnPhotographerIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :photographer_id, :integer
  end
end
