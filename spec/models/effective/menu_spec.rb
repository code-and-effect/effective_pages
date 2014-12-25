require 'spec_helper'

describe Effective::Menu do
  describe 'Effective Menus DSL' do

    it 'correctly builds a menu with items' do
      menu = Effective::Menu.new(:title => 'test').build do
        item 'AAA'
        item 'BBB'
      end

      menu.valid?.should eq true

      items = menu.menu_items.sort_by(&:lft).map { |item| [item.title, item.lft, item.rgt] }

      expect(items).to eq [
        ['Root', 1, 6],
          ['AAA', 2, 3],
          ['BBB', 4, 5]
      ]
    end

    it 'correctly builds a menu with dropdowns' do
      menu = Effective::Menu.new(:title => 'test').build do
        dropdown 'About' do
          item 'AAA'
          item 'BBB'
        end

        dropdown 'Become a Member' do
          item '111'
          item '222'
        end

        item 'XXX'
      end

      menu.valid?.should eq true

      items = menu.menu_items.sort_by(&:lft).map { |item| [item.title, item.lft, item.rgt] }

      expect(items).to eq [
        ['Root', 1, 16],
          ['About', 2, 7],
            ['AAA', 3, 4],
            ['BBB', 5, 6],
          ['Become a Member', 8, 13],
            ['111', 9, 10],
            ['222', 11, 12],
          ['XXX', 14, 15]
      ]
    end

    it 'correctly builds a menu with dropdowns inside dropdowns' do
      menu = Effective::Menu.new(:title => 'test').build do
        dropdown 'Fruit' do
          dropdown 'Red' do
            item 'Cherry'
          end

          dropdown 'Yellow' do
            item 'Banana'
          end
        end

        dropdown 'Meat' do
          item 'Beef'
          item 'Pork'
        end
      end

      menu.valid?.should eq true

      items = menu.menu_items.sort_by(&:lft).map { |item| [item.title, item.lft, item.rgt] }

      expect(items).to eq [
        ['Root', 1, 18],
          ['Fruit', 2, 11],
            ['Red', 3, 6],
              ['Cherry', 4, 5],
            ['Yellow', 7, 10],
              ['Banana', 8, 9],
          ['Meat', 12, 17],
            ['Beef', 13, 14],
            ['Pork', 15, 16]
      ]

    end
  end
end
