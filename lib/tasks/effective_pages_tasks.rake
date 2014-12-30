# desc "Explaining what the task does"
# task :effective_pages do
#   # Task goes here
# end

require 'cgi'


namespace :effective_pages do


  task :seed => :environment do
    include EffectiveMenusHelper

    Effective::Menu.destroy_all

    menu = Effective::Menu.new(:title => 'main menu')

    menu.menu_items.build(:lft => 1, :rgt => 49, :title => 'Root', :url => '#')

    menu.menu_items.build(:lft => 2, :rgt => 11, :title => 'About', :url => '#')
    menu.menu_items.build(:lft => 3, :rgt => 4, :title => 'AAA', :url => '#')
    menu.menu_items.build(:lft => 5, :rgt => 6, :title => 'BBB', :url => '#')
    menu.menu_items.build(:lft => 8, :rgt => 9, :title => 'CCC', :url => '#')
    menu.menu_items.build(:lft => 10, :rgt => 11, :title => 'DDD', :url => '#')

    menu.menu_items.build(:lft => 12, :rgt => 25, :title => 'Become a Member', :url => '#')
    menu.menu_items.build(:lft => 13, :rgt => 14, :title => '111', :url => '#')
    menu.menu_items.build(:lft => 15, :rgt => 16, :title => '222', :url => '#')
    menu.menu_items.build(:lft => 17, :rgt => 24, :title => 'More...', :url => '#')
    menu.menu_items.build(:lft => 18, :rgt => 19, :title => 'AAA', :url => '#')
    menu.menu_items.build(:lft => 20, :rgt => 21, :title => 'BBB', :url => '#')
    menu.menu_items.build(:lft => 22, :rgt => 23, :title => 'CCC', :url => '#')

    menu.menu_items.build(:lft => 26, :rgt => 33, :title => 'Outreach', :url => '#')
    menu.menu_items.build(:lft => 27, :rgt => 28, :title => 'AAA', :url => '#')
    menu.menu_items.build(:lft => 29, :rgt => 30, :title => 'BBB', :url => '#')
    menu.menu_items.build(:lft => 31, :rgt => 32, :title => 'CCC', :url => '#')

    menu.menu_items.build(:lft => 34, :rgt => 48, :title => 'Events', :url => '#')
    menu.menu_items.build(:lft => 35, :rgt => 36, :title => 'Conferences', :url => '#')
    menu.menu_items.build(:lft => 37, :rgt => 47, :title => 'Workshops', :url => '#')
    menu.menu_items.build(:lft => 38, :rgt => 44, :title => 'AAA', :url => '#')
    menu.menu_items.build(:lft => 40, :rgt => 41, :title => '111', :url => '#')
    menu.menu_items.build(:lft => 42, :rgt => 43, :title => '222', :url => '#')
    menu.menu_items.build(:lft => 45, :rgt => 46, :title => 'BBB', :url => '#')

    menu.save!
    # puts render_menu(menu)
    # puts CGI::pretty(render_menu(menu))

    # menu = Effective::Menu.new(:title => 'second menu')

    # menu.menu_items.build(:lft => 1, :rgt => 18, :title => 'Root', :url => '#')
    # menu.menu_items.build(:lft => 2, :rgt => 11, :title => 'Fruit', :url => '#')
    # menu.menu_items.build(:lft => 3, :rgt => 6, :title => 'Red', :url => '#')
    # menu.menu_items.build(:lft => 4, :rgt => 5, :title => 'Cherry', :url => '#')
    # menu.menu_items.build(:lft => 7, :rgt => 10, :title => 'Yellow', :url => '#')
    # menu.menu_items.build(:lft => 8, :rgt => 9, :title => 'Banana', :url => '#')
    # menu.menu_items.build(:lft => 12, :rgt => 17, :title => 'Meat', :url => '#')
    # menu.menu_items.build(:lft => 13, :rgt => 14, :title => 'Beef', :url => '#')
    # menu.menu_items.build(:lft => 15, :rgt => 16, :title => 'Pork', :url => '#')

    # menu.save!
    # puts render_menu(menu)


    menu = Effective::Menu.new(:title => 'easy menu').build do
      dropdown 'About' do
        item 'AAA'
        item 'BBB'
        dropdown 'More...' do
          item '111'
          item '222'
        end
      end

      dropdown 'Membership' do
        item 'AAA'
        item 'BBB'
      end
    end.save


    # puts "== FINAL == "
    # puts menu.menu_items.map { |item| "#{item.lft} #{item.title} #{item.rgt}"}

    # puts render_menu(menu)
    # #puts render_menu(menu)

    # menu = Effective::Menu.new(:title => 'third menu').build do
    #   dropdown 'About' do
    #     item 'AAA'
    #     item 'BBB'
    #   end

    #   dropdown 'Become a Member' do
    #     item '111'
    #     item '222'
    #   end
    # end

    # menu = Effective::Menu.new(:title => 'third menu').build do
    #   dropdown 'Events' do
    #     item 'Conferences'

    #     dropdown 'Workshops' do
    #       dropdown 'AAA' do
    #         item '111'
    #       end
    #       item 'BBB'
    #     end
    #   end
    # end.tap { |menu| menu.save! }

    # puts "== FINAL == "

    # puts render_menu('third menu')
    # puts menu.menu_items(true).map { |item| "#{item.lft} #{item.title} #{item.rgt}"}

  end
end
