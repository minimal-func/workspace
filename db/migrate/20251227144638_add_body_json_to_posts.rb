class AddBodyJsonToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :body_json, :jsonb
  end
end
