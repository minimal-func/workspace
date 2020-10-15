class CreateWikiTopicSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :wiki_topic_subscriptions do |t|
      t.references :wiki_topic, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
