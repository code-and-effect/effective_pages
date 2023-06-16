module Admin
  class TagsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_tag).permit!
    end

  end
end
