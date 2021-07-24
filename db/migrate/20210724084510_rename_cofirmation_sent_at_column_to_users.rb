class RenameCofirmationSentAtColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :cofirmation_sent_at, :confirmation_sent_at
  end
end
