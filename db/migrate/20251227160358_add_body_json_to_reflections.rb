class AddBodyJsonToReflections < ActiveRecord::Migration[7.1]
  def change
    add_column :reflections, :body_json, :jsonb
  end
end
