class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.references :accepted_user, foreign_key: { to_table: :users }
      t.datetime :accepted_at

      t.timestamps null: false
    end

    add_index :invitations, :token, unique: true
  end
end
