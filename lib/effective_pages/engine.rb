module EffectivePages
  class Engine < ::Rails::Engine
    engine_name 'effective_pages'

    # Include acts_as_tagged concern and allow any ActiveRecord object to call it
    initializer 'effective_pages.active_record' do |app|
      app.config.to_prepare do
        ActiveSupport.on_load :active_record do
          ActiveRecord::Base.extend(ActsAsTagged::Base)
        end
      end
    end

    # Include Helpers to base application
    initializer 'effective_pages.action_controller' do |app|
      app.config.to_prepare do
        ActiveSupport.on_load :action_controller_base do
          helper EffectivePagesHelper
          helper EffectiveCarouselsHelper
          helper EffectivePageSectionsHelper
          helper EffectivePageBannersHelper
          helper EffectiveMenusHelper
          helper EffectiveAlertsHelper
          helper EffectivePermalinksHelper
          helper EffectiveTagsHelper
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
