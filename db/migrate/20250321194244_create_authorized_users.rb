class CreateAuthorizedUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :authorized_users do |t|
      t.string :slack_user_id

      t.timestamps
    end
    add_index :authorized_users, :slack_user_id
  end
end
