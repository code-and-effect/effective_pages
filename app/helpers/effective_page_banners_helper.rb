# frozen_string_literal: true

module EffectivePageBannersHelper

  def render_page_banner(page, opts = {}, &block)
    raise('expected a page') unless page.kind_of?(Effective::Page)

    # Do nothing if page.banner is false
    return unless page.banner?

    page_banner = page.page_banner
    page_banner ||= Effective::PageBanner.random.first if page.banner_random?

    raise("unable to find page banner for page #{page}") unless page_banner.present?

    if block_given?
      yield(page_banner); nil
    else
      image_tag(page_banner.file, alt: page_banner.caption, **opts)
    end
  end

end
