module Effective
  class Menu < ActiveRecord::Base
    has_many :menu_items, :dependent => :delete_all

    self.table_name = EffectivePages.menus_table_name.to_s
    attr_protected() if Rails::VERSION::MAJOR == 3

    structure do
      title           :string, :validates => [:presence]
      timestamps
    end

    accepts_nested_attributes_for :menu_items, :allow_destroy => true

    def self.update_from_effective_regions!(params)
      (params || {}).each do |id, attributes|
        menu = Effective::Menu.find(id)
        attributes[:menu_items_attributes].each { |_, atts| atts[:menuable_type] = 'Effective::Page' if atts[:menuable_type].blank? }
        menu.attributes = attributes
        menu.save!
      end
    end

    def contains?(obj)
      menu_items.find { |menu_item| menu_item.url == obj || menu_item.menuable == obj }.present?
    end


    # This is the entry point to the DSL method for creating menu items
    def build(&block)
      raise 'build must be called with a block' if !block_given?

      root = menu_items.build(:title => 'Root', :url => '#', :lft => 1, :rgt => 2)
      root.parent = true
      instance_exec(&block) # A call to dropdown or item
      self
    end

    def dropdown(title, url = '#', options = {}, &block)
      raise 'dropdown must be called with a block' if !block_given?
      #puts "[DROPDOWN] Starting: #{title}"

      prev_item = menu_items.last

      if prev_item.parent == true # This came from root or dropdown
        lft = prev_item.lft + 1 # Go down. from lft
        rgt = prev_item.rgt + 1
      else
        lft = prev_item.rgt + 1 # Go accross. from rgt
        rgt = prev_item.rgt + 2
      end

      atts = options.merge({:title => title, :url => url, :lft => lft, :rgt => rgt})

      #puts menu_items.map { |item| "[DROPDOWN] #{item.lft} #{item.title} #{item.rgt}"}

      # Make room for new item by shifting everything after me up by 2
      menu_items.each do |item|
        item.rgt = (item.rgt + 2) if item.rgt > (lft - 1)
        item.lft = (item.lft + 2) if item.lft > (lft - 1)
      end

      dropdown = menu_items.build(atts)
      dropdown.parent = true

      instance_exec(&block)

      # Level up
      dropdown.rgt = menu_items.last.rgt + 1 # Level up
      dropdown.parent = false
      menu_items << menu_items.delete(dropdown) # Put myself on the end of the array
    end

    def item(title, url = '#', options = {})
      #puts "[ITEM] Starting: #{title}"
      #puts menu_items.length

      prev_item = menu_items.last

      if prev_item.parent == true # This came from root or dropdown
        lft = prev_item.lft + 1 # Go down. from lft
        rgt = prev_item.rgt + 1
      else
        lft = prev_item.rgt + 1 # Go accross, from rgt
        rgt = prev_item.rgt + 2
      end

      atts = options.merge({:title => title, :url => url, :lft => lft, :rgt => rgt})

      #puts menu_items.map { |item| "[ITEM] #{item.lft} #{item.title} #{item.rgt}"}

      menu_items.each do |item|
        item.rgt = (item.rgt + 2) if item.rgt > (lft - 1)
        item.lft = (item.lft + 2) if item.lft > (lft - 1)
      end

      menu_items.build(atts)
    end


  end

end
