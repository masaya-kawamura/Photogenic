class RenameConfimaitionTokenColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :confimaition_token, :confirmation_token
  end
end
