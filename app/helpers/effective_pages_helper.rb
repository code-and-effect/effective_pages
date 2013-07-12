module EffectivePagesHelper
  def effective_page_header_tags(options = {})
    @page ||= nil

    [ content_tag(:title, options[:title] || @page.try(:title)),
      "<meta content='#{options[:meta_description] || @page.try(:meta_description)}' name='description' />",
      "<meta content='#{options[:meta_keywords] || @page.try(:meta_keywords)}' name='keywords' />"
    ].join("\n").html_safe
  end

  def application_root_to_effective_pages_slug
    Rails.application.routes.routes.find { |r| r.name == 'root' and r.defaults[:controller] == 'Effective::Pages' and r.defaults[:action] == 'show' }.defaults[:id] rescue nil
  end

  # For use in formtastic forms
  # Full selector, starts with f.inputs
  # You must include the effective_pages css and javascript files for this to work
  def effective_pages_template_selector(form, options = {})
    opts = {:f => form}.merge(options)
    render :partial => 'effective/pages/template_selector', :locals => opts
  end

  # Just a select box
  def effective_pages_template_select(form, options = {})
    opts = {:f => form}.merge(options)
    render :partial => 'effective/pages/template_select', :locals => opts
  end

  def _effective_pages_template_select_collection
    Hash[EffectivePages.templates.map { |template, _| [(EffectivePages.templates_info[template][:label] rescue template), template]}]
  end

end
