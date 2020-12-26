class RemoveWikiTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :wiki_topic_subscriptions
    drop_table :wiki_concept_learnings
    drop_table :wiki_concepts
    drop_table :wiki_topics
  end
end
