# frozen_string_literal: true

module EffectivePageSectionsHelper

  def effective_page_sections
    @_effective_page_sections ||= Effective::PageSection.all
  end

  def render_page_section(name, &block)
    raise('expected a name') unless name.present?

    name = name.to_s

    page_section = effective_page_sections.find { |ps| ps.name == name }
    raise("unable to find page section with name #{name}") unless page_section.present?

    if block_given?
      yield(page_section); nil
    else
      page_section.rich_text_body.to_s.html_safe
    end
  end

end
