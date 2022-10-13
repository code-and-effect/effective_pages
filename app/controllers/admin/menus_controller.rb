module Admin
  class MenusController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }


    include Effective::CrudController

    page_title 'Menus'

    resource_scope -> { Effective::Page.all }

    if (config = EffectivePages.layout)
      layout(config.kind_of?(Hash) ? config[:admin] : config)
    end

  end
end
