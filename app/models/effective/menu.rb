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
      menu_item.find { |menu_item| menu_item.url == obj || menu_item.menuable == obj }.present?
    end

  end
end
