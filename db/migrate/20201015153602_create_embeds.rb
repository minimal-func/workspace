class CreateEmbeds < ActiveRecord::Migration[6.0]
  def change
    create_table :embeds do |t|
      t.text :content
      t.string :height
      t.string :author_url
      t.string :thumbnail_url
      t.string :width
      t.string :author_name
      t.string :thumbnail_height
      t.string :title
      t.string :version
      t.string :provider_url
      t.string :thumbnail_width
      t.string :embed_type
      t.string :provider_name
      t.string :html

      t.timestamps
    end
  end
end
