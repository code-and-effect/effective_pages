# frozen_string_literal: true
module EffectiveCarouselsHelper

  def render_carousel(name, carousel_options = {})
    carousel = Array(EffectivePages.carousels).find { |carousel| carousel.to_s == name.to_s }

    if carousel.blank?
      raise("unable to find carousel #{name}. Please add it to config/initializers/effective_pages.rb")
    end

    render('effective/carousels/carousel', carousel: carousel, carousel_options: carousel_options)
  end

end
