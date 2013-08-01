module Effective
  module Snippets
    class CheckBoxTag < Snippet
      attribute :label, String
      attribute :html_class, String

      def value_type
        Boolean
      end

      class << self
        def snippet_name
          'Check Box Tag'
        end

        def snippet_description
          'Standard form check box'
        end
      end

    end
  end
end
