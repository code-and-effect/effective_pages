module Effective
  module Snippets
    class TextFieldTag < Snippet
      attribute :maxlength, Integer
      attribute :placeholder, String
      attribute :html_class, String

      def value_type
        String
      end

      class << self
        def snippet_name
          'Text Field Tag'
        end

        def snippet_description
          'Standard form text field'
        end
      end

    end
  end
end
