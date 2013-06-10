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
end
