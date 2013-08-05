require 'virtus'

module Effective
  module Snippets
    class Snippet
      include ::Virtus

      attr_accessor :attributes
      attr_accessor :options

      attribute :name, String
      attribute :required, Boolean

      def initialize(attributes = {}, options = {})
        @attributes ||= attributes
        @options ||= options

        @attributes.each { |k, v| self.send("#{k}=", v) if respond_to?("#{k}=") }
      end

      # These are render options. For a controller to call render on.
      def render_params(render_options = {})
        partial_path = "/effective/snippets/#{self.class.demodulized_class_name}/#{self.class.demodulized_class_name}"
        {:partial => partial_path, :locals => {self.class.demodulized_class_name => self}.merge(options).merge(render_options)}
      end

      def page_form(controller)
        form = nil
        controller.view_context.simple_form_for Effective::PageForm.new([self]), :url => '/', :action => :show do |f| form = f end
        form
      end

      def value_type
        String
      end

      def required?
        self[:required] || false
      end

      def required_html_class
        required? ? 'required' : 'optional'
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
