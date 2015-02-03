module EffectivePagesHelper

  def effective_pages_body_classes
    [
      params[:controller].parameterize,
      params[:action],
      ((user_signed_in? ? 'signed-in' : 'not-signed-in') rescue nil),
      (@page.template rescue nil),
      @body_classes
    ].compact.join(' ')
  end

  def effective_pages_header_tags
    [
      content_tag(:title, effective_pages_site_title),
      effective_pages_meta_description_tag
    ].compact.join("\n").html_safe
  end

  def effective_pages_site_title
    (@page_title ? @page_title.to_s : "#{params[:controller].try(:titleize)} #{params[:action].try(:titleize)}") + EffectivePages.site_title_suffix.to_s
  end

  def effective_pages_meta_description_tag
    if @page.try(:meta_description).present?
      "<meta content='#{@page.try(:meta_description)}' name='description' />"
    end
  end

  def application_root_to_effective_pages_slug
    Rails.application.routes.routes.find { |r| r.name == 'root' and r.defaults[:controller] == 'Effective::Pages' and r.defaults[:action] == 'show' }.defaults[:id] rescue nil
  end

end
