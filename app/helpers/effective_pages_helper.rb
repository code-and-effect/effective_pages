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
    type = options.delete(:type) || :full
    tag = options.delete(:tag) || :div

    opts = {:id => region, 'data-mercury' => type.to_s}.merge(options)

    if request.fullpath.include?('mercury_frame') # If we need the editable div
      content_tag(tag, opts) do
        content_for?(region) ? content_for(region) : ((yield and '') if block_given?)
      end
    else
      content_for?(region) ? content_for(region) : ((yield and '') if block_given?)
    end
  end


end
