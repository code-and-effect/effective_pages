module EffectivePages
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Creates an EffectivePages initializer in your application."

      source_root File.expand_path("../../templates", __FILE__)

      def self.next_migration_number(dirname)
        if not ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template "effective_pages.rb", "config/initializers/effective_pages.rb"
      end

      def create_migration_file
        @pages_table_name = ':' + EffectivePages.pages_table_name.to_s
        @menus_table_name = ':' + EffectivePages.menus_table_name.to_s
        @menu_items_table_name = ':' + EffectivePages.menu_items_table_name.to_s

        migration_template '../../../db/migrate/01_create_effective_pages.rb.erb', 'db/migrate/create_effective_pages.rb'
      end

      def copy_example_page
        template 'example.html.haml', 'app/views/effective/pages/example.html.haml'
      end

      def setup_routes
        inject_into_file "config/routes.rb", "\n  # if you want EffectivePages to render the home / root page\n  # uncomment the following line and create an Effective::Page with slug == 'home' \n  # root :to => 'Effective::Pages#show', :id => 'home'\n", :before => /root (:?)to.*/
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
