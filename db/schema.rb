# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_17_134315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "biggest_challenges", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_biggest_challenges_on_user_id"
  end

  create_table "daily_lessons", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_lessons_on_user_id"
  end

  create_table "day_ratings", force: :cascade do |t|
    t.integer "value"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_day_ratings_on_user_id"
  end

  create_table "embeds", force: :cascade do |t|
    t.text "content"
    t.string "height"
    t.string "author_url"
    t.string "thumbnail_url"
    t.string "width"
    t.string "author_name"
    t.string "thumbnail_height"
    t.string "title"
    t.string "version"
    t.string "provider_url"
    t.string "thumbnail_width"
    t.string "embed_type"
    t.string "provider_name"
    t.string "html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "energy_levels", force: :cascade do |t|
    t.integer "value"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_energy_levels_on_user_id"
  end

  create_table "main_tasks", force: :cascade do |t|
    t.string "name"
    t.datetime "planned_finish"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_main_tasks_on_user_id"
  end

  create_table "moods", force: :cascade do |t|
    t.integer "value"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_moods_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "reflections", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reflections_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "project_id", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wiki_concept_learnings", force: :cascade do |t|
    t.bigint "wiki_concept_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_wiki_concept_learnings_on_user_id"
    t.index ["wiki_concept_id"], name: "index_wiki_concept_learnings_on_wiki_concept_id"
  end

  create_table "wiki_concepts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "short_description"
    t.integer "learning_time_minutes"
    t.integer "created_by"
    t.bigint "wiki_topic_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wiki_topic_id"], name: "index_wiki_concepts_on_wiki_topic_id"
  end

  create_table "wiki_topic_subscriptions", force: :cascade do |t|
    t.bigint "wiki_topic_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_wiki_topic_subscriptions_on_user_id"
    t.index ["wiki_topic_id"], name: "index_wiki_topic_subscriptions_on_wiki_topic_id"
  end

  create_table "wiki_topics", force: :cascade do |t|
    t.string "name"
    t.string "short_description"
    t.integer "created_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "biggest_challenges", "users"
  add_foreign_key "daily_lessons", "users"
  add_foreign_key "day_ratings", "users"
  add_foreign_key "energy_levels", "users"
  add_foreign_key "main_tasks", "users"
  add_foreign_key "moods", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "reflections", "users"
  add_foreign_key "tasks", "projects"
  add_foreign_key "wiki_concept_learnings", "users"
  add_foreign_key "wiki_concept_learnings", "wiki_concepts"
  add_foreign_key "wiki_concepts", "wiki_topics"
  add_foreign_key "wiki_topic_subscriptions", "users"
  add_foreign_key "wiki_topic_subscriptions", "wiki_topics"
end
