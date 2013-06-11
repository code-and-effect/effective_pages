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

  def mercury_edit_path(path = nil)
    effective_pages.mercury_editor_path(path.nil? ? request.path.gsub(/^\/\/?(editor)?/, '') : path)
  end

end
