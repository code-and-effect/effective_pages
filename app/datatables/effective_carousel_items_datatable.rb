class EffectiveCarouselItemsDatatable < Effective::Datatable

  datatable do
    reorder :position

    col :id, visible: false
    col :updated_at, visible: false

    col :carousel, visible: false

    col :file, label: 'Image' do |carousel_item|
      image_tag(carousel_item.file, style: 'max-height: 100px;')
    end

    col :title
    col :rich_text_body, label: 'Content'

    col :link_label, visible: false
    col :link_url, visible: false
    col :caption, visible: false

    actions_col
  end

  collection do
    Effective::CarouselItem.deep.all.where(carousel: carousel)
  end

  def carousel
    carousel = EffectivePages.carousels.find { |carousel| carousel.to_s == attributes[:carousel].to_s }
    carousel || raise("unexpected carousel: #{attributes[:carousel] || 'none'}")
  end

end
