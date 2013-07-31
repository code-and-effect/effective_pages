require 'effective_pages/exceptions'

require 'effective_slugs'
require 'effective_mercury'

module EffectivePages
  class Engine < ::Rails::Engine
    engine_name 'effective_pages'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]

    # Include Helpers to base application
    initializer 'effective_pages.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper EffectivePagesHelper
        helper EffectiveRegionsHelper
      end
    end

    # Set up our default configuration options.
    initializer "effective_pages.defaults", :before => :load_config_initializers do |app|
      # Set up our defaults, as per our initializer template
      eval File.read("#{config.root}/lib/generators/templates/effective_pages.rb")
    end

    # Include acts_as_addressable concern and allow any ActiveRecord object to call it
    initializer 'effective_roles.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.extend(ActsAsEffectiveResourceController::ActionController)
      end
    end

    initializer "effective_pages.before_filters", :after => :load_config_initializers do |app|
      [EffectivePages.before_filter].flatten.compact.each do |filter|
        Effective::PagesController.class_eval { before_filter filter }
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
