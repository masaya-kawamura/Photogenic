class AddColumnConfiamationMailerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confimaition_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :cofirmation_sent_at, :datetime
    add_column :users, :unconfirmad_email, :string
  end
end
