module Admin
  class BannerAdsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    private

    def permitted_params
      params.require(:effective_banner_ad).permit!
    end

  end
end
