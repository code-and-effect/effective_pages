module EffectivePagesHelper
  def effective_page_header_tags(options = {})
    @page ||= nil

    [ content_tag(:title, (@page_title || options[:title] || @page.try(:title))),
      "<meta content='#{options[:meta_description] || @page.try(:meta_description)}' name='description' />",
    ].join("\n").html_safe
  end

  def application_root_to_effective_pages_slug
    Rails.application.routes.routes.find { |r| r.name == 'root' and r.defaults[:controller] == 'Effective::Pages' and r.defaults[:action] == 'show' }.defaults[:id] rescue nil
  end

end
