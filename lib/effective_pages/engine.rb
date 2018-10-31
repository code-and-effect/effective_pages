module EffectivePages
  class Engine < ::Rails::Engine
    engine_name 'effective_pages'

    # Include Helpers to base application
    initializer 'effective_pages.action_controller' do |app|
    end

    # Set up our default configuration options.
    initializer "effective_pages.defaults", before: :load_config_initializers do |app|
      # Set up our defaults, as per our initializer template
      eval File.read("#{config.root}/config/effective_pages.rb")
    end

    initializer 'effective_pages.effective_assets_validation', after: :load_config_initializers do
      if EffectivePages.acts_as_asset_box
        begin
          require 'effective_assets'
        rescue Exception
          raise "unable to load effective_assets.  Plese add gem 'effective_assets' to your Gemfile and then 'bundle install'"
        end
      end
    end

  end
end
