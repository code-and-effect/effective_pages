module EffectivePages
  class Engine < ::Rails::Engine
    engine_name 'effective_pages'

    # Include Helpers to base application
    initializer 'effective_pages.action_controller' do |app|
      app.config.to_prepare do
        ActiveSupport.on_load :action_controller_base do
          helper EffectivePagesHelper
          helper EffectiveCarouselsHelper
          helper EffectivePageSectionsHelper
          helper EffectivePageBannersHelper
          helper EffectiveMenusHelper
        end
      end
    end

    # Set up our default configuration options.
    initializer "effective_pages.defaults", before: :load_config_initializers do |app|
      # Set up our defaults, as per our initializer template
      eval File.read("#{config.root}/config/effective_pages.rb")
    end

  end
end
