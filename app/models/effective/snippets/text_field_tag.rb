module Effective
  module Snippets
    class TextFieldTag < Snippet
      attribute :label, String
      attribute :maxlength, Integer
      attribute :placeholder, String
      attribute :html_class, String

      def value_type
        String
      end

      def snippet_name
        'Text Field Tag'
      end

      def snippet_image
        '/assets/effective_pages/text_field_tag.png'
      end

      def snippet_description
        'Standard form text field'
      end

    end
  end
end
