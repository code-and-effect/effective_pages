# frozen_string_literal: true
module EffectiveCarouselsHelper

  def render_carousel(name, options = {}, &block)
    name = name.to_s
    carousel = Array(EffectivePages.carousels).find { |carousel| carousel.to_s == name }

    if carousel.blank?
      raise("unable to find carousel #{name}. Please add it to config/initializers/effective_pages.rb")
    end

    carousel_items = Effective::CarouselItem.sorted.deep.where(carousel: carousel)
    return if carousel_items.blank?

    if block_given?
      yield(carousel_items); nil
    else
      render('effective/carousels/carousel', carousel: carousel, carousel_items: carousel_items, carousel_options: options)
    end

  end

end
