class MakeInvitationInviterOptional < ActiveRecord::Migration[7.1]
  def change
    change_column_null :invitations, :inviter_id, true
  end
end