class CreateEffectivePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.string :meta_keywords
      t.string :meta_description

      t.boolean :draft, :default => false

      t.string :template
      t.text :regions
      t.text :snippets

      t.string :slug
      t.integer :roles_mask

      t.datetime :updated_at
      t.datetime :created_at
    end

    add_index :pages, :slug, :unique => true
  end

  def self.down
    drop_table :pages
  end

end
