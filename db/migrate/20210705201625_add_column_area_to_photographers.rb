class AddColumnAreaToPhotographers < ActiveRecord::Migration[5.2]
  def change
    add_column :photographers, :area, :string
    add_column :photographers, :public_status, :boolean, default: false, null: false
  end
end
