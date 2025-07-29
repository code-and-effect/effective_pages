module Effective
  class BannerAdsController < ApplicationController
    include Effective::CrudController

    def show
      @banner_ad = Effective::BannerAd.find_by!(slug: params[:slug])

      authorize! :show, @banner_ad

      redirect_to @banner_ad.url, allow_other_host: true
    end
  end
end
