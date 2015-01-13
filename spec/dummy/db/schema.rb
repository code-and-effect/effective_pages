# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "menu_items", :force => true do |t|
    t.integer "menu_id"
    t.integer "menuable_id"
    t.string  "menuable_type"
    t.string  "title"
    t.string  "url"
    t.string  "classes"
    t.string  "special"
    t.boolean "new_window",    :default => false
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "menu_items", ["lft"], :name => "index_menu_items_on_lft"

  create_table "menus", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "meta_description"
    t.boolean  "draft",            :default => false
    t.string   "layout",           :default => "application"
    t.string   "template"
    t.string   "slug"
    t.integer  "roles_mask",       :default => 0
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

end
