module EffectivePages
  class TemplateNotFound < StandardError
    attr_writer :template

    def initialize(template)
      @template = template
    end

    def to_s
      "Unable to find template '#{@template.to_s}'.  Make sure this template is defined in config/effective_pages.yml."
    end
  end
end
