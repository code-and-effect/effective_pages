module Effective
  module Snippets
    class TextFieldTag < Snippet
      attribute :name, String
      attribute :maxlength, Integer
      attribute :placeholder, String
      attribute :html_class, String

      def value_type
        String
      end

    end
  end
end
