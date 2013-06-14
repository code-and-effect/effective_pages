module EffectivePages
  class TemplateNotFound < StandardError
    attr_writer :template

    def initialize(template)
      @template = template
    end

    def to_s
      "Unable to locate template '#{@template.to_s}'.  Make sure a file with this name exists in your views/templates/ directory."
    end
  end
end
