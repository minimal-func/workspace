class MakeNotifiableOptionalInNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :notifications, :notifiable_type, true
    change_column_null :notifications, :notifiable_id, true
  end
end
