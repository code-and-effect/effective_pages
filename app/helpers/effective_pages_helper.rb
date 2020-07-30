module EffectivePagesHelper

  def effective_pages_body_classes
    [
      params[:controller].to_s.parameterize,
      params[:action],
      ((user_signed_in? ? 'signed-in'.freeze : 'not-signed-in'.freeze) rescue nil),
      (@page.template rescue nil),
      @body_classes
    ].compact.join(' ')
  end

  def effective_pages_header_tags
    tags = [
      content_tag(:title, effective_pages_site_title),
      tag(:meta, name: 'description', content: effective_pages_meta_description),
      tag(:meta, property: 'og:site_name',   content: EffectivePages.site_title.to_s),
      tag(:meta, property: 'og:title',       content: effective_pages_page_title),
      tag(:meta, property: 'og:url',         content: request.original_url),
      tag(:meta, property: 'og:type',        content: effective_pages_og_type),
      tag(:meta, property: 'og:description', content: effective_pages_meta_description),
      tag(:meta, itemprop: 'name', content: effective_pages_page_title),
      tag(:meta, itemprop: 'url', content: request.original_url),
      tag(:meta, itemprop: 'description', content: effective_pages_meta_description),
      tag(:meta, name: 'twitter:title', content: effective_pages_page_title),
      tag(:meta, name: 'twitter:url', content: request.original_url),
      tag(:meta, name: 'twitter:card', content: 'summary'),
      tag(:meta, name: 'twitter:description', content: effective_pages_meta_description),
    ]

    if EffectivePages.site_og_image.present?
      image_url = asset_url(EffectivePages.site_og_image)

      tags += [
        tag(:meta, property: 'og:image', content: image_url),
        tag(:meta, itemprop: 'thumbnailUrl', content: image_url),
        tag(:meta, itemprop: 'image', content: image_url),
        tag(:meta, name: 'twitter:image', content: image_url),
      ]

      if EffectivePages.site_og_image_width.present?
        tags << tag(:meta, property: 'og:image:width', content: EffectivePages.site_og_image_width)
      end

      if EffectivePages.site_og_image_height.present?
        tags << tag(:meta, property: 'og:image:height', content: EffectivePages.site_og_image_height)
      end
    end

    if effective_pages_canonical_url.present?
      tags << tag(:link, rel: 'canonical', href: effective_pages_canonical_url)
    end

    tags.compact.join("\n").html_safe
  end

  def effective_pages_page_title
    unless @page_title.present? || EffectivePages.silence_missing_page_title_warnings
      Rails.logger.error("WARNING: (effective_pages) Expected @page_title to be present. Please assign a @page_title variable in your controller action.")
    end

    (@page_title || "#{params[:controller].try(:titleize)} #{params[:action].try(:titleize)}")
  end

  def effective_pages_site_title
    effective_pages_page_title + (@site_title_suffix || EffectivePages.site_title_suffix).to_s
  end

  def effective_pages_meta_description
    unless @meta_description.present? || EffectivePages.silence_missing_meta_description_warnings
      Rails.logger.error("WARNING: (effective_pages) Expected @meta_description to be present. Please assign a @meta_description variable in your controller action.")
    end

    truncate((@meta_description || EffectivePages.fallback_meta_description).to_s, length: 150)
  end

  def effective_pages_canonical_url
    unless @canonical_url.present? || EffectivePages.silence_missing_canonical_url_warnings
      Rails.logger.error("WARNING: (effective_pages) Expected @canonical_url to be present. Please assign a @canonical_url variable in your controller action.")
    end

    @canonical_url
  end

  def effective_pages_og_type
    @effective_pages_og_type || 'website'
  end

  def application_root_to_effective_pages_slug
    Rails.application.routes.routes.find { |r| r.name == 'root' && r.defaults[:controller] == 'Effective::Pages' && r.defaults[:action] == 'show' }.defaults[:id] rescue nil
  end

end
