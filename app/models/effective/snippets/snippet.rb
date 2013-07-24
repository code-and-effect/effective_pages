require 'virtus'

module Effective
  module Snippets
    class Snippet
      include ::Virtus

      attr_accessor :attributes
      attr_accessor :options

      attribute :required, Boolean
      attribute :value, String

      def initialize(attributes = {}, options = {})
        @attributes ||= attributes
        @options ||= options

        @attributes.each { |k, v| self.send("#{k}=", v) if respond_to?("#{k}=") }
      end

      # These are render options. For a controller to call render on.
      def render_params
        partial_path = "/effective/snippets/#{self.class.demodulized_class_name}/#{self.class.demodulized_class_name}"
        {:partial => partial_path, :locals => {self.class.demodulized_class_name => self}.merge(options)}
      end

      def page_form(controller)
        form = nil
        controller.view_context.semantic_form_for 'effective_page', :url => '/', :action => :show do |f| form = f end
        form
      end

      def required?
        self[:required] || false
      end

      class << self
        def demodulized_class_name
          @demodulized_class_name ||= self.name.demodulize.underscore.to_sym
        end

        # These are for the Snippet List panel in effective_mercury
        def snippet_name
          self.name.demodulize
        end

        def snippet_description
        end

        def snippet_image
        end

        def snippet_filter
          snippet_name
        end
      end
    end
  end
end
