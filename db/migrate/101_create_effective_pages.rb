class CreateEffectivePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.integer :page_banner_id

      t.string :title
      t.string :meta_description

      t.datetime :published_start_at
      t.datetime :published_end_at
      t.boolean :legacy_draft, default: false

      t.string :layout, default: 'application'
      t.string :template

      t.string :slug

      t.boolean :authenticate_user, default: false
      t.integer :roles_mask, default: 0

      t.integer :menu_parent_id

      t.boolean :menu, default: false

      t.string :menu_name
      t.string :menu_group

      t.string :menu_title
      t.string :menu_url
      t.integer :menu_position

      t.integer :menu_children_count, default: 0

      t.boolean :banner, default: false
      t.boolean :banner_random, default: false

      t.datetime :updated_at
      t.datetime :created_at
    end

    add_index :pages, :slug, :unique => true
    add_index :pages, [:published_start_at, :published_end_at], if_not_exists: true
    add_index :pages, :menu, if_not_exists: true
    add_index :pages, :menu_parent_id, if_not_exists: true
    add_index :pages, :menu_position, if_not_exists: true

    create_table :page_banners do |t|
      t.string :name
      t.string :caption

      t.timestamps
    end

    add_index :page_banners, :name, :unique => true

    create_table :page_sections do |t|
      t.string :name
      t.text :hint

      t.string :title
      t.string :caption

      t.string :link_label
      t.string :link_url

      t.datetime :updated_at
      t.datetime :created_at
    end

    add_index :page_sections, :name, :unique => true

    create_table :page_segments do |t|
      t.integer :page_id

      t.string :title
      t.integer :position

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :carousel_items do |t|
      t.string :carousel

      t.string :title
      t.string :caption

      t.string :link_label
      t.string :link_url

      t.integer :position

      t.timestamps
    end

    add_index :carousel_items, :carousel, if_not_exists: true
    add_index :carousel_items, :position, if_not_exists: true

    create_table :alerts, if_not_exists: true do |t|
      t.boolean :enabled

      t.timestamps
    end

    create_table :permalinks, if_not_exists: true do |t|
      t.string :title
      t.string :slug
      t.string :url
      t.text   :summary
      t.integer :tracks_count, default: 0

      t.timestamps
    end

    create_table :tags, if_not_exists: true do |t|
      t.string :name

      t.timestamps
    end

    create_table :taggings, if_not_exists: true do |t|
      t.integer :tag_id
      t.integer :taggable_id
      t.string :taggable_type

      t.timestamps
    end

    add_index :taggings, [:taggable_type, :taggable_id], if_not_exists: true
    add_index :taggings, :tag_id, if_not_exists: true
  end

end
