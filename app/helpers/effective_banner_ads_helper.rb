# frozen_string_literal: true

module EffectiveBannerAdsHelper

  def effective_banner_ads
    @_effective_banner_ads ||= Effective::BannerAd.published.deep.all
  end

  def render_banner_ad(location, opts = {}, &block)
    location = EffectivePages.banner_ads.find { |obj| obj == location }
    raise("unknown banner ad location: #{location.presence || 'nil'}. Please add it to EffectivePages.banner_ads config option") if location.blank?

    banner_ads = effective_banner_ads.select { |ba| ba.location == location }
    banner_ad = banner_ads.sample

    if block_given?
      yield(banner_ad); nil
    else
      render('effective/banner_ads/banner_ad', banner_ad: banner_ad, banner_ad_opts: opts)
    end
  end

end
