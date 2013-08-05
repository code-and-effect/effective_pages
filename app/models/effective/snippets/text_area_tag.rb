module Effective
  module Snippets
    class TextAreaTag < Snippet
      attribute :label, String
      attribute :placeholder, String
      attribute :html_class, String

      def value_type
        String
      end

      def snippet_name
        'Text Area Tag'
      end

      def snippet_description
        'Standard form text area'
      end

    end
  end
end
