module EffectivePages
  class Engine < ::Rails::Engine
    engine_name 'effective_pages'

    # Include Helpers to base application
    initializer 'effective_assets.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper EffectivePagesHelper
      end
    end

    # Set up our default configuration options.
    initializer "effective_pages.defaults", :before => :load_config_initializers do |app|
      EffectivePages.setup do |config|
        config.pages_table_name = :pages
      end
    end

    # ActiveAdmin (optional)
    # This prepends the load path so someone can override the assets.rb if they want.
    initializer 'effective_pages.active_admin' do
      if defined?(ActiveAdmin)
        ActiveAdmin.application.load_paths.unshift Dir["#{config.root}/active_admin"]
      end
    end

  end
end
