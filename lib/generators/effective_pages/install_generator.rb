module EffectivePages
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Creates an EffectivePages initializer in your application.'

      source_root File.expand_path('../../templates', __FILE__)

      def self.next_migration_number(dirname)
        if not ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template ('../' * 3) + 'config/effective_pages.rb', 'config/initializers/effective_pages.rb'
      end

      def create_migration_file
        @pages_table_name = ':' + EffectivePages.pages_table_name.to_s
        @page_sections_table_name = ':' + EffectivePages.page_sections_table_name.to_s
        @page_banners_table_name = ':' + EffectivePages.page_banners_table_name.to_s
        @carousel_items_table_name = ':' + EffectivePages.carousel_items_table_name.to_s
        @alerts_table_name = ':' + EffectivePages.alerts_table_name.to_s
        @permalinks_table_name = ':' + EffectivePages.permalinks_table_name.to_s

        migration_template ('../' * 3) + 'db/migrate/01_create_effective_pages.rb.erb', 'db/migrate/create_effective_pages.rb'
      end

      def copy_example_page
        template 'example.html.haml', 'app/views/effective/pages/example.html.haml'
      end

      def setup_routes
        inject_into_file 'config/routes.rb', "\n  # if you want EffectivePages to render the home / root page\n  # uncomment the following line and create an Effective::Page with slug == 'home' \n  # root to: 'Effective::Pages#show', id: 'home'\n", :before => /root (:?)to.*/
      end

    end
  end
end
