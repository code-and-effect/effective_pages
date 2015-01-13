module Effective
  class MenuItem < ActiveRecord::Base
    attr_accessor :parent  # This gets set on the Root node and a node created by Dropdown, so the item function knows whether to go down or to go accross

    belongs_to :menu, :inverse_of => :menu_items
    belongs_to :menuable, :polymorphic => true # Optionaly belong to an object

    self.table_name = EffectivePages.menu_items_table_name.to_s
    attr_protected() if Rails::VERSION::MAJOR == 3

    structure do
      title           :string, :validates => [:presence]

      url             :string
      special         :string   # divider / search / *_path

      classes         :string
      new_window      :boolean, :default => false, :validates => [:inclusion => {:in => [true, false]}]
      roles_mask      :integer, :default => nil # 0 is going to mean logged in, nil is going to mean public, > 0 will be future implementation of roles masking

      lft             :integer, :validates => [:presence], :index => true
      rgt             :integer, :validates => [:presence]
    end

    default_scope -> { includes(:menuable).order(:lft) }

    def leaf?
      (rgt.to_i - lft.to_i) == 1
    end

    def dropdown?
      !leaf?
    end

    def divider?
      leaf? && special == 'divider'
    end

    # before_validation do
    #   if menuable.present?
    #     self.title = nil if menuable.menu_title == self[:title]
    #     self.url = nil if menuable.menu_url == self[:url]
    #   end
    #   true
    # end

    # def title
    #   self[:title] || menuable.menu_title rescue nil
    # end

    # def url
    #   self[:url] || menuable.menu_url rescue nil
    # end
  end
end
