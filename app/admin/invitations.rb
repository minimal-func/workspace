ActiveAdmin.register Invitation do
  permit_params :email, :inviter_id

  config.filters = false

  index do
    selectable_column
    id_column
    column :email
    column "Share link" do |invitation|
      link_to "Open sign-up link", new_user_registration_path(invite_token: invitation.token)
    end
    column :inviter
    column :accepted_user
    column :accepted_at
    column :created_at
    actions
  end

  show title: :email do
    attributes_table do
      row :email
      row :token
      row :inviter
      row :accepted_user
      row :accepted_at
      row "Sign-up link" do |invitation|
        link_to new_user_registration_url(invite_token: invitation.token), new_user_registration_url(invite_token: invitation.token)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
    end
    f.actions
  end
end