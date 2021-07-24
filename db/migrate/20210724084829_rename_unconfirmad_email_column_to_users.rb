class RenameUnconfirmadEmailColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :unconfirmad_email, :unconfirmed_email
  end
end
