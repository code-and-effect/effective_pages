# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 101) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "enabled"
    t.datetime "updated_at", null: false
  end

  create_table "banner_ads", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name"
    t.datetime "published_end_at", precision: nil
    t.datetime "published_start_at", precision: nil
    t.string "slug"
    t.integer "tracks_count", default: 0
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["location"], name: "index_banner_ads_on_location"
    t.index ["name"], name: "index_banner_ads_on_name", unique: true
    t.index ["published_start_at", "published_end_at"], name: "index_banner_ads_on_published_start_at_and_published_end_at"
  end

  create_table "carousel_items", force: :cascade do |t|
    t.string "caption"
    t.string "carousel"
    t.datetime "created_at", null: false
    t.string "link_label"
    t.string "link_url"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["carousel"], name: "index_carousel_items_on_carousel"
    t.index ["position"], name: "index_carousel_items_on_position"
  end

  create_table "page_banners", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_page_banners_on_name", unique: true
  end

  create_table "page_sections", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", precision: nil
    t.text "hint"
    t.string "link_label"
    t.string "link_url"
    t.string "name"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["name"], name: "index_page_sections_on_name", unique: true
  end

  create_table "page_segments", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "page_id"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", precision: nil
  end

  create_table "pages", force: :cascade do |t|
    t.boolean "authenticate_user", default: false
    t.boolean "banner", default: false
    t.boolean "banner_random", default: false
    t.datetime "created_at", precision: nil
    t.string "layout", default: "application"
    t.boolean "legacy_draft", default: false
    t.boolean "menu", default: false
    t.integer "menu_children_count", default: 0
    t.string "menu_group"
    t.string "menu_name"
    t.integer "menu_parent_id"
    t.integer "menu_position"
    t.string "menu_title"
    t.string "menu_url"
    t.string "meta_description"
    t.integer "page_banner_id"
    t.datetime "published_end_at", precision: nil
    t.datetime "published_start_at", precision: nil
    t.integer "roles_mask", default: 0
    t.string "slug"
    t.string "template"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["menu"], name: "index_pages_on_menu"
    t.index ["menu_parent_id"], name: "index_pages_on_menu_parent_id"
    t.index ["menu_position"], name: "index_pages_on_menu_position"
    t.index ["published_start_at", "published_end_at"], name: "index_pages_on_published_start_at_and_published_end_at"
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "permalinks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "slug"
    t.text "summary"
    t.string "title"
    t.integer "tracks_count", default: 0
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at", precision: nil
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "roles_mask"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
