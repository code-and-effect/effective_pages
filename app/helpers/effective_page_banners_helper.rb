# frozen_string_literal: true

module EffectivePageBannersHelper

  def render_page_banner(page, opts = {}, &block)
    raise('expected a page') unless page.kind_of?(Effective::Page)

    return unless page.banner? || EffectivePages.banners_force_randomize

    # Always return a random banner if config.banners_force_randomize
    page_banner = Effective::PageBanner.random.first if EffectivePages.banners_force_randomize
    page_banner ||= page.page_banner if page.banner? && page.page_banner.present?
    page_banner ||= Effective::PageBanner.random.first if page.banner? && page.banner_random?

    raise("unable to find page banner for page #{page}") unless page_banner.present?

    if block_given?
      yield(page_banner); nil
    else
      image_tag(page_banner.file, alt: page_banner.caption, **opts)
    end
  end

end
