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

      def render
        partial_path = "/effective/mercury/snippets/#{demodulized_class_name}/#{demodulized_class_name}"

        self.class.view.render :partial => partial_path, :locals => {demodulized_class_name => self}.merge(options)
      end

      def required?
        self[:required] || false
      end

      def self.view
        unless @view
          @view = ActionView::Base.new(ActionController::Base.view_paths, {})
          @view.instance_exec { def protect_against_forgery? ; false; end }
        end
        @view
      end

      def self.view=(view)
        @view = view
      end

      protected

      def demodulized_class_name
        @demodulized_class_name ||= self.class.name.demodulize.underscore.to_sym
      end
    end
  end
end
