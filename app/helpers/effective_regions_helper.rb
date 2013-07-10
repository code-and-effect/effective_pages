module EffectiveRegionsHelper
  def page_region(region, options = {}, snippet_options = {})
    html = (if block_given?
      mercury_region(region, options) { yield }
    else
      mercury_region(region, options)
    end)

    snippets = html.scan(/\[snippet_\d+\/\d+\]/).flatten  # Find [snippet_1/1]
    snippets.each { |snippet| html.gsub!(snippet, snippet_content(snippet, @page, snippet_options))}
    html.html_safe
  end


  def simple_page_region(region, options = {})
    options.merge!(:type => :simple)

    if block_given?
      mercury_region(region, options) { yield }
    else
      mercury_region(region, options)
    end
  end

  def snippet_page_region(region, options = {})
    options.merge!(:type => :snippets)

    if block_given?
      mercury_region(region, options) { yield }
    else
      mercury_region(region, options)
    end
  end

  private

  def snippet_content(code, page, options = {})
    return code unless page.present?

    key = code.scan(/\[(snippet_\d+)\/\d+\]/).flatten.first # captures [(snippet_1)/1]

    snippet = page.snippets[key] || {}
    klass = "Effective::Snippets::#{snippet[:name].try(:classify)}".safe_constantize

    return code unless klass

    klass.new(snippet[:options], options).render()
  end

end
