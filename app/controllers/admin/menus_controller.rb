module Admin
  class MenusController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    helper EffectiveMenusAdminHelper

    if (config = EffectivePages.layout)
      layout(config.kind_of?(Hash) ? config[:admin] : config)
    end

  end
end
