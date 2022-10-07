module Admin
  class PageSectionsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_page_section).permit!
    end

  end
end
