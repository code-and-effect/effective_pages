module Admin
  class PermalinksController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    page_title 'Permalinks'

    def permitted_params
      params.require(:effective_permalink).permit!
    end

  end
end
