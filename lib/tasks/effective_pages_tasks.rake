# bundle exec rake effective_pages:seed
namespace :effective_pages do
  task :seed => :environment do
    include EffectiveMenusHelper

    return true if Effective::Menu.find_by_title('main menu').present?

    Effective::Menu.new(:title => 'main menu').build do
      dropdown 'About' do
        item '111'
        item '222'
        dropdown 'More...' do
          item '333'
          item '444'
        end
      end

      dropdown 'Pages' do
        item 'AAA'
        divider
        item 'BBB'
        item 'CCC'
        divider
        item 'DDD'
      end
    end.save!

  end
end
