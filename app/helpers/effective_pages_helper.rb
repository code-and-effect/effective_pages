module EffectivePagesHelper
  def effective_page_header_tags
    if @page
      [
        content_tag(:title, @page.title),
        "<meta content='#{@page.meta_description}' name='description' />",
        "<meta content='#{@page.meta_keywords}' name='keywords' />"
      ].join("\n").html_safe
    end
  end

  def application_root_to_effective_pages_slug
    Rails.application.routes.routes.find { |r| r.name == 'root' and r.defaults[:controller] == 'Effective::Pages' and r.defaults[:action] == 'show' }.defaults[:id] rescue nil
  end

  def page_region(region, options = {})
    mercury_region(region, options)
  end


end
