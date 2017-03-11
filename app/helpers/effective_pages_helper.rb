module EffectivePagesHelper

  def effective_pages_body_classes
    [
      params[:controller].parameterize,
      params[:action],
      ((user_signed_in? ? 'signed-in'.freeze : 'not-signed-in'.freeze) rescue nil),
      (@page.template rescue nil),
      @body_classes
    ].compact.join(' ')
  end

  def effective_pages_header_tags
    [
      content_tag(:title, effective_pages_site_title),
      tag(:meta, name: 'description'.freeze, content: effective_pages_meta_description),
      tag(:meta, name: 'og:site_name', content:  EffectivePages.site_title.to_s),
      tag(:meta, name: 'og:title', content: effective_pages_page_title),
      tag(:meta, name: 'og:description', content: effective_pages_meta_description),
      tag(:meta, name: 'og:url', content: request.original_url),
      tag(:meta, name: 'og:image', content: asset_path( EffectivePages.site_opengraph_image.to_s))
    ].compact.join("\n").html_safe
  end

  def effective_pages_page_title
    unless @page_title.present? || EffectivePages.silence_missing_page_title_warnings
      Rails.logger.error("WARNING: (effective_pages) Expected @page_title to be present. Please assign a @page_title variable in your controller action.")
    end

    (@page_title || "#{params[:controller].try(:titleize)} #{params[:action].try(:titleize)}")
  end

  def effective_pages_site_title
    effective_pages_page_title + EffectivePages.site_title_suffix.to_s
  end

  def effective_pages_meta_description
    unless @meta_description.present? || EffectivePages.silence_missing_meta_description_warnings
      Rails.logger.error("WARNING: (effective_pages) Expected @meta_description to be present. Please assign a @meta_description variable in your controller action.")
    end

    truncate((@meta_description || EffectivePages.fallback_meta_description).to_s, length: 150)
  end

  def application_root_to_effective_pages_slug
    Rails.application.routes.routes.find { |r| r.name == 'root' && r.defaults[:controller] == 'Effective::Pages' && r.defaults[:action] == 'show' }.defaults[:id] rescue nil
  end

end
