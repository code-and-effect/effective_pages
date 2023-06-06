# frozen_string_literal: true

module EffectiveTagsHelper

  def acts_as_tagged?
    true
  end

  def tags_input(f, object)
    html = []
    if object.tags.exists?
      html << "Tags selected: <strong> #{object.tags.join(', ')} </strong>"
    else
      html << "No tags selected"
    end

    html << "<hr />"
    html << (f.select :tags, Effective::Tag.all.sorted, multiple: true)

    html.join("\n").html_safe
  end

end
