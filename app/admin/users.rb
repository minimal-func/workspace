ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :level
    column :total_points
    column :current_sign_in_at
    column :sign_in_count
    column :purchased_features
    column :created_at
    actions
  end

  filter :email
  filter :level
  filter :total_points
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do
    attributes_table do
      row :email
      row :level
      row :total_points
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :sign_in_count
      row :purchased_features
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Account" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end