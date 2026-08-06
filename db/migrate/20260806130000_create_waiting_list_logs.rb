class CreateWaitingListLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :waiting_list_logs do |t|
      t.string :email, null: false
      t.string :status, null: false, default: "pending"
      t.references :invitation, foreign_key: true
      t.references :reviewed_by, foreign_key: { to_table: :admin_users }

      t.timestamps null: false
    end

    add_index :waiting_list_logs, :email, unique: true
    add_index :waiting_list_logs, :status
  end
end