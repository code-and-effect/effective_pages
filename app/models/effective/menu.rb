module Effective
  class Menu < ActiveRecord::Base
    has_many :menu_items, dependent: :delete_all

    self.table_name = EffectivePages.menus_table_name.to_s
    attr_protected() if Rails::VERSION::MAJOR == 3

    # structure do
    #   title           :string
    #   timestamps
    # end

    validates :title, presence: true, uniqueness: true, length: { maximum: 255 }

    accepts_nested_attributes_for :menu_items, allow_destroy: true

    before_save do
      if self.menu_items.find { |menu_item| menu_item.lft == 1 }.blank?
        menu_items.build(title: 'Home', url: '/', lft: 1, rgt: 2)
      end
    end

    def self.update_from_effective_regions!(params)
      Effective::Menu.transaction do
        (params || {}).each do |menu_id, attributes|
          menu = Effective::Menu.includes(:menu_items).find(menu_id)
          menu.menu_items.delete_all

          attributes[:menu_items_attributes].each do |_, atts|
            atts[:menuable_type] = 'Effective::Page' if atts[:menuable_type].blank?
            atts.delete(:id)
          end

          menu.attributes = attributes

          # So when we render the menu, we don't include the Root/Home item.
          # It has a left of 1 and a right of max(items.right)
          right = attributes[:menu_items_attributes].map { |_, atts| atts[:rgt].to_i }.max

          root_node = menu.menu_items.find { |menu_item| menu_item.lft == 1 }
          root_node ||= menu.menu_items.build(title: 'Home', url: '/', lft: 1, rgt: 2)
          root_node.rgt = right + 1

          menu.save!
        end
      end
    end

    def to_s
      self[:title] || 'New Menu'
    end

    def contains?(obj)
      menu_items.find { |menu_item| menu_item.url == obj || menu_item.menuable == obj }.present?
    end

    # This is the entry point to the DSL method for creating menu items
    def build(&block)
      raise 'build must be called with a block' if !block_given?

      root = menu_items.build(title: 'Home', url: '/', lft: 1, rgt: 2)
      root.parent = true
      instance_exec(&block) # A call to dropdown or item
      root.rgt = menu_items.map(&:rgt).max
      self
    end

    private

    def dropdown(title, options = {}, &block)
      raise 'dropdown must be called with a block' if !block_given?
      raise 'dropdown menu_items may not have a URL' if options.kind_of?(String) || options.kind_of?(Symbol)
      raise 'dropdown second parameter expects a Hash' unless options.kind_of?(Hash)

      prev_item = menu_items.last

      if prev_item.parent == true # This came from root or dropdown
        lft = prev_item.lft + 1 # Go down. from lft
        rgt = prev_item.rgt + 1
      else
        lft = prev_item.rgt + 1 # Go accross. from rgt
        rgt = prev_item.rgt + 2
      end

      # Make room for new item by shifting everything after me up by 2
      menu_items.each do |item|
        item.rgt = (item.rgt + 2) if item.rgt > (lft - 1)
        item.lft = (item.lft + 2) if item.lft > (lft - 1)
      end

      atts = build_menu_item_attributes(title, '', options).merge({:lft => lft, :rgt => rgt})

      dropdown = menu_items.build(atts)
      dropdown.parent = true

      instance_exec(&block)

      # Level up
      dropdown.rgt = menu_items.last.rgt + 1 # Level up
      dropdown.parent = false
      menu_items << menu_items.delete(dropdown) # Put myself on the end of the array
    end

    # The URL parameter can be:
    # - an Effective::Page object
    # - the symbol :divider
    # - a symbol or string that ends with _path
    # - or a string that is the url

    def item(title, url = '#', options = {})
      raise 'item third parameter expects a Hash' unless options.kind_of?(Hash)

      prev_item = menu_items.last

      if prev_item.parent == true # This came from root or dropdown
        lft = prev_item.lft + 1 # Go down. from lft
        rgt = prev_item.rgt + 1
      else
        lft = prev_item.rgt + 1 # Go accross, from rgt
        rgt = prev_item.rgt + 2
      end

      menu_items.each do |item|
        item.rgt = (item.rgt + 2) if item.rgt > (lft - 1)
        item.lft = (item.lft + 2) if item.lft > (lft - 1)
      end

      atts = build_menu_item_attributes(title, url, options).merge({:lft => lft, :rgt => rgt})

      menu_items.build(atts)
    end

    def divider(options = {})
      item(:divider, :divider, options)
    end

    def build_menu_item_attributes(title, url, options)
      options[:roles_mask] ||= 0 if (options.delete(:signed_in) || options.delete(:private))
      options[:roles_mask] ||= -1 if (options.delete(:signed_out) || options.delete(:guest))

      if options[:roles]
        options[:roles_mask] = EffectiveRoles.roles_mask_for(options.delete(:roles))
      end

      options[:classes] = options.delete(:class)

      if title == :divider || url == :divider || options[:divider] == true
        options[:title] = 'divider'
        options[:special] = 'divider'
      elsif title.kind_of?(Effective::Page)
        options[:title] = title.title
        options[:menuable] = title
        options[:url] = '#'
      elsif url.kind_of?(Effective::Page)
        options[:title] = title.presence || url.title
        options[:menuable] = url
        options[:url] = '#'
      elsif url.to_s.end_with?('_path')
        options[:title] = title
        options[:special] = url
      else
        options[:title] = title
        options[:url] = url
      end

      options
    end


  end

end
