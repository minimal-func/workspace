ActiveAdmin.register Post do
  permit_params :title, :short_description, :project_id, :public, :content

  index do
    selectable_column
    id_column
    column :title
    column :short_description
    column :project
    column :public
    column :created_at
    actions
  end

  filter :title
  filter :public
  filter :project
  filter :created_at

  show do
    attributes_table do
      row :title
      row :short_description
      row :content
      row :project
      row :public
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Post Details" do
      f.input :title
      f.input :short_description
      f.input :content
      f.input :project
      f.input :public
    end
    f.actions
  end
end