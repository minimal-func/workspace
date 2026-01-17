class RemoveContentFromReflections < ActiveRecord::Migration[6.0]
  def change
    remove_column :reflections, :content, :text
  end
end
