# frozen_string_literal: true

module EffectivePermalinksHelper

  def permalinks
    @_effective_permalinks ||= Effective::Permalink.deep.order(:id)
  end

  def permalink_to(permalink_or_slug, options = {})
    permalink =
      if permalink_or_slug.kind_of?(String)
        Effective::Permalink.find_by(slug: slug)
      else
        permalink_or_slug
      end

    link_to permalink, permalink.redirect_url, options
  end

end
