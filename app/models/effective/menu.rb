module Effective
  class Menu < ActiveRecord::Base
    has_many :menu_items, :dependent => :delete_all

    self.table_name = EffectivePages.menus_table_name.to_s

    structure do
      title           :string, :validates => [:presence]
      timestamps
    end

    accepts_nested_attributes_for :menu_items, :allow_destroy => true

    def contains?(obj)
      menu_items.find { |menu_item| menu_item.url == obj || menu_item.menuable == obj }.present?
    end

    # This is the DSL method for creating menu items
    def build(&block)
      if block_given?
        menu_items.build(:title => 'Root', :url => '#', :lft => 1, :rgt => 2)
        instance_exec(&block)
      end
      self
    end

    def item(title, url = '#', options = {})
      puts "Starting: #{title}"
      puts menu_items.length

      prev_item = menu_items.last
      lft = prev_item.lft + 1
      rgt = prev_item.rgt + 1

      atts = options.merge({:title => title, :url => url, :lft => lft, :rgt => rgt})


      #menu_items.each { |item| puts "#{item.title} #{item.rgt}" }

      menu_items.each { |item| item.rgt = item.rgt + 2 } #item.rgt + 2 if item.rgt < rgt }

      menu_items.build(atts)
    end


  end

end
